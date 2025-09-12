//
//  GradientPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class GradientPattern: Pattern {

    init(a: Color, b: Color) {
        self.a = a
        self.b = b
    }

    override func patternAt(point: Tuple) -> Color {
        let distance = b - a
        let fraction = point.x - floor(point.x)
        return a + (distance * fraction)
    }

    var a = Color()
    var b = Color()
}
