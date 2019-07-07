//
//  Bounds.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Bounds : Equatable {
    
    mutating func addPoint(point: Tuple) {
        minimum.x = min(minimum.x, point.x)
        minimum.y = min(minimum.y, point.y)
        minimum.z = min(minimum.z, point.z)
        
        maximum.x = max(maximum.x, point.x)
        maximum.y = max(maximum.y, point.y)
        maximum.z = max(maximum.z, point.z)
    }
    
    mutating func addBox(box: Bounds) {
        addPoint(point: box.minimum)
        addPoint(point: box.maximum)
    }
    
    func containsPoint(point: Tuple) -> Bool {
        return minimum.x <= point.x && point.x <= maximum.x &&
            minimum.y <= point.y && point.y <= maximum.y &&
            minimum.z <= point.z && point.z <= maximum.z
    }
    
    func containsBox(box: Bounds) -> Bool {
        return containsPoint(point: box.minimum) && containsPoint(point: box.maximum)
    }
    
    mutating func transform(transform: Matrix4x4) {
        addPoint(point: transform * minimum)
        addPoint(point: transform * maximum)
    }
    
    func transformed(transform: Matrix4x4) -> Bounds {
        return Bounds(minimum: transform * minimum, maximum: transform * maximum)
    }
    
    func intersects(ray: Ray) -> Bool {
        var minList: [Double] = []
        var maxList: [Double] = []

        for index in 0..<3 {
            let (min, max) = checkAxis(origin: ray.origin[index], direction: ray.direction[index], minExtent: minimum[index], maxExtent: maximum[index])
            
            minList.append(min)
            maxList.append(max)
        }
        
        if minList.count > 0 && maxList.count > 0 {
            let tmin = minList.min()!
            let tmax = maxList.max()!
            
            return tmin <= tmax
        }
        
        return false
    }
    
    func checkAxis(origin: Double, direction: Double, minExtent: Double, maxExtent: Double) -> (Double, Double) {
        let tmin = (minExtent - origin) / direction
        let tmax = (maxExtent - origin) / direction
        if tmin > tmax {
            return (tmax, tmin)
        }
        
        return (tmin, tmax)
    }
    
    var minimum = Tuple.pointZero
    var maximum = Tuple.pointZero
}
