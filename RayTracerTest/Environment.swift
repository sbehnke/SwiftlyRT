//
//  Environment.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Environment {
    init(gravity: Vector4, wind: Vector4) {
        self.gravity = gravity
        self.wind = wind
    }
    
    var gravity = Vector4()
    var wind = Vector4()
}
