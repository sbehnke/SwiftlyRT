//
//  Cone.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class Cone: Shape {
    // TODO: Implement Cone logic from book based on Cylinder

    private func checkCaps(ray: Ray, t: Double, y: Double) -> Bool {
        let x = ray.origin.x + t * ray.direction.x
        let z = ray.origin.z + t * ray.direction.z
        return x * x + z * z <= y * y
    }

    private func intersetCaps(ray: Ray, xs: inout [Intersection]) {
        if closed && !Tuple.almostEqual(lhs: ray.direction.y, rhs: 0.0) {
            let t0 = (minimum - ray.origin.y) / ray.direction.y
            if checkCaps(ray: ray, t: t0, y: minimum) {
                xs.append(Intersection(t: t0, object: self))
            }

            let t1 = (maximum - ray.origin.y) / ray.direction.y
            if checkCaps(ray: ray, t: t1, y: minimum) {
                xs.append(Intersection(t: t1, object: self))
            }
        }
    }

    override func localIntersects(ray: Ray) -> [Intersection] {
        var xs: [Intersection] = []
        let a =
            ray.direction.x * ray.direction.x - ray.direction.y * ray.direction.y + ray.direction.z
            * ray.direction.z
        let b =
            2 * ray.origin.x * ray.direction.x - 2 * ray.origin.y * ray.direction.y + 2
            * ray.origin.z * ray.direction.z
        let c =
            ray.origin.x * ray.origin.x + -ray.origin.y * ray.origin.y + ray.origin.z * ray.origin.z

        if Tuple.almostEqual(lhs: a, rhs: 0.0) && !Tuple.almostEqual(lhs: b, rhs: 0.0) {
            let t = -c / (2 * b)
            xs.append(Intersection(t: t, object: self))
        }

        if !Tuple.almostEqual(lhs: a, rhs: 0) {
            let disc = b * b - 4 * a * c

            if disc >= 0 {
                var t0 = (-b - sqrt(disc)) / (2 * a)
                var t1 = (-b + sqrt(disc)) / (2 * a)

                if t0 > t1 {
                    swap(&t0, &t1)
                }

                let y0 = ray.origin.y + t0 * ray.direction.y
                if minimum < y0 && y0 < maximum {
                    xs.append(Intersection(t: t0, object: self))
                }

                let y1 = ray.origin.y + t1 * ray.direction.y
                if minimum < y1 && y1 < maximum {
                    xs.append(Intersection(t: t1, object: self))
                }
            }
        }

        intersetCaps(ray: ray, xs: &xs)

        return xs
    }

    override func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        let dist = (p.x * p.x) + (p.z * p.z)

        if dist < 1 && p.y >= maximum - Tuple.epsilon {
            return .Vector(x: 0, y: 1, z: 0)
        }

        if (dist < 1) && (p.y <= minimum + Tuple.epsilon) {
            return .Vector(x: 0, y: -1, z: 0)
        }

        var y = sqrt((p.x * p.x) + (p.z * p.z))
        if p.y > 0 {
            y = -y
        }

        return .Vector(x: p.x, y: y, z: p.z)
    }

    override func boundingBox() -> BoundingBox {
        if bounds == nil {
            let a = abs(minimum)
            let b = abs(maximum)
            let limit = max(a, b)
            bounds = BoundingBox(
                minimum: Tuple.Point(x: -limit, y: minimum, z: -limit),
                maximum: Tuple.Point(x: limit, y: maximum, z: limit))
        }

        return bounds!
    }

    var minimum = -Double.infinity
    var maximum = Double.infinity
    var closed = false
}
