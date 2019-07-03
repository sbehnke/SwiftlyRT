//
//  LightBase.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class PointLight {
    
    init() {
    }
    
    init(position: Tuple, intensity : Color) {
        assert(position.isPoint())
        self.position = position
        self.intensity = intensity
    }
    
    static func lighting(material: Material, light: PointLight, position: Tuple, eyeVector: Tuple, normalVector: Tuple) -> Color {
        let effectiveColor = material.color * light.intensity
        let lightv = (light.position - position).normalize()
        let ambient = effectiveColor * material.ambient
        let lightDotNormal = Tuple.dot(lhs: lightv, rhs: normalVector)
        var specular = Color.black
        var diffuse = Color.black
        
        if (lightDotNormal < 0) {
            return Color.black
        } else {
            diffuse = effectiveColor * material.diffuse * lightDotNormal
            let reflectv = Tuple.reflect(lhs: -lightv, normal: normalVector)
            let reflectDotEye = Tuple.dot(lhs: reflectv, rhs: eyeVector)
            
            if (reflectDotEye > 0) {
                let factor = pow(reflectDotEye, Double(material.shininess))
                specular = light.intensity * material.specular * factor
            }
        }
        
        return ambient + diffuse + specular
    }
    
    func lighting(material: Material, position: Tuple, eyeVector: Tuple, normalVector: Tuple) -> Color {
        return PointLight.lighting(material: material, light: self, position: position, eyeVector: eyeVector, normalVector: normalVector)
    }
    
    var position = Tuple.pointZero
    var intensity = Color()
}
