//
//  AreaLight.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/21/19.
//  Copyright © 2019 Luster Images. All rights reserved.
//

import Foundation

struct AreaLight: Equatable, Light {
    
    init(corner: Tuple, uvec: Tuple, usteps: Int, vvec: Tuple, vsteps: Int, intensity: Color) {
        self.corner = corner
        self.uvec = uvec / Double(usteps)
        self.usteps = usteps
        self.vvec = vvec / Double(vsteps)
        self.vsteps = vsteps
        self.intensity = intensity
        self.position = (uvec / 2.0) + (vvec / 2.0)
        self.position.w = 1.0
    }
    
    func intensityAt(point: Tuple, world: World) -> Double {
        var total = 0.0
        
        for v in 0..<vsteps {
            for u in 0..<usteps {
                let lightPosition = pointOnLight(u: Double(u), v: Double(v))
                
                if !world.isShadowed(lightPosition: lightPosition, point: point) {
                    total += 1.0
                }
            }
        }
        
        return total / Double(samples)
    }
    
    func pointOnLight(u: Double, v: Double) -> Tuple {
        return corner +
            uvec * (u + jitterBy.next()) +
            vvec * (v + jitterBy.next())
    }
    
    var corner: Tuple = .pointZero
    var uvec: Tuple = .zero
    var usteps = 0
    var vvec: Tuple = .zero
    var vsteps = 0
    var samples: Int {
        get {
            return usteps * vsteps
        }
    }
    var position: Tuple = .pointZero
    var intensity = Color()
    var jitter = false
    var jitterBy = CyclicSequence([0.5])
}
