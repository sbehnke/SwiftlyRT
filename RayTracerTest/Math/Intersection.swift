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
    
    func prepareComputation(ray: Ray, xs: [Intersection] = []) -> Computation {
        assert(object != nil)
        var comps = Computation()
        
        var container: [Shape] = []
        for intersection in xs {
            if intersection == self {
                if container.isEmpty {
                    comps.n1 = 1.0
                } else {
                    comps.n1 = Double(container.last!.material.refractiveIndex)
                }
            }
            
            if container.contains(intersection.object!) {
                container = container.filter() { $0 != intersection.object! }
            } else {
                container.append(intersection.object!)
            }
            
            if intersection == self {
                if container.isEmpty {
                    comps.n2 = 1.0
                } else {
                    comps.n2 = Double(container.last!.material.refractiveIndex)
                }
                
                break
            }
        }
        
        comps.t = self.t
        comps.object = self.object
        
        comps.point = ray.position(time: self.t)
        comps.eyeVector = -ray.direction
        comps.normalVector = self.object!.normalAt(p: comps.point, hit: self)
        
        if (comps.normalVector.dot(comps.eyeVector) < 0) {
            comps.inside = true
            comps.normalVector = -comps.normalVector
        } else {
            comps.inside = false
        }
        
        comps.overPoint = comps.point + comps.normalVector * Tuple.epsilon
        comps.underPoint = comps.point - comps.normalVector * Tuple.epsilon
        comps.reflectVector = ray.direction.reflected(normal: comps.normalVector)
        
        return comps
    }
    
    init() {
        t = 0
        object = nil
    }
    
    init(t: Double, object: Shape?) {
        self.t = t
        self.object = object
    }
    
    init(t: Double, object: Shape?, u: Double, v: Double) {
        self.t = t
        self.object = object
        self.u = u
        self.v = v
    }
    
    var u: Double = 0.0
    var v: Double = 0.0
    var t: Double = 0.0
    var object: Shape? = nil
}
