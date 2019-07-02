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
    
    static func position(ray: Ray, time: Double) -> Tuple {
        return ray.origin + ray.direction * time
    }
    
    func position(time: Double) -> Tuple {
        return Ray.position(ray: self, time: time)
    }
    
    static func translate(ray: Ray, vector: Tuple) -> Ray {
        assert(vector.isVector())
        let transform = Matrix4x4.translate(x: vector.x, y: vector.y, z: vector.z)
        return transform * ray
    }
    
    func translate(vector: Tuple) -> Ray {
        return Ray.translate(ray: self, vector: vector)
    }
    
    static func scale(ray: Ray, vector: Tuple) -> Ray {
        assert(vector.isVector())
        let transform = Matrix4x4.scale(x: vector.x, y: vector.y, z: vector.z)
        return transform * ray
    }
    
    func scale(vector: Tuple) -> Ray {
        return Ray.scale(ray: self, vector: vector)
    }
    
    var origin = Tuple.Point()
    var direction = Tuple.Vector()
}
