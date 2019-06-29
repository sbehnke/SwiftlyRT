//
//  Environment.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Environment {
    init(gravity: Vector, wind: Vector) {
        self.gravity = gravity
        self.wind = wind
    }
    
    var gravity = Vector()
    var wind = Vector()
}
