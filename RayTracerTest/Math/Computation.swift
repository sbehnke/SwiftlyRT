//
//  Computation.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Computation: Equatable {
    
    func schlick() -> Double {
        var cos = eyeVector.dot(normalVector)
        
        if n1 > n2 {
            let n = n1 / n2
            let sin2T = (n * n) * (1.0 - (cos * cos))
            
            if (sin2T > 1.0) {
                return 1.0
            }
            
            cos = sqrt(1.0 - sin2T)
        }
        
        let r = (n1 - n2) / (n1 + n2)
        let r0 = r * r
        return r0 + (1 - r0) * pow((1 - cos), 5)
    }
    
    var t = 0.0
    var n1 = 1.0
    var n2 = 1.0
    var object: Shape? = nil
    var point = Tuple.pointZero
    var overPoint = Tuple.pointZero
    var underPoint = Tuple.pointZero
    var eyeVector = Tuple.zero
    var normalVector = Tuple.zero
    var reflectVector = Tuple.zero
    var inside = false
}
