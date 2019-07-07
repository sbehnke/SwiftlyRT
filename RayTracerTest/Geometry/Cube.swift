//
//  Cube.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Cube: Shape {
    
    private func checkAxis(origin: Double, direction: Double) -> (Double, Double) {
        let tmin =  (-1 - origin) / direction
        let tmax = (1 - origin) / direction
        
        if (tmin > tmax) {
            return (tmax, tmin)
        }
        
        return (tmin, tmax)
    }
    
    override func localIntersects(ray: Ray) -> [Intersection] {
        let (xtmin, xtmax) = checkAxis(origin: ray.origin.x, direction: ray.direction.x)
        let (ytmin, ytmax) = checkAxis(origin: ray.origin.y, direction: ray.direction.y)
        let (ztmin, ztmax) = checkAxis(origin: ray.origin.z, direction: ray.direction.z)

        let tmin = max(xtmin, ytmin, ztmin)
        let tmax = min(xtmax, ytmax, ztmax)
        
        if tmin > tmax {
            return []
        }
        
        return [Intersection(t: tmin, object: self), Intersection(t: tmax, object: self)]
    }
    
    override func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        let maxc = max(abs(p.x), abs(p.y), abs(p.z))
        if maxc == abs(p.x) {
            return .Vector(x: p.x, y: 0, z: 0)
        } else if (maxc == abs(p.y)) {
            return .Vector(x: 0, y: p.y, z: 0)
        } else {
            return .Vector(x: 0, y: 0, z: p.z)
        }
    }
    
    override func boundingBox() -> BoundingBox {
        return BoundingBox(minimum: Tuple.Point(x: -1, y: -1, z: -1), maximum: Tuple.Point(x: 1, y: 1, z: 1))
    }
}
