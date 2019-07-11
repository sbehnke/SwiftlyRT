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
        let localRay = inverseTransform * ray        
        return localIntersects(ray: localRay)
    }
    
    func localIntersects(ray: Ray) -> [Intersection] {
        return []
    }
    
    func normalAt(p: Tuple, hit: Intersection) -> Tuple {
        let localPoint = worldToObject(point: p)
        let localNormal = localNormalAt(p: localPoint, hit: hit)
        return normalToWorld(normal: localNormal)
    }
    
    func localNormalAt(p: Tuple, hit: Intersection) -> Tuple {
        return .Vector(x: p.x, y: p.y, z: p.z)
    }
    
    func worldToObject(point: Tuple) -> Tuple {
        return inverseTransform * (parent == nil ? point : parent!.worldToObject(point: point))
    }
    
    func normalToWorld(normal: Tuple) -> Tuple {
        let n1 = inverseTransform.transposed() * normal
        let n2 = Tuple.Vector(x: n1.x, y: n1.y, z: n1.z).normalized()
        return (parent == nil) ? n2 : parent!.normalToWorld(normal: n2)
    }
    
    func parentSpaceBounds() -> BoundingBox {
        if parentBounds == nil {
            parentBounds = boundingBox().transformed(transform: transform)
        }
        
        return parentBounds!
    }
    
    func boundingBox() -> BoundingBox {
        if bounds == nil {
            bounds = BoundingBox()
        }
        
        return bounds!
    }
    
    func removeFromParent() {
        if let p = parent {
            p.removeChild(self)
        }
    }
    
    func divide(threshold: Int) {
    }
    
    func includes(_ shape: Shape) -> Bool {
        return self == shape
    }
    
    private func invalidateBounds() {
        bounds = nil
        parentBounds = nil
    }
    
    internal var bounds: BoundingBox? = nil
    internal var parentBounds: BoundingBox? = nil
    
    var castsShadow = true
    var name = ""
    var parent: Group? = nil {
        didSet {
            invalidateBounds()
        }
    }
    var children: [Shape] = []
    var transform = Matrix4x4.identity {
        didSet {
            inverseTransform = transform.inversed()
            invalidateBounds()
        }
    }
    private(set) var inverseTransform = Matrix4x4.identity
    var material = Material()
    var filename: String? = nil
}
