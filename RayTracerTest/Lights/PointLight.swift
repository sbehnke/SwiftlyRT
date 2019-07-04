//
//  LightBase.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct PointLight: Equatable {
    
    init() {
    }
    
    init(position: Tuple, intensity : Color) {
        assert(position.isPoint())
        self.position = position
        self.intensity = intensity
    }
    
    static func lighting(object: Shape?, material: Material, light: PointLight, position: Tuple, eyeVector: Tuple, normalVector: Tuple, inShadow: Bool = false) -> Color {
        var specular: Color
        var diffuse: Color
        
        let color = material.pattern?.patternAtShape(object: object, point: position) ?? material.color
//        let effectiveColor = material.color * light.intensity
        let effectiveColor = color * light.intensity
        let lightv = (light.position - position).normalize()
        let ambient = effectiveColor * material.ambient
        let lightDotNormal = Tuple.dot(lhs: lightv, rhs: normalVector)
        
        if inShadow {
            return ambient
        }

        if lightDotNormal < 0 {
            diffuse = Color.black
            specular = Color.black
        } else {
            diffuse = effectiveColor * material.diffuse * lightDotNormal

            let reflectv = Tuple.reflect(lhs: -lightv, normal: normalVector)
            let reflectDotEye = Tuple.dot(lhs: reflectv, rhs: eyeVector)
            
            if reflectDotEye <= 0 {
                specular = Color.black
            } else {
                let factor = pow(reflectDotEye, Double(material.shininess))
                specular = light.intensity * material.specular * factor
            }
        }
        return ambient + diffuse + specular
    }
    
    func lighting(object: Shape?, material: Material, position: Tuple, eyeVector: Tuple, normalVector: Tuple, inShadow: Bool = false) -> Color {
        return PointLight.lighting(object: object, material: material, light: self, position: position, eyeVector: eyeVector, normalVector: normalVector, inShadow: inShadow)
    }
    
    var position = Tuple.pointZero
    var intensity = Color()
}
