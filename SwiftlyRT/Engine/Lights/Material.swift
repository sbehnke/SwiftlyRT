//
//  Material.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Material: Equatable {
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

    func lighting(
        object: Shape?, light: any Light, position: Tuple, eyeVector: Tuple, normalVector: Tuple,
        intensity: Double
    ) -> Color {

        let color = pattern?.patternAtShape(object: object, point: position) ?? self.color
        let effectiveColor = color * light.intensity
        let ambient = effectiveColor * self.ambient
        let samples = light.sampledPoints

        var sum = Color.black

        for sample in samples {
            var specular: Color
            var diffuse: Color

            let lightv = (sample - position).normalized()
            let lightDotNormal = lightv.dot(normalVector)

            if lightDotNormal < 0 || intensity == 0.0 {
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

            sum += diffuse
            sum += specular
        }
        return ambient + (sum / Float(light.samples) * intensity)
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
