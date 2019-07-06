//
//  BaseObject.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Shape : Equatable {
    let semaphore = DispatchSemaphore(value: 1)

    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return lhs === rhs
    }
    
    static func intersects(object: Shape, ray: Ray) -> [Intersection] {
        return []
    }
    
    func intersects(ray: Ray) -> [Intersection] {
        let localRay = transform.invert() * ray
        let _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
        defer {
            self.semaphore.signal()
        }
        
        savedRay = localRay
        return localIntersects(ray: localRay)
    }
    
    func localIntersects(ray: Ray) -> [Intersection] {
        return []
    }
    
    func normalAt(p : Tuple) -> Tuple {
        let localPoint = transform.invert() * p
        let localNormal = localNormalAt(p: localPoint)
        var worldNormal = transform.invert().transpose() * localNormal
        worldNormal.w = 0.0
        return worldNormal.normalize()
    }
    
    func localNormalAt(p: Tuple) -> Tuple {
        return .Vector(x: p.x, y: p.y, z: p.z)
    }
    
    var name = ""
    var parent: Shape? = nil
    var children: [Shape] = []
    var transform = Matrix4x4.identity
    var material = Material()
    var savedRay = Ray(origin: .pointZero, direction: .zero)
}
