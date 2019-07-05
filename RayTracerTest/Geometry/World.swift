//
//  World.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class World {
    static var MaximumRecursionDepth = 5
    
    static func defaultWorld() -> World {
        let light = PointLight(position: Tuple.Point(x: -10, y: 10, z: -10), intensity: Color.white)
        let s1 = Sphere()
        s1.material.color = Color(r: 0.8, g: 1.0, b: 0.6)
        s1.material.diffuse = 0.7
        s1.material.specular = 0.2
        s1.name = "s1"
        
        let s2 = Sphere()
        s2.transform = Matrix4x4.scale(x: 0.5, y: 0.5, z: 0.5)
        s2.name = "s2"
        
        let world = World()
        world.objects.append(s1)
        world.objects.append(s2)
        world.light = light
        
        return world
    }
    
    static func intersects(world: World, ray: Ray) -> [Intersection] {
        var intersections: [Intersection] = []
        for shape: Shape in world.objects {
            intersections.append(contentsOf: shape.intersects(ray: ray))
        }

        return intersections.sorted()
    }
    
    func intersects(ray: Ray) -> [Intersection] {
        return World.intersects(world: self, ray: ray)
    }
    
    static func shadeHit(world: World, computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        if (world.light == nil || computation.object == nil) {
            return Color.black
        }
        
        let shadowed = world.isShadowed(point: computation.overPoint)
        
        let surface = world.light!.lighting(object: computation.object,
                                     material: computation.object!.material,
                                     position: computation.overPoint,
                                     eyeVector: computation.eyeVector,
                                     normalVector: computation.normalVector,
                                     inShadow: shadowed)
        var reflected = world.reflectedColor(computation: computation, remaining: remaining)
        var refracted = world.refractedColor(computation: computation, remaining: remaining)
        
        if computation.object!.material.reflective > 0 && computation.object!.material.transparency > 0 {
            let reflectance = computation.schlick()
            reflected *= Float(reflectance)
            refracted *= Float(1 - reflectance)
        }
        
        return surface + reflected + refracted
    }
    
    func shadeHit(computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        return World.shadeHit(world: self, computation: computation, remaining: remaining)
    }
    
    static func colorAt(world: World, ray: Ray, remaining: Int = MaximumRecursionDepth) -> Color {
        let xs = world.intersects(ray: ray)
        let hit = Intersection.hit(xs)

        if (hit == nil) {
            return Color.black
        } else {
            let comps = hit!.prepareCopmutation(ray: ray)
            return world.shadeHit(computation: comps, remaining: remaining)
        }
    }
    
    func colorAt(ray: Ray, remaining: Int = MaximumRecursionDepth) -> Color {
        return World.colorAt(world: self, ray: ray, remaining: remaining)
    }
    
    static func reflectedColor(world: World, computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        if remaining < 1 {
            return Color.black
        }
        
        let material = computation.object?.material ?? Material()
        if material.reflective.isZero {
            return Color.black
        }
        
        let reflectRay = Ray(origin: computation.overPoint, direction: computation.reflectVector)
        let color = colorAt(world: world, ray: reflectRay, remaining: remaining - 1)
        return color * material.reflective
    }
    
    func reflectedColor(computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        return World.reflectedColor(world: self, computation: computation, remaining: remaining)
    }
    
    let b = """
    const Colour World::refractedColour(const Hit &hit, int remaining) const noexcept {
        if (remaining < 1)
            return predefined_colours::black;

        const auto transparency = hit.getObject()->getMaterial()->getTransparency();
        if (transparency == 0)
            return predefined_colours::black;

        // Apply Snell's Law to find the angle of refraction.
        const auto n_ratio = hit.getN1() / hit.getN2();
        const auto cos_i = hit.getEyeVector().dot_product(hit.getNormalVector());
        const auto sin2_t = n_ratio * n_ratio * (1 - cos_i * cos_i);

        // If sin2_t > 1, we have total internal reflection.
        if (sin2_t > 1)
            return predefined_colours::black;

        // Create the refracted ray.
        const auto cos_t = const_sqrtd(1 - sin2_t);
        const auto direction = hit.getNormalVector() * (n_ratio * cos_i - cos_t) - hit.getEyeVector() * n_ratio;
        const Ray refract_ray{hit.getUnderPoint(), direction};

        // Find its colour.
        const auto colour = colourAt(refract_ray, remaining - 1) * transparency;
        return colour;
    }
"""
    
    static func refractedColor(world: World, computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
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
        let cosI = computation.eyeVector.dot(rhs: computation.normalVector)
        let sin2T = pow(nRatio, 2) * (1 - pow(cosI, 2))
        
        // We have total internal reflection
        if sin2T > 1 {
            return Color.black
        }

        // Create the refracted ray
        let cosT = sqrt(1 - sin2T)
        let direction = computation.normalVector * (nRatio * cosI - cosT) - computation.eyeVector * nRatio
        let refractedRay = Ray(origin: computation.underPoint, direction: direction)
        
        let color = colorAt(world: world, ray: refractedRay, remaining: remaining - 1) * transparency
        return color
    }
    
    func refractedColor(computation: Computation, remaining: Int = MaximumRecursionDepth) -> Color {
        return World.refractedColor(world: self, computation: computation, remaining: remaining)
    }
    
    static func isShadowed(world: World, point: Tuple) -> Bool {
        assert(world.light != nil)
        let v = world.light!.position - point
        let distance = v.magnitude
        let direction = v.normalize()
        
        let ray = Ray(origin: point, direction: direction)
        let xs = world.intersects(ray: ray)
        let hit = Intersection.hit(xs)
        
        if hit != nil && hit!.t < distance {
            return true
        }
        
        return false
    }
    
    func isShadowed(point: Tuple) -> Bool {
        return World.isShadowed(world: self, point: point)
    }
    
    var objects: [Shape] = []
    var light: PointLight? = nil
}
