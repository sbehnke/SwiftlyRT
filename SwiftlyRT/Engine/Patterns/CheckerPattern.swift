//
//  CheckerPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class CheckerPattern: Pattern {

    init(a: Color, b: Color) {
        self.a = a
        self.b = b
    }

    override func patternAt(point: Tuple) -> Color {
        let sum = floor(point.x) + floor(point.y) + floor(point.z)
        if sum.modulo(2.0) == 0.0 {
            return a
        } else {
            return b
        }
    }

    override func uvPatternAt(u: Double, v: Double) -> Color {

        let u2 = floor(u * width)
        let v2 = floor(v * height)

        if (u2 + v2).modulo(2.0) == 0 {
            return a
        } else {
            return b
        }
    }

    var height = 1.0
    var width = 1.0
    var a = Color.white
    var b = Color.white
}
