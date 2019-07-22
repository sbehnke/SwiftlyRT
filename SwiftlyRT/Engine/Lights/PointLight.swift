//
//  LightBase.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

protocol Light {
    func pointOnLight(u: Double, v: Double) -> Tuple
    func intensityAt(point: Tuple, world: World) -> Double
    
    var position: Tuple { get set }
    var intensity: Color { get set }
    var samples: Int { get }
}

struct PointLight: Equatable, Light {
    func intensityAt(point: Tuple, world: World) -> Double {
        if world.isShadowed(lightPosition: position, point: point) {
            return 0.0
        } else {
            return 1.0
        }
    }
    
    func pointOnLight(u: Double, v: Double) -> Tuple {
        return Tuple.pointZero
    }
    
    init(position: Tuple, intensity : Color) {
        assert(position.isPoint())
        self.position = position
        self.intensity = intensity
    }
    
    var position = Tuple.pointZero
    var intensity = Color()
    var samples: Int {
        get { return 1 }
    }
}
