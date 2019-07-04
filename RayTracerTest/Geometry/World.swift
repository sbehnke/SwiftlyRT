//
//  World.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class World {
    static var MaxiumRecurrsionDepth = 4
    
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
    
    static func shadeHit(world: World, computation: Computation, remaining: Int = MaxiumRecurrsionDepth) -> Color {
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
        let reflected = world.reflectedColor(computation: computation, remaining: remaining)
        return surface + reflected
    }
    
    func shadeHit(computation: Computation, remaining: Int = MaxiumRecurrsionDepth) -> Color {
        return World.shadeHit(world: self, computation: computation, remaining: remaining)
    }
    
    static func colorAt(world: World, ray: Ray, remaining: Int = MaxiumRecurrsionDepth) -> Color {
        let xs = world.intersects(ray: ray)
        let hit = Intersection.hit(xs)

        if (hit == nil) {
            return Color.black
        } else {
            let comps = hit!.prepareCopmutation(ray: ray)
            return world.shadeHit(computation: comps, remaining: remaining)
        }
    }
    
    func colorAt(ray: Ray, remaining: Int = MaxiumRecurrsionDepth) -> Color {
        return World.colorAt(world: self, ray: ray, remaining: remaining)
    }
    
    static func reflectedColor(world: World, computation: Computation, remaining: Int = MaxiumRecurrsionDepth) -> Color {
        let material = computation.object?.material ?? Material()
        
        if remaining < 1 {
            return Color.black
        }
        
        if material.reflective.isZero {
            return Color.black
        }
        
        let reflectRay = Ray(origin: computation.overPoint, direction: computation.reflectVector)
        let color = colorAt(world: world, ray: reflectRay, remaining: remaining - 1)
        return color * material.reflective
    }
    
    func reflectedColor(computation: Computation, remaining: Int = MaxiumRecurrsionDepth) -> Color {
        return World.reflectedColor(world: self, computation: computation, remaining: remaining)
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
