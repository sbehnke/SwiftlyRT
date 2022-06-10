//
//  SmoothTriangle.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class SmoothTriangle: Triangle {
    static func equals(lhs: SmoothTriangle, rhs: SmoothTriangle) -> Bool {
        return lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2 && lhs.p3 == rhs.p3 && lhs.n1 == rhs.n1
            && lhs.n2 == rhs.n2 && lhs.n3 == rhs.n3
    }

    override init() {
        super.init()
        computeNormal()
    }

    init(
        point1: Tuple, point2: Tuple, point3: Tuple, normal1: Tuple, normal2: Tuple, normal3: Tuple
    ) {
        super.init()
        self.suspendComputation = true

        assert(point1.isPoint())
        assert(point2.isPoint())
        assert(point3.isPoint())

        assert(normal1.isVector())
        assert(normal2.isVector())
        assert(normal3.isVector())

        p1 = point1
        p2 = point2
        p3 = point3
        n1 = normal1
        n2 = normal2
        n3 = normal3

        self.suspendComputation = false
        computeNormal()
    }

    override func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        return n2 * hit.u + n3 * hit.v + n1 * (1 - hit.u - hit.v)
    }

    private(set) var n1 = Tuple.Vector()
    private(set) var n2 = Tuple.Vector()
    private(set) var n3 = Tuple.Vector()
}
