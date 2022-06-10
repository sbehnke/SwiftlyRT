//
//  BlendedPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class BlendedPattern: Pattern {

    init(a: Pattern, b: Pattern) {
        self.a = a
        self.b = b
    }

    override func patternAt(point: Tuple) -> Color {
        let colorA = a.patternAt(point: point)
        let colorB = b.patternAt(point: point)
        return (colorA + colorB) / 2.0
    }

    var a = Pattern()
    var b = Pattern()
}
