//
//  CubeMapPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class CubeMapPattern: Pattern {

    init(
        left: Pattern?, front: Pattern?, right: Pattern?, back: Pattern?, up: Pattern?,
        down: Pattern?
    ) {
        self.left = left
        self.front = front
        self.right = right
        self.back = back
        self.up = up
        self.down = down
    }

    func uvPatternAt(face: Face, u: Double, v: Double) -> Color {
        switch face {
        case .Front:
            return front?.uvPatternAt(u: u, v: v) ?? Color.white
        case .Back:
            return back?.uvPatternAt(u: u, v: v) ?? Color.white
        case .Left:
            return left?.uvPatternAt(u: u, v: v) ?? Color.white
        case .Right:
            return right?.uvPatternAt(u: u, v: v) ?? Color.white
        case .Up:
            return up?.uvPatternAt(u: u, v: v) ?? Color.white
        case .Down:
            return down?.uvPatternAt(u: u, v: v) ?? Color.white
        }
    }

    override func patternAt(point: Tuple) -> Color {
        let face = point.faceFromPoint()

        var u = 0.0
        var v = 0.0

        switch face {
        case .Front:
            (u, v) = point.cubeUvFront()
        case .Back:
            (u, v) = point.cubeUvBack()
        case .Left:
            (u, v) = point.cubeUvLeft()
        case .Right:
            (u, v) = point.cubeUvRight()
        case .Up:
            (u, v) = point.cubeUvUp()
        case .Down:
            (u, v) = point.cubeUvDown()
        }

        return uvPatternAt(face: face, u: u, v: v)
    }

    var left: Pattern? = nil
    var front: Pattern? = nil
    var right: Pattern? = nil
    var back: Pattern? = nil
    var up: Pattern? = nil
    var down: Pattern? = nil
}
