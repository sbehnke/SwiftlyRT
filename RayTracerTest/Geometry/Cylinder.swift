//
//  Cylinder.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Cylinder: Shape {
    
    private func checkCaps(ray: Ray, t: Double) -> Bool {
        let x = ray.origin.x + t * ray.direction.x
        let z = ray.origin.z + t * ray.direction.z
        return (x * x + z * z) <= 1
    }
    
    private func intersetCaps(ray: Ray, xs: inout [Intersection]) {
        if !closed || Tuple.almostEqual(lhs: ray.direction.y, rhs: 0.0) {
            return
        }
        
        let t0 = (minimum - ray.origin.y) / ray.direction.y
        
        if checkCaps(ray: ray, t: t0) {
            xs.append(Intersection(t: t0, object: self))
        }
        
        let t1 = (maximum - ray.origin.y) / ray.direction.y
        
        if checkCaps(ray: ray, t: t1) {
            xs.append(Intersection(t: t1, object: self))
        }
    }
    
    override func localIntersects(ray: Ray) -> [Intersection] {
        var xs: [Intersection] = []
        intersetCaps(ray: ray, xs: &xs)

        let a = ray.direction.x * ray.direction.x + ray.direction.z * ray.direction.z
        
        if Tuple.almostEqual(lhs: a, rhs: 0.0) {
            return xs
        }

        let b = 2 * ray.origin.x * ray.direction.x + 2 * ray.origin.z * ray.direction.z
        let c = ray.origin.x * ray.origin.x + ray.origin.z * ray.origin.z - 1
        
        let disc = b * b - 4 * a * c
        
        if disc < 0 {
            return xs
        }

        let t0 = (-b - sqrt(disc)) / (2 * a)
        let t1 = (-b + sqrt(disc)) / (2 * a)

        let y0 = ray.origin.y + t0 * ray.direction.y
        if minimum < y0 && y0 < maximum {
            xs.append(Intersection(t: t0, object: self))
        }
        
        let y1 = ray.origin.y + t1 * ray.direction.y
        if minimum < y1 && y1 < maximum {
            xs.append(Intersection(t: t1, object: self))
        }
        
        return xs
    }
    
    override func localNormalAt(p: Tuple) -> Tuple {
        let dist = p.x * p.x + p.z * p.z
        
        if dist < 1 && p.y >= maximum - Tuple.epsilon {
            return .Vector(x: 0, y: 1, z: 0)
        } else if dist < 1 && p.y <= minimum + Tuple.epsilon {
            return .Vector(x: 0, y: -1, z: 0)
        } else {
            return .Vector(x: p.x, y: 0, z: p.z)
        }
    }
    
    var minimum = -Double.infinity
    var maximum = Double.infinity
    var closed = false
}
