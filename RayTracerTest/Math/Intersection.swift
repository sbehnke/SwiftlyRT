//
//  Intersection.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Intersection : Equatable, Comparable {
    
    static func < (lhs: Intersection, rhs: Intersection) -> Bool {
        return lhs.t < rhs.t
    }
    
    static func == (lhs: Intersection, rhs: Intersection) -> Bool {
        return Tuple.almostEqual(lhs: lhs.t, rhs: rhs.t) && lhs.object === rhs.object
    }
    
    static func hit(_ intersections : [Intersection]) -> Intersection? {
        var sorted = intersections
        sorted.sort()
        
        for intersection in sorted {
            if (intersection.t > 0) {
                return intersection
            }
        }
        
        return nil
    }
    
    init() {
        t = 0
        object = nil
    }
    
    init(t: Double, object: BaseObject?) {
        self.t = t
        self.object = object
    }
    
    var t : Double
    var object : BaseObject?
}
