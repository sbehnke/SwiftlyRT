//
//  Sphere.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class Sphere: Shape {

    static func GlassSphere() -> Sphere {
        //    Scenario: A helper for producing a sphere with a glassy material
        //    Given s ← glass_sphere()
        //    Then s.transform = identity_matrix
        //    And s.material.transparency = 1.0
        //    And s.material.refractive_index = 1.5

        let s = Sphere()
        s.transform = Matrix4x4.identity
        s.material.transparency = 1.0
        s.material.refractiveIndex = 1.5
        return s
    }

    override func boundingBox() -> BoundingBox {
        if bounds == nil {
            bounds = BoundingBox(
                minimum: Tuple.Point(x: -1, y: -1, z: -1), maximum: Tuple.Point(x: 1, y: 1, z: 1))
        }

        return bounds!
    }

    override func localIntersects(ray: Ray) -> [Intersection] {
        // Vector from sphere's center to the ray origin
        // the sphere is centered at the world origin
        let sphereToRay = ray.origin - Tuple.pointZero

        let a = ray.direction.dot(ray.direction)
        let b = 2 * ray.direction.dot(sphereToRay)
        let c = sphereToRay.dot(sphereToRay) - 1

        let discriminant = b * b - 4 * a * c

        if discriminant < 0 {
            return []
        }
        let intersection1 = (-b - sqrt(discriminant)) / (2 * a)
        let intersection2 = (-b + sqrt(discriminant)) / (2 * a)

        return [
            Intersection(t: intersection1, object: self),
            Intersection(t: intersection2, object: self),
        ]
    }

    override func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        return p - Tuple.pointZero
    }
}
