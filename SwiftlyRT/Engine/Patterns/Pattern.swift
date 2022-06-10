//
//  Pattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Pattern: Equatable {
    static func == (lhs: Pattern, rhs: Pattern) -> Bool {
        return lhs === rhs
    }

    func uvPatternAt(u: Double, v: Double) -> Color {
        return Color.black
    }

    func patternAt(point: Tuple) -> Color {
        return point.toColor()
    }

    func patternAtShape(object: Shape?, point: Tuple) -> Color {
        if let o = object {
            return patternAt(point: self.inverseTransform * o.inverseTransform * point)
        }

        return patternAt(point: self.inverseTransform * point)
    }

    var transform = Matrix4x4.identity {
        didSet {
            inverseTransform = transform.inversed()
        }
    }

    private(set) var inverseTransform = Matrix4x4.identity
}
