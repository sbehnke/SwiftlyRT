//
//  Canvas.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Canvas: @unchecked Sendable {

    init(width: Int, height: Int, color: Color = Color()) {
        self.width = width
        self.height = height

        pixels = [Color](repeating: color, count: width * height)
    }

    init(width: Int, height: Int, pixels: [Color]) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }

    convenience init?(fromUrl: URL?) {
        if let path = fromUrl {
            do {
                let contents: String = try String.init(contentsOf: path, encoding: .ascii)
                self.init(fromString: contents)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }

    init?(fromString: String) {
        var w = 0
        var h = 0
        var divisor = 0

        let lines = fromString.lines

        var readHeader = false
        var readDimension = false
        var readDivisor = false

        var pixelData = [Float]()

        if lines.count >= 0 {
            for index in 0..<lines.count {
                if lines[index].hasPrefix("#") {
                    continue
                }

                if !readHeader {
                    if lines[index] == "P3" {
                        readHeader = true
                        continue
                    } else {
                        return nil
                    }
                }

                if readHeader && !readDimension {
                    let sizeLines = lines[index].split(separator: " ")
                    if sizeLines.count == 2 {
                        w = Int(sizeLines[0]) ?? 0
                        h = Int(sizeLines[1]) ?? 0
                    }

                    if w > 0 && h > 0 {
                        readDimension = true
                        width = w
                        height = h

                        pixels = [Color](repeating: Color(), count: w * h)
                        continue
                    } else {
                        return nil
                    }
                }

                if readHeader && readDimension && !readDivisor {
                    divisor = Int(lines[index]) ?? 0

                    if divisor > 0 {
                        readDivisor = true
                        continue
                    } else {
                        return nil
                    }
                }

                if readHeader && readDimension && readDivisor {
                    let components = lines[index].split(separator: " ")
                    pixelData.append(
                        contentsOf: components.map { Float(Int($0) ?? 0) / Float(divisor) })
                    continue
                }
            }
        }

        if pixelData.count == 0 {
            return nil
        } else {
            var index = 0
            for rgbIndex in stride(from: 0, to: pixelData.count, by: 3) {
                let color = Color(
                    r: pixelData[rgbIndex], g: pixelData[rgbIndex + 1], b: pixelData[rgbIndex + 2])
                pixels[index] = color
                index += 1
            }
        }
    }

    func indexIsValid(x: Int, y: Int) -> Bool {
        return x >= 0 && x < width && y >= 0 && y < height
    }

    var count: Int {
        return pixels.count
    }

    subscript(_ index: Int) -> Color {
        get {
            assert(index >= 0 && index < pixels.count)
            return pixels[index]
        }
        set {
            assert(index >= 0 && index < pixels.count)
            pixels[index] = newValue
        }
    }

    subscript(x: Int, y: Int) -> Color {
        get {
            assert(indexIsValid(x: x, y: y), "Index out of range")
            return pixels[(y * width) + x]
        }
        set {
            assert(indexIsValid(x: x, y: y), "Index out of range")
            pixels[(y * width) + x] = newValue
        }
    }

    func setPixel(x: Int, y: Int, color: Color) {
        pixels[x + (y * width)] = color
    }

    func getPixel(x: Int, y: Int) -> Color {
        return pixels[x + (y * width)]
    }

    func setPixels(source: Canvas, destX: Int = 0, destY: Int = 0) {
        for y in 0..<source.height {
            if y + destY >= self.height {
                continue
            }

            for x in 0..<source.width {
                if x + destX >= self.width {
                    continue
                }

                pixels[(x + destX) + ((y + destY) * width)] = source[x, y]
            }
        }
    }

    private func clamp(value: Double) -> Double {
        if value > 1.0 {
            return 1.0
        } else if value < 0.0 {
            return 0
        }

        return value
    }

    func getPPM() -> Data {
        let maxRow = 70
        var output = String()
        output.write("P3\n")
        output.write("\(width) \(height)\n")
        output.write("255\n")

        var stride = 0
        var row = String()

        for pixel in pixels {
            let r = pixel.rByte
            let g = pixel.gByte
            let b = pixel.bByte

            if row.count + String(r).count >= maxRow {
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
            row.write("\(r) ")

            if row.count + String(g).count >= maxRow {
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
            row.write("\(g) ")

            if row.count + String(b).count >= maxRow {
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
            row.write("\(b) ")
            stride += 1

            if stride >= width {
                stride = 0
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
        }

        return output.data(using: .ascii)!
    }

    var width: Int = 0
    var height: Int = 0
    var pixels: [Color] = []
}
