//
//  Triangle.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Triangle: Shape {
    override func localIntersects(ray: Ray) -> [Intersection] {
        return []
    }
    
    override func localNormalAt(p: Tuple) -> Tuple {
        return p - Tuple.pointZero
    }
    
//    function bounds_of(triangle)
//    let box ← bounding_box(empty)
//    
//    add triangle.p1 to box
//    add triangle.p2 to box
//    add triangle.p3 to box
//    
//    return box
//    end function
}
