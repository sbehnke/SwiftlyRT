//
//  TextureMapPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class TextureMapPattern: Pattern {
    
    override func patternAt(point: Tuple) -> Color {
//        let (u, v) ← texture_map.uv_map(point)
//        return uv_pattern_at(texture_map.uv_pattern, u, v)
        
        return Color.black
    }
}
