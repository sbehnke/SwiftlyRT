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
        
        for child in children {
            let xs = child.intersects(ray: ray)
            intersections.append(contentsOf: xs)
        }
        
        return intersections.sorted()
    }
}
