//
//  World.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import Yams

// Because each thread makes its own canvas chunk, it is thread safe.
class World: @unchecked Sendable {
    static let MaximumRecursionDepth = 5

    static func defaultWorld() -> World {
        let light = PointLight(position: Tuple.Point(x: -10, y: 10, z: -10), intensity: Color.white)
        let s1 = Sphere()
        s1.material.color = Color(r: 0.8, g: 1.0, b: 0.6)
        s1.material.diffuse = 0.7
        s1.material.specular = 0.2
        s1.name = "s1"

        let s2 = Sphere()
        s2.transform = Matrix4x4.scaled(x: 0.5, y: 0.5, z: 0.5)
        s2.name = "s2"

        let world = World()
        world.objects.append(s1)
        world.objects.append(s2)
        world.lights.append(light)

        return world
    }

    func intersects(ray: Ray) -> [Intersection] {
        var intersections: [Intersection] = []
        for shape: Shape in objects {
            intersections.append(contentsOf: shape.intersects(ray: ray))
        }

        return intersections.sorted()
    }

    func shadeHit(computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        if lights.count == 0 || computation.object == nil {
            return Color.black
        }

        var surface = Color.black
        for light in lights {
            let intensity = light.intensityAt(point: computation.overPoint, world: self)

            surface += computation.object!.material.lighting(
                object: computation.object,
                light: light,
                position: computation.overPoint,
                eyeVector: computation.eyeVector,
                normalVector: computation.normalVector,
                intensity: intensity)
        }

        var reflected = reflectedColor(computation: computation, remaining: remaining)
        var refracted = refractedColor(computation: computation, remaining: remaining)

        if computation.object!.material.reflective > 0
            && computation.object!.material.transparency > 0
        {
            let reflectance = computation.schlick()
            reflected *= Float(reflectance)
            refracted *= Float(1 - reflectance)
        }

        return surface + reflected + refracted
    }

    func colorAt(ray: Ray, remaining: Int = MaximumRecursionDepth) -> Color {
        let xs = intersects(ray: ray)
        let hit = Intersection.hit(xs)
        var color = Color.black

        if let h = hit {
            let comps = h.prepareComputation(ray: ray, xs: xs)
            color = shadeHit(computation: comps, remaining: remaining)
        }

        return color
    }

    func reflectedColor(computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        if remaining < 1 {
            return Color.black
        }

        let material = computation.object?.material ?? Material()
        if material.reflective.isZero {
            return Color.black
        }

        let reflectRay = Ray(origin: computation.overPoint, direction: computation.reflectVector)
        let color = colorAt(ray: reflectRay, remaining: remaining - 1)
        return color * material.reflective
    }

    func refractedColor(computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        // Maximum recursion met, return black
        if remaining < 1 {
            return Color.black
        }

        let transparency = computation.object!.material.transparency
        if transparency.isZero {
            return Color.black
        }

        // Check for total internal reflection with snells' law, return black
        let nRatio = Double(computation.n1 / computation.n2)
        let cosI = computation.eyeVector.dot(computation.normalVector)
        let sin2T = (nRatio * nRatio) * (1 - (cosI * cosI))

        // We have total internal reflection
        if sin2T > 1 {
            return Color.black
        }

        // Create the refracted ray
        let cosT = sqrt(1 - sin2T)
        let direction =
            computation.normalVector * (nRatio * cosI - cosT) - computation.eyeVector * nRatio
        let refractedRay = Ray(origin: computation.underPoint, direction: direction)

        let color = colorAt(ray: refractedRay, remaining: remaining - 1) * transparency
        return color
    }

    func isShadowed(lightPosition: Tuple, point: Tuple) -> Bool {
        let v = lightPosition - point
        let distance = v.magnitude
        let direction = v.normalized()

        let ray = Ray(origin: point, direction: direction)
        let xs = intersects(ray: ray)
        let hit = Intersection.hit(xs)

        if hit != nil && hit!.t < distance {
            if hit!.object!.castsShadow {
                return true
            }
        }

        return false
    }

    func computeBounds() {
        for obj in objects {
            obj.computeBounds()
        }
    }

    var objects: [Shape] = []
    var lights: [any Light] = []
    var camera: Camera? = nil
}
