//
//  Projecile.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Projectile {
    
    init(position: Point, velocity: Vector4) {
        self.position = position
        self.velocity = velocity
    }
    
    func tick(environment: Environment) {
        position += velocity
        velocity = velocity + environment.gravity + environment.wind
    }
    
    var position = Point()
    var velocity = Vector4()
}
