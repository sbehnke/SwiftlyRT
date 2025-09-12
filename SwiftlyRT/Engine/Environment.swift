//
//  Environment.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

class Environment {
    init(gravity: Tuple, wind: Tuple) {
        self.gravity = gravity
        self.wind = wind
    }

    var gravity = Tuple.Vector()
    var wind = Tuple.Vector()
}
