//
//  Sphere.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Sphere : BaseObject {
    
    static func intersects(object: Sphere, ray: Ray) -> [Intersection] {
        let ray2 = object.transform.invert() * ray
        
        // Vector from sphere's center to the ray origin
        // the sphere is centered at the world origin
        let sphereToRay = ray2.origin - Tuple.pointZero
        
        let a = Tuple.dot(lhs: ray2.direction, rhs: ray2.direction)
        let b = 2 * Tuple.dot(lhs: ray2.direction, rhs: sphereToRay)
        let c = Tuple.dot(lhs: sphereToRay, rhs: sphereToRay) - 1
        
        let discriminant = b * b - 4 * a * c
        
        if (discriminant < 0) {
            return []
        }
        let intersection1 = (-b - sqrt(discriminant)) / (2 * a)
        let intersection2 = (-b + sqrt(discriminant)) / (2 * a)
        
        return [Intersection(t: intersection1, object: object),
                Intersection(t: intersection2, object: object)]
    }
    
    func intersects(ray: Ray) -> [Intersection] {
        return Sphere.intersects(object: self, ray: ray)
    }
}
