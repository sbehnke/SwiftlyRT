//
//  CubeMapPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation


class CubeMapPattern: Pattern {
    
    func uvPatternAt(face: Face, u: Double, v: Double) -> Color {
        return Color.black
    }

    override func patternAt(point: Tuple) -> Color {
//        function pattern_at(cube_map, point)
//        let face ← face_from_point(point)
//
//        if face = "left" then
//        (u, v) ← uv_cube_left(point)
//        else if face = "right" then
//        (u, v) ← uv_cube_right(point)
//        else if face = "front" then
//        (u, v) ← uv_cube_front(point)
//        else if face = "back" then
//        (u, v) ← uv_cube_back(point)
//        else if face = "up" then
//        (u, v) ← uv_cube_up(point)
//        else # down
//        (u, v) ← uv_cube_down(point)
//        end
//
//        return uv_pattern_at(cube_map.faces[face], u, v)
//        end
        
        return uvPatternAt(face: .Front, u: 0.0, v: 0.0)
    }
    
}
