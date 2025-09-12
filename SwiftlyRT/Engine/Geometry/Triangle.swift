//
//  Triangle.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class Triangle: Shape {

    static func equals(lhs: Triangle, rhs: Triangle) -> Bool {
        return lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2 && lhs.p3 == rhs.p3
    }

    override init() {
        super.init()

        computeNormal()
    }

    init(point1: Tuple, point2: Tuple, point3: Tuple) {
        super.init()

        assert(point1.isPoint())
        assert(point2.isPoint())
        assert(point3.isPoint())

        self.suspendComputation = true
        p1 = point1
        p2 = point2
        p3 = point3
        self.suspendComputation = false
        computeNormal()
    }

    internal func computeNormal() {
        if self.suspendComputation {
            return
        }

        e1 = p2 - p1
        e2 = p3 - p1
        normal = Tuple.cross(lhs: e2, rhs: e1).normalized()
    }

    override func localIntersects(ray: Ray) -> [Intersection] {
        let dirCrossE2 = Tuple.cross(lhs: ray.direction, rhs: e2)
        let det = Tuple.dot(lhs: e1, rhs: dirCrossE2)

        if abs(det) < Tuple.epsilon {
            return []
        }

        let f = 1.0 / det

        let p1ToOrigin = ray.origin - p1
        let u = f * Tuple.dot(lhs: p1ToOrigin, rhs: dirCrossE2)

        if u < 0 || u > 1 {
            return []
        }

        let originCrossE1 = Tuple.cross(lhs: p1ToOrigin, rhs: e1)
        let v = f * Tuple.dot(lhs: ray.direction, rhs: originCrossE1)

        if v < 0 || (u + v) > 1 {
            return []
        }

        let t = f * Tuple.dot(lhs: e2, rhs: originCrossE1)
        return [Intersection(t: t, object: self, u: u, v: v)]
    }

    override func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        return normal
    }

    override func boundingBox() -> BoundingBox {
        if bounds == nil {
            var box = BoundingBox()
            box.addPoint(point: p1)
            box.addPoint(point: p2)
            box.addPoint(point: p3)
            bounds = box
        }

        return bounds!
    }

    var p1: Tuple = Tuple.pointZero {
        didSet {
            computeNormal()
        }
    }

    var p2: Tuple = Tuple.pointZero {
        didSet {
            computeNormal()
        }
    }

    var p3: Tuple = Tuple.pointZero {
        didSet {
            computeNormal()
        }
    }

    internal var suspendComputation = false

    private(set) var normal = Tuple.zero
    private(set) var e1 = Tuple.zero
    private(set) var e2 = Tuple.zero
}
