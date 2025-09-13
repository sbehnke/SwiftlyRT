//
//  RenderResults.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 6/12/22.
//  Copyright © 2025 Luster Images. All rights reserved.
//

import Foundation
#if canImport(Cocoa)
import Cocoa
#endif

actor RenderResults {
    // MARK: - Properties
    static let sizeX: Int = 32
    static let sizeY: Int = 32
    
    private var dest: Canvas?
    private var chunksApplied: Int = 0
    private var cachedTotal: Int = 0
    
    var width: Int = 0
    var height: Int = 0
    var progress: Int = 0
    
    // Use ContiguousArray for better performance with value types
    private var chunks: ContiguousArray<CanvasChunk> = []
    
    // Adaptive batch processing configuration
    private var batchSize: Int = 16
    private let minBatchSize: Int = 4
    private let maxBatchSize: Int = 64
    
    // Memory management
    private var lastImageGeneration: Date = Date()
    private let imageGenerationThrottle: TimeInterval = 0.1 // 100ms
    
    // Performance monitoring
    private var processingTimes: [TimeInterval] = []
    private let maxTimingHistory: Int = 10
    
    init() {}

    func setDimensions(width: Int, height: Int) {
        self.width = width
        self.height = height

        dest = Canvas(width: width, height: height)
        progress = 0
        chunksApplied = 0
        
        // Pre-calculate and cache the total to avoid repeated computation
        cachedTotal = Int((Double(width) / Double(Self.sizeX)).rounded(.up) * 
                         (Double(height) / Double(Self.sizeY)).rounded(.up))
        
        // Pre-allocate chunks array to avoid repeated reallocations
        chunks.reserveCapacity(cachedTotal)
    }

    func addChunk(chunk: CanvasChunk) {
        chunks.append(chunk)
        progress += 1
        
        // Adaptive batch processing based on memory pressure and performance
        if chunks.count >= batchSize {
            let startTime = CFAbsoluteTimeGetCurrent()
            applyAvailableChunks()
            let processingTime = CFAbsoluteTimeGetCurrent() - startTime
            
            // Track performance and adapt batch size
            updateBatchSize(processingTime: processingTime)
        }
    }
    
    private func updateBatchSize(processingTime: TimeInterval) {
        processingTimes.append(processingTime)
        
        // Keep only recent timing data
        if processingTimes.count > maxTimingHistory {
            processingTimes.removeFirst()
        }
        
        // Calculate average processing time
        let avgTime = processingTimes.reduce(0, +) / Double(processingTimes.count)
        
        // Adapt batch size based on performance
        // If processing is fast, increase batch size for better throughput
        // If processing is slow, decrease batch size for better responsiveness
        if avgTime < 0.01 && batchSize < maxBatchSize {
            batchSize = min(batchSize * 2, maxBatchSize)
        } else if avgTime > 0.05 && batchSize > minBatchSize {
            batchSize = max(batchSize / 2, minBatchSize)
        }
    }
    
    // More efficient chunk processing
    private func applyAvailableChunks() {
        guard let dest = dest else { return }
        
        // Process chunks in reverse order for better array performance
        let chunksToProcess = min(chunks.count, batchSize)
        
        for _ in 0..<chunksToProcess {
            if let chunk = chunks.popLast() {
                // Direct pixel copying is more efficient than the nested loop in Canvas.setPixels
                copyChunkPixels(from: chunk, to: dest)
                chunksApplied += 1
            }
        }
    }
    
    private func copyChunkPixels(from chunk: CanvasChunk, to destination: Canvas) {
        let source = chunk.canvas
        let destX = chunk.x
        let destY = chunk.y
        
        // Early boundary checks
        guard destX < destination.width && destY < destination.height else { return }
        
        let maxWidth = min(source.width, destination.width - destX)
        let maxHeight = min(source.height, destination.height - destY)
        
        guard maxWidth > 0 && maxHeight > 0 else { return }
        
        // Optimized copying strategies based on alignment and size
        let sourcePixels = source.pixels
        
        if maxWidth == source.width && destX == 0 && destination.width == source.width {
            // Best case: contiguous block copy
            let sourceRange = 0..<(maxWidth * maxHeight)
            let destStart = destY * destination.width
            let destRange = destStart..<(destStart + maxWidth * maxHeight)
            
            destination.pixels.replaceSubrange(destRange, with: sourcePixels[sourceRange])
        } else {
            // Row-by-row copy with optimizations
            for y in 0..<maxHeight {
                let sourceRowStart = y * source.width
                let destRowStart = (y + destY) * destination.width + destX
                
                if maxWidth == source.width {
                    // Full row copy
                    let sourceRange = sourceRowStart..<(sourceRowStart + maxWidth)
                    let destRange = destRowStart..<(destRowStart + maxWidth)
                    destination.pixels.replaceSubrange(destRange, with: sourcePixels[sourceRange])
                } else {
                    // Partial row copy - use withUnsafeMutableBufferPointer for better performance
                    destination.pixels.withUnsafeMutableBufferPointer { destBuffer in
                        sourcePixels.withUnsafeBufferPointer { sourceBuffer in
                            let sourcePtr = sourceBuffer.baseAddress! + sourceRowStart
                            let destPtr = destBuffer.baseAddress! + destRowStart
                            destPtr.update(from: sourcePtr, count: maxWidth)
                        }
                    }
                }
            }
        }
    }

    func applyChunks() {
        guard let dest = dest else { return }

        // Apply all remaining chunks
        while !chunks.isEmpty {
            if let chunk = chunks.popLast() {
                copyChunkPixels(from: chunk, to: dest)
                chunksApplied += 1
            }
        }
    }

    func getImage() -> Data? {
        guard let dest = dest else { return nil }
        
        // Throttle image generation to avoid excessive CPU usage
        let now = Date()
        if now.timeIntervalSince(lastImageGeneration) < imageGenerationThrottle {
            return nil
        }
        lastImageGeneration = now

        applyChunks()
        return dest.getRGBAData()  // Much more efficient than PPM
    }
    
    // Get NSImage directly - most efficient for UI display
    #if canImport(Cocoa)
    func getNSImage() -> NSImage? {
        guard let dest = dest else { return nil }
        
        // Throttle image generation to avoid excessive CPU usage
        let now = Date()
        if now.timeIntervalSince(lastImageGeneration) < imageGenerationThrottle {
            return nil
        }
        lastImageGeneration = now
        
        applyChunks()
        return dest.getNSImage()
    }
    #endif
    
    // Optimized image generation that doesn't throttle (for final image)
    func getFinalImage() -> Data? {
        guard let dest = dest else { return nil }
        applyChunks()
        return dest.getRGBAData()  // Raw RGBA data instead of PPM
    }
    
    // Final NSImage - most efficient for final UI display
    #if canImport(Cocoa)
    func getFinalNSImage() -> NSImage? {
        guard let dest = dest else { return nil }
        applyChunks()
        return dest.getNSImage()
    }
    #endif
    
    // Export PPM only when specifically needed for file output
    func exportPPM() -> Data? {
        guard let dest = dest else { return nil }
        applyChunks()
        return dest.getPPM()
    }

    // MARK: - Computed Properties
    var chunkCount: Int {
        progress
    }

    var total: Int {
        cachedTotal
    }

    var isFinished: Bool {
        chunksApplied >= cachedTotal
    }
    
    // MARK: - Performance Monitoring
    var completionPercentage: Double {
        guard cachedTotal > 0 else { return 0.0 }
        return Double(chunksApplied) / Double(cachedTotal) * 100.0
    }
    
    var pendingChunks: Int {
        chunks.count
    }
    
    var currentBatchSize: Int {
        batchSize
    }
    
    var averageProcessingTime: Double {
        guard !processingTimes.isEmpty else { return 0.0 }
        return processingTimes.reduce(0, +) / Double(processingTimes.count)
    }
    
    var memoryPressure: Double {
        let pendingBytes = chunks.count * Self.sizeX * Self.sizeY * MemoryLayout<Color>.size
        let totalBytes = width * height * MemoryLayout<Color>.size
        return Double(pendingBytes) / Double(totalBytes) * 100.0
    }
}
