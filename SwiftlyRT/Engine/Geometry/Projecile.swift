//
//  Projecile.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

struct Projectile {

    mutating func tick(environment: Environment) {
        position += velocity
        velocity = velocity + environment.gravity + environment.wind
    }

    var position = Tuple.Point()
    var velocity = Tuple.Vector()
}
