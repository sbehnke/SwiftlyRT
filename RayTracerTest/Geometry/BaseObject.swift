//
//  BaseObject.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class BaseObject : Equatable {
    static func == (lhs: BaseObject, rhs: BaseObject) -> Bool {
        return lhs === rhs
    }
    
    static func intersects(object: BaseObject, ray: Ray) -> [Intersection] {
        return []
    }
    
    var transform = Matrix4x4.identity
}
