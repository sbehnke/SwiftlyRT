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
    
    static func prepareComputation(i: Intersection, ray: Ray) -> Computation {
        assert(i.object != nil)
        
        var comps = Computation()
        comps.t = i.t
        comps.object = i.object
        
        comps.point = ray.position(time: i.t)
        comps.eyeVector = -ray.direction
        comps.normalVector = i.object!.normalAt(p: comps.point)
        comps.overPoint = comps.point + comps.normalVector * Tuple.epsilon
        comps.reflectVector = Tuple.reflect(lhs: ray.direction, normal: comps.normalVector)
        
        if (comps.normalVector.dot(rhs: comps.eyeVector) < 0) {
            comps.inside = true
            comps.normalVector = -comps.normalVector
        } else {
            comps.inside = false
        }
        
        return comps
    }
    
    func prepareCopmutation(ray: Ray) -> Computation {
        return Intersection.prepareComputation(i: self, ray: ray)
    }
    
    init() {
        t = 0
        object = nil
    }
    
    init(t: Double, object: Shape?) {
        self.t = t
        self.object = object
    }
    
    var t : Double
    var object : Shape?
}
