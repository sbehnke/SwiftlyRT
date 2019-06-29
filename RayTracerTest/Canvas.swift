//
//  Canvas.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation


class Canvas {
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        pixels = Array<Color>(repeating: Color(), count: width * height)
    }
    
    func setPixel(x: Int, y: Int, color: Color) {
        pixels[x + (y * width)] = color;
    }
    
    func getPixel(x: Int, y: Int) -> Color {
        return pixels[x + (y * width)];
    }
    
    private func clamp(value : Double) -> Double {
        if (value > 1.0) {
            return 1.0
        } else if (value < 0.0) {
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
        
        var stride = 0;
        var row = String()
        
        for pixel in pixels {
            let r = Int(round(255.0 * clamp(value: pixel.r)))
            let g = Int(round(255.0 * clamp(value: pixel.g)))
            let b = Int(round(255.0 * clamp(value: pixel.b)))
            
            if (row.count + String(r).count >= maxRow) {
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
            row.write("\(r) ")
            
            if (row.count + String(g).count >= maxRow) {
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
            row.write("\(g) ")
            
            if (row.count + String(b).count >= maxRow) {
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
            row.write("\(b) ")
            stride += 1
            
            if (stride >= width) {
                stride = 0
                row.removeLast()
                row.write("\n")
                output.write(row)
                row = String()
            }
        }
        
        return output.data(using: .ascii)!
    }
    
    var width : Int = 0
    var height : Int = 0
    var pixels : [Color]
}
