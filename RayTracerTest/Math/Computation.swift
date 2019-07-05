//
//  Computation.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Computation: Equatable {
    
    let b = """
function schlick(comps)
  # find the cosine of the angle between the eye and normal vectors
  cos ← dot(comps.eyev, comps.normalv)

  # total internal reflection can only occur if n1 > n2
  if comps.n1 > comps.n2
    n ← comps.n1 / comps.n2
    sin2_t = n^2 * (1.0 - cos^2)
    return 1.0 if sin2_t > 1.0

    # compute cosine of theta_t using trig identity
    cos_t ← sqrt(1.0 - sin2_t)

    # when n1 > n2, use cos(theta_t) instead
    cos ← cos_t
  end if

  r0 ← ((comps.n1 - comps.n2) / (comps.n1 + comps.n2))^2
  return r0 + (1 - r0) * (1 - cos)^5
end function
"""
    
    func schlick() -> Double {
        var cos = eyeVector.dot(rhs: normalVector)
        
        if n1 > n2 {
            let n = n1 / n2
            let sin2T = pow(n, 2) * (1.0 - pow(cos, 2))
            
            if (sin2T > 1.0) {
                return 1.0
            }
            
            cos = sqrt(1.0 - sin2T)
        }
        
        let r0 = pow((n1 - n2) / (n1 + n2), 2)
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
