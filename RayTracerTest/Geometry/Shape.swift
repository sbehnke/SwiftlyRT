//
//  BaseObject.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Shape : Equatable {
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return lhs === rhs
    }
    
    static func intersects(object: Shape, ray: Ray) -> [Intersection] {
        return []
    }
    
    func intersects(ray: Ray) -> [Intersection] {
        return []
    }
    
    func normalAt(p : Tuple) -> Tuple {
        return Tuple.zero
    }
    
    var transform = Matrix4x4.identity
    var material = Material()
    var name = ""
}
