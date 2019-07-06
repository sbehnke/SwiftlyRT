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
    
    func lighting(object: Shape?, light: PointLight, position: Tuple, eyeVector: Tuple, normalVector: Tuple, inShadow: Bool = false) -> Color {
        var specular: Color
        var diffuse: Color
        
        let color = pattern?.patternAtShape(object: object, point: position) ?? self.color
        let effectiveColor = color * light.intensity
        let lightv = (light.position - position).normalied()
        let ambient = effectiveColor * self.ambient
        let lightDotNormal = lightv.dot(normalVector)
        
        if inShadow {
            return ambient
        }
        
        if lightDotNormal < 0 {
            diffuse = Color.black
            specular = Color.black
        } else {
            diffuse = effectiveColor * self.diffuse * lightDotNormal
            
            let reflectv = -lightv.reflected(normal: normalVector)
            let reflectDotEye = reflectv.dot(eyeVector)
            
            if reflectDotEye <= 0 {
                specular = Color.black
            } else {
                let factor = pow(reflectDotEye, Double(shininess))
                specular = light.intensity * self.specular * factor
            }
        }
        return ambient + diffuse + specular
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
