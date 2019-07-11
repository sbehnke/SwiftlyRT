//
//  BoundingBox.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct BoundingBox : Equatable {
    
    mutating func addPoint(point: Tuple) {
        minimum.x = min(minimum.x, point.x)
        minimum.y = min(minimum.y, point.y)
        minimum.z = min(minimum.z, point.z)
        
        maximum.x = max(maximum.x, point.x)
        maximum.y = max(maximum.y, point.y)
        maximum.z = max(maximum.z, point.z)
    }
    
    mutating func addBox(box: BoundingBox) {
        addPoint(point: box.minimum)
        addPoint(point: box.maximum)
    }
    
    func containsPoint(point: Tuple) -> Bool {
        return minimum.x <= point.x && point.x <= maximum.x &&
            minimum.y <= point.y && point.y <= maximum.y &&
            minimum.z <= point.z && point.z <= maximum.z
    }
    
    func containsBox(box: BoundingBox) -> Bool {
        return containsPoint(point: box.minimum) && containsPoint(point: box.maximum)
    }
    
    func transform(transform: Matrix4x4) -> BoundingBox {
        var points: [Tuple] = []
        points.append(minimum)
        points.append(transform * .Point(x: minimum.x, y: minimum.y, z: maximum.z))
        points.append(transform * .Point(x: minimum.x, y: maximum.y, z: minimum.z))
        points.append(transform * .Point(x: minimum.x, y: maximum.y, z: maximum.z))
        points.append(transform * .Point(x: maximum.x, y: minimum.y, z: minimum.z))
        points.append(transform * .Point(x: maximum.x, y: minimum.y, z: maximum.z))
        points.append(transform * .Point(x: maximum.x, y: maximum.y, z: minimum.z))
        points.append(maximum)
        var box = BoundingBox()
        
        for point in points {
            box.addPoint(point: point)
        }
        
        return box
    }
    
    func transformed(transform: Matrix4x4) -> BoundingBox {
        return BoundingBox(minimum: transform * minimum, maximum: transform * maximum)
    }
    
    func intersects(ray: Ray) -> Bool {
        let (xtmin, xtmax) = checkAxis(origin: ray.origin.x, direction: ray.direction.x, minExtent: minimum.x, maxExtent: maximum.x)
        let (ytmin, ytmax) = checkAxis(origin: ray.origin.y, direction: ray.direction.y, minExtent: minimum.y, maxExtent: maximum.y)
        let (ztmin, ztmax) = checkAxis(origin: ray.origin.z, direction: ray.direction.z, minExtent: minimum.z, maxExtent: maximum.z)
        
        let tmin = max(xtmin, ytmin, ztmin)
        let tmax = min(xtmax, ytmax, ztmax)
        
        if tmin > tmax {
            return false
        }
        
        return true
    }
    
    private func checkAxis(origin: Double, direction: Double, minExtent: Double, maxExtent: Double) -> (Double, Double) {
        let tmin =  (minExtent - origin) / direction
        let tmax = (maxExtent - origin) / direction
        
        if (tmin > tmax) {
            return (tmax, tmin)
        }
        
        return (tmin, tmax)
    }
    
    func splitBoundingBox() -> (BoundingBox, BoundingBox) {
        let dx = maximum.x - minimum.x
        let dy = maximum.y - minimum.y
        let dz = maximum.z - minimum.z
        
        let greatest = max(dx, dy, dz)
        var (x0, y0, z0) = (minimum.x, minimum.y, minimum.z)
        var (x1, y1, z1) = (maximum.x, maximum.y, maximum.z)
        
        if greatest == dx {
            x1 = x0 + dx / 2.0
            x0 = x1
        } else if greatest == dy {
            y1 = y0 + dy / 2.0
            y0 = y1
        } else {
            z1 = z0 + dz / 2.0
            z0 = z1
        }
        
        let midMin = Tuple.Point(x: x0, y: y0, z: z0)
        let midMax = Tuple.Point(x: x1, y: y1, z: z1)
        
        let left = BoundingBox(minimum: minimum, maximum: midMax)
        let right = BoundingBox(minimum: midMin, maximum: maximum)
        
        return (left, right)
    }
    
    var minimum = Tuple.Point(x: .infinity, y: .infinity, z: .infinity)
    var maximum = Tuple.Point(x: -.infinity, y: -.infinity, z: -.infinity)
}
