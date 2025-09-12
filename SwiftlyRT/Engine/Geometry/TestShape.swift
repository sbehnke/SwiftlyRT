//
//  TestShape.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class TestShape: Shape {

    override func localIntersects(ray: Ray) -> [Intersection] {
        savedRay = ray
        return []
    }

    override func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        return p - Tuple.pointZero
    }

    override func boundingBox() -> BoundingBox {
        if bounds == nil {
            bounds = BoundingBox(
                minimum: .Point(x: -1, y: -1, z: -1), maximum: .Point(x: 1, y: 1, z: 1))
        }

        return bounds!
    }

    var savedRay: Ray? = nil
}
