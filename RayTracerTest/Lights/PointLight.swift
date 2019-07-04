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
    
let b = """
function lighting(material, light, point, eyev, normalv)
  # combine the surface color with the light's color/intensity
  effective_color ← material.color * light.intensity

  # find the direction to the light source
  lightv ← normalize(light.position - point)

  # compute the ambient contribution
  ambient ← effective_color * material.ambient

  # light_dot_normal represents the cosine of the angle between the
  # light vector and the normal vector. A negative number means the
  # light is on the other side of the surface.
  light_dot_normal ← dot(lightv, normalv)
  if light_dot_normal < 0
    diffuse ← black
    specular ← black

  else
    # compute the diffuse contribution
    diffuse ← effective_color * material.diffuse * light_dot_normal

    # reflect_dot_eye represents the cosine of the angle between the
    # reflection vector and the eye vector. A negative number means the
    # light reflects away from the eye.
    reflectv ← reflect(-lightv, normalv)
    reflect_dot_eye ← dot(reflectv, eyev)

    if reflect_dot_eye <= 0
      specular ← black
    else
      # compute the specular contribution
      factor ← pow(reflect_dot_eye, material.shininess)
      specular ← light.intensity * material.specular * factor
    end if
  end if

  # Add the three contributions together to get the final shading
  return ambient + diffuse + specular
end function
"""
    
    
    static func lighting(material: Material, light: PointLight, position: Tuple, eyeVector: Tuple, normalVector: Tuple) -> Color {
        var specular: Color
        var diffuse: Color
        
//        effective_color ← material.color * light.intensity
        let effectiveColor = material.color * light.intensity
//        lightv ← normalize(light.position - point)
        let lightv = (light.position - position).normalize()
//        ambient ← effective_color * material.ambient
        let ambient = effectiveColor * material.ambient
        //        light_dot_normal ← dot(lightv, normalv)
        let lightDotNormal = Tuple.dot(lhs: lightv, rhs: normalVector)

//        if light_dot_normal < 0
        if (lightDotNormal < 0) {
//        diffuse ← black
            diffuse = Color.black
//        specular ← black
            specular = Color.black
        } else {
//            # compute the diffuse contribution
//            diffuse ← effective_color * material.diffuse * light_dot_normal
            diffuse = effectiveColor * material.diffuse * lightDotNormal

            let reflectv = Tuple.reflect(lhs: -lightv, normal: normalVector)
            let reflectDotEye = Tuple.dot(lhs: reflectv, rhs: eyeVector)
            
            if (reflectDotEye <= 0) {
                specular = Color.black
            } else {
//                factor ← pow(reflect_dot_eye, material.shininess)
                let factor = pow(reflectDotEye, Double(material.shininess))
//                specular ← light.intensity * material.specular * factor
                specular = light.intensity * material.specular * factor
            }
        }
//        return ambient + diffuse + specular
        return ambient + diffuse + specular
    }
    
    func lighting(material: Material, position: Tuple, eyeVector: Tuple, normalVector: Tuple) -> Color {
        return PointLight.lighting(material: material, light: self, position: position, eyeVector: eyeVector, normalVector: normalVector)
    }
    
    var position = Tuple.pointZero
    var intensity = Color()
}
