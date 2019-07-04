//
//  Computation.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Computation: Equatable {
    var t = 0.0
    var object: Shape? = nil
    var point = Tuple.pointZero
    var eyeVector = Tuple.zero
    var normalVector = Tuple.zero
    var inside = false
}
