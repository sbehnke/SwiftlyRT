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
    init() {}

    func setDimensions(width: Int, height: Int) {
        self.width = width
        self.height = height

        dest = Canvas(width: width, height: height)
        progress = 0
    }

    func addChunk(chunk: CanvasChunk) {
        chunks.append(chunk)
        progress += 1
    }

    func applyChunks() {
        guard let dest = dest else { return }

        while !chunks.isEmpty {
            let chunk = chunks.popLast()
            if let chunk = chunk {
                dest.setPixels(source: chunk.canvas, destX: chunk.x, destY: chunk.y)
                chunksApplied += 1
            }
        }
    }

    func getImage() -> Data? {
        guard let dest = dest else { return nil }

        applyChunks()

        return dest.getPPM()
    }

    var chunkCount: Int {
        get {
            progress
        }
    }

    var total: Int {
        get {
            return Int((Double(width) / Double(RenderResults.sizeX)).rounded(.up) * (Double(height) / Double(RenderResults.sizeY)).rounded(.up))
        }
    }

    var isFinished: Bool {
        get {
            return chunksApplied >= total
        }
    }

    static let sizeX: Int = 16
    static let sizeY: Int = 16

    private var dest: Canvas?

    private var finished: Bool = false
    private var chunksApplied: Int = 0

    var width: Int = 0
    var height: Int = 0
    var progress: Int = 0
    var chunks: [CanvasChunk] = [CanvasChunk]()
}
