//
//  RenderResults.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 6/12/22.
//  Copyright © 2022 Luster Images. All rights reserved.
//

import Foundation
import Cocoa

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

    func getImage() -> NSImage? {
        guard let dest = dest else { return nil }

        while !chunks.isEmpty {
            let chunk = chunks.popLast()
            if let chunk = chunk {
                dest.setPixels(source: chunk.canvas, destX: chunk.x, destY: chunk.y)
                chunksApplied += 1
            }
        }

        let data = dest.getPPM()
        return NSImage(data: data)
    }

    var chunkCount: Int {
        get {
            progress
        }
    }

    var total: Int {
        get {
            let sizeX = 16
            let sizeY = 16

            return Int(ceil(Double(width * height) / Double((sizeX * sizeY))))
        }
    }

    var isFinished: Bool {
        get {
            return chunksApplied == total
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
