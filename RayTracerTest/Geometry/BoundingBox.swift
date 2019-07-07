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
        points.append(.Point(x: minimum.x, y: minimum.y, z: maximum.z))
        points.append(.Point(x: minimum.x, y: maximum.y, z: minimum.z))
        points.append(.Point(x: minimum.x, y: maximum.y, z: maximum.z))
        points.append(.Point(x: maximum.x, y: minimum.y, z: minimum.z))
        points.append(.Point(x: maximum.x, y: minimum.y, z: maximum.z))
        points.append(.Point(x: maximum.x, y: maximum.y, z: minimum.z))
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
    
    func splitBoundingBox() -> (BoundingBox, BoundingBox) {
//        function split_bounds(box)
//        # figure out the box's largest dimension
//        dx ← size of box in x
//        dy ← size of box in y
//        dz ← size of box in z
//        
//        greatest ← maximum of dx, dy, dz
//        
//        # variables to help construct the points on
//        # the dividing plane
//        (x0, y0, z0) ← (x, y, z) from box.min
//        (x1, y1, z1) ← (x, y, z) from box.max
//        
//        # adjust the points so that they lie on the
//        # dividing plane
//        if greatest = dx then
//        x0 ← x1 ← x0 + dx / 2.0
//        else if greatest = dy then
//        y0 ← y1 ← y0 + dy / 2.0
//        else
//        z0 ← z1 ← z0 + dz / 2.0
//        end if
//            
//            mid_min ← point(x0, y0, z0)
//        mid_max ← point(x1, y1, z1)
//        
//        # construct and return the two halves of
//        # the bounding box
//        left ← bounding_box(min=box.min max=mid_max)
//        right ← bounding_box(min=mid_min max=box.max)
//        
//        return (left, right)
//        end function
        
        
        return (BoundingBox(), BoundingBox())
    }
    
    var minimum = Tuple.Point(x: .infinity, y: .infinity, z: .infinity)
    var maximum = Tuple.Point(x: -.infinity, y: -.infinity, z: -.infinity)
}
