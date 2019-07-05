//
//  Material.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Material : Equatable {
    enum RefractiveIndex: Float {
        case Vacuum = 1.0
        case Air = 1.00029
        case Water = 1.33333
        case Glass = 1.52
        case Diamond = 2.417
    }
    
    init() {
    }
    
    init(color: Color, ambient: Float, diffuse: Float, specular: Float, shininess: Float) {
        self.color = color
        self.ambient = ambient
        self.diffuse = diffuse
        self.specular = specular
        self.shininess = shininess
    }
    
    var pattern: Pattern? = nil
    var color = Color(r: 1, g: 1, b: 1)
    var ambient: Float = 0.1
    var diffuse: Float = 0.9
    var specular: Float = 0.9
    var shininess: Float = 200.0
    var reflective: Float = 0.0
    var transparency: Float = 0.0
    var refractiveIndex: Float = RefractiveIndex.Vacuum.rawValue
}
