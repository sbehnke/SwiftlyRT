//
//  Ray.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Ray {

    init(origin: Tuple, direction: Tuple) {
        assert(origin.isPoint())
        assert(direction.isVector())

        self.origin = origin
        self.direction = direction
    }

    func position(time: Double) -> Tuple {
        return origin + direction * time
    }

    func translate(vector: Tuple) -> Ray {
        assert(vector.isVector())
        let transform = Matrix4x4.translated(x: vector.x, y: vector.y, z: vector.z)
        return transform * self
    }

    func scale(vector: Tuple) -> Ray {
        assert(vector.isVector())
        let transform = Matrix4x4.scaled(x: vector.x, y: vector.y, z: vector.z)
        return transform * self
    }

    var origin = Tuple.Point()
    var direction = Tuple.Vector()
}
