//
//  Group.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Group: Shape {
    
    func addChildren(_ children: [Shape]) {
        for child in children {
            addChild(child)
        }
    }
    
    func addChild(_ child: Shape) {
        assert(child.parent == nil)
        child.parent = self
        children.append(child)
    }
    
    var empty: Bool {
        return children.count == 0
    }
    
    override func localIntersects(ray: Ray) -> [Intersection] {
        var intersections: [Intersection] = []
        
        if boundingBox().intersects(ray: ray) {
            for child in children {
                let xs = child.intersects(ray: ray)
                intersections.append(contentsOf: xs)
            }
        }
        return intersections.sorted()
    }
    
    override func boundingBox() -> BoundingBox {
        var bounds = BoundingBox()
        
        for child in children {
            bounds.addBox(box: child.parentSpaceBounds())
        }
        
        return bounds
    }
    
    func subdivide(threshold: Int) {
//        function divide(group, threshold)
//        if threshold <= group.count then
//        (left, right) ← partition_children(group)
//        if left is not empty then make_subgroup(group, left)
//        if right is not empty then make_subgroup(group, right)
//        end if
//
//        for each child in group
//        divide(child, threshold)
//        end for
//            end function
        
        children.removeAll()
    }
    
    var children: [Shape] = []
}
