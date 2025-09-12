//
//  SolidColorPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class SolidColorPattern: Pattern {

    init(_ a: Color) {
        self.a = a
    }

    override func patternAt(point: Tuple) -> Color {
        return a
    }

    var a = Color()
}
