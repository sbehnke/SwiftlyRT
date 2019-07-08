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
}

struct AreaLight: Equatable, Light {
    func intensityAt(point: Tuple, world: World) -> Double {
//        function intensity_at(light, point, world)
//        total ← 0.0
//        
//        for v ← 0 to light.vsteps - 1
//        for u ← 0 to light.usteps - 1
//        light_position ← point_on_light(light, u, v)
//        if not is_shadowed(world, light_position, point)
//        total ← total + 1.0
//        end if
//        end for
//        end for
//
//        return total / light.samples
//        end
        
        return 1.0
    }
    
    func pointOnLight(u: Double, v: Double) -> Tuple {
//    function point_on_light(light, u, v)
//    return light.corner +
//    light.uvec * (u + 0.5) +
//    light.vvec * (v + 0.5)
//    end function
        
        // second implemetantion with Jitter        
//        function point_on_light(light, u, v)
//        return light.corner +
//            light.uvec * (u + next(light.jitter_by)) +
//            light.vvec * (v + next(light.jitter_by))
//        end function
        
        return Tuple.pointZero
    }
    
//    var jitterBy: Sequence? = nil
}

struct PointLight: Equatable, Light {
    func intensityAt(point: Tuple, world: World) -> Double {
        return 1.0
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
}
