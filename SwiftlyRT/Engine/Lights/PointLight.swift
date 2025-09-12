//
//  LightBase.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

protocol Light {
    func pointOnLight(u: Double, v: Double) -> Tuple
    func intensityAt(point: Tuple, world: World) -> Double

    var position: Tuple { get set }
    var intensity: Color { get set }
    var sampledPoints: [Tuple] { get }
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
        return position
    }

    init(position: Tuple, intensity: Color) {
        assert(position.isPoint())
        self.position = position
        self.intensity = intensity
    }

    var position = Tuple.pointZero
    var intensity = Color()
    var samples: Int {
        return 1
    }
    var sampledPoints: [Tuple] {
        return [position]
    }
}
