//
//  World.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import Yams

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
        s2.transform = Matrix4x4.scaled(x: 0.5, y: 0.5, z: 0.5)
        s2.name = "s2"
        
        let world = World()
        world.objects.append(s1)
        world.objects.append(s2)
        world.light = light
        
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
        if (light == nil || computation.object == nil) {
            return Color.black
        }
        
        let shadowed = isShadowed(point: computation.overPoint)
        
        let surface = computation.object!.material.lighting(object: computation.object,
                                                            light: light!,
                                                            position: computation.overPoint,
                                                            eyeVector: computation.eyeVector,
                                                            normalVector: computation.normalVector,
                                                            inShadow: shadowed)
        var reflected = reflectedColor(computation: computation, remaining: remaining)
        var refracted = refractedColor(computation: computation, remaining: remaining)
        
        if computation.object!.material.reflective > 0 && computation.object!.material.transparency > 0 {
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
        let direction = computation.normalVector * (nRatio * cosI - cosT) - computation.eyeVector * nRatio
        let refractedRay = Ray(origin: computation.underPoint, direction: direction)
        
        let color = colorAt(ray: refractedRay, remaining: remaining - 1) * transparency
        return color
    }
    
    
    func isShadowed(point: Tuple) -> Bool {
        assert(light != nil)
        
        if let l = light {
            let v = l.position - point
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
        }
        
        return false
    }
    
    static func convertTo<T>(_ value: Any?) -> T where T: ScalarConstructible {
        
        if T.self is Double.Type {
            if let newValue = value as? Int {
                return Double(newValue) as! T
            }
            
            if let newValue = value as? Double {
                return Double(newValue) as! T
            }
            
        } else if T.self is Float.Type {
            if let newValue = value as? Int {
                return Float(newValue) as! T
            }
            
            if let newValue = value as? Float {
                return Float(newValue) as! T
            }
            
            if let newValue = value as? Double {
                return Float(newValue) as! T
            }
            
        } else if T.self is Int.Type {
            if let newValue = value as? Int {
                return Int(newValue) as! T
            }
        }
        
        return 0 as! T
    }
    
    static func toArray<T>(_ values: [Any]?) -> [T] {
        var output: [T] = []
        
        if let v = values {
            for value in v {
                if T.self is Double.Type {
                    if let newValue = value as? Int {
                        output.append(Double(newValue) as! T)
                    }
                    
                    if let newValue = value as? Double {
                        output.append(Double(newValue) as! T)
                    }
                } else if T.self is Int.Type {
                    if let newValue = value as? Int {
                        output.append(Double(newValue) as! T)
                    }
                }
            }
        }
        
        return output
    }
    
    static func toPoint(_ values: [Any]?) -> Tuple {
        let converted: [Double] = toArray(values)
        
        if converted.count == 3 {
            return Tuple.Point(x: converted[0], y: converted[1], z: converted[2])
        } else if converted.count == 4 {
            return Tuple.Point(x: converted[0], y: converted[1], z: converted[2], w: converted[3])
        }
        
        return Tuple.pointZero
    }
    
    static func toVector(_ values: [Any]?) -> Tuple {
        let converted: [Double] = toArray(values)
        
        if converted.count == 3 {
            return Tuple.Vector(x: converted[0], y: converted[1], z: converted[2])
        } else if converted.count == 4 {
            return Tuple.Vector(x: converted[0], y: converted[1], z: converted[2], w: converted[3])
        }
        
        return Tuple.pointZero
    }
    
    static func toColor(_ values: [Any]?) -> Color {
        let converted: [Double] = toArray(values)
        
        if converted.count == 3 {
            return Tuple.Point(x: converted[0], y: converted[1], z: converted[2]).toColor()
        }
        
        return Color.white
    }
    
    static func toMaterial(_ values: [String:Any]?) -> Material {
        var m = Material()
        
        if values != nil {
            
            if let pattern = values!["pattern"] as? [String:Any] {
                // TODO, parse patterns
                print(pattern)
                m.pattern = TestPattern()
            }
        
            if let color = values!["color"] as? [Any] {
                m.color = toColor(color)
            }
            
            if let ambient = values!["ambient"] {
                m.ambient = convertTo(ambient)
            }
            
            if let specular = values!["specular"] {
                m.specular = convertTo(specular)
            }
            
            if let shininess = values!["shininess"] {
                m.shininess = convertTo(shininess)
            }
            
            if let diffuse = values!["diffuse"] {
                m.diffuse = convertTo(diffuse)
            }
            
            if let reflective = values!["reflective"] {
                m.reflective = convertTo(reflective)
            }
            
            if let transparency = values!["transparency"] {
                m.transparency = convertTo(transparency)
            }
            
            if let refractiveIndex = values!["refractiveIndex"] {
                m.refractiveIndex = convertTo(refractiveIndex)
            }
        }
        
        return m
    }
    
    static func toTransformArray(_ values: [Any]?) -> [Matrix4x4] {
        var operations: [Matrix4x4] = []
        
        if let v = values {
            for transform in v {
                if let tran = transform as? [Any] {
                    if let type = tran[0] as? String {
                        switch(type) {
                        case "scale":
                            let a = tran[1] as? Double ?? 0.0
                            let b = tran[2] as? Double ?? 0.0
                            let c = tran[3] as? Double ?? 0.0
                            let m = Matrix4x4.scaled(x: a, y: b, z: c)
                            operations.insert(m, at: 0)
                            break
                            
                        case "rotate-x":
                            let a = tran[1] as? Double ?? 0.0
                            let m = Matrix4x4.rotatedZ(a)
                            operations.insert(m, at: 0)
                            break
                            
                        case "rotate-y":
                            let a = tran[1] as? Double ?? 0.0
                            let m = Matrix4x4.rotatedZ(a)
                            operations.insert(m, at: 0)
                            break
                            
                        case "rotate-z":
                            let a = tran[1] as? Double ?? 0.0
                            let m = Matrix4x4.rotatedZ(a)
                            operations.insert(m, at: 0)
                            break
                            
                        case "translate":
                            let a = tran[1] as? Double ?? 0.0
                            let b = tran[2] as? Double ?? 0.0
                            let c = tran[3] as? Double ?? 0.0
                            let m = Matrix4x4.translated(x: a, y: b, z: c)
                            operations.insert(m, at: 0)
                            break
                            
                        default:
                            break
                        }
                    }
                }
            }
        }
        
        return operations
    }
    
    static func toTransform(_ values: [Any]?) -> Matrix4x4 {
        var output = Matrix4x4.identity
        let operations = toTransformArray(values)
        
        for m in operations {
            output *= m
        }
        
        return output
    }
    
    static func fromYamlFile(_ filePath: URL?) -> World {
        let world = World()
        
        if let url = filePath {
            
            
            do {
                let contents: String = try String.init(contentsOf: url, encoding: .ascii)
                let loadedArray = try Yams.load(yaml: contents) as? [Any]
                
                for entry in loadedArray!{
                    
                    if let newEntry = entry as? [String:Any] {
                        if let add = newEntry["add"] as? String {

                            switch add {
                            case "camera":
                                let fieldOfView = newEntry["field-of-view"] as? Double ?? 1.0
                                let from = toPoint(newEntry["from"] as? [Any])
                                let to = toPoint(newEntry["to"] as? [Any])
                                let up = toVector(newEntry["up"] as? [Any])
                                let height = newEntry["height"] as? Int ?? 0
                                let width = newEntry["width"] as? Int ?? 0
                                
                                if width > 0 && height > 0 {
                                    var camera = Camera(w: width, h: height, fieldOfView: fieldOfView)
                                    camera.transform = Matrix4x4.viewTransformed(from: from, to: to, up: up)
                                    world.camera = camera
                                }
                                break
                                
                            case "light":
                                let at = toPoint(newEntry["at"] as? [Any])
                                let intensity = toColor(newEntry["intensity"] as? [Any])
                                world.light = PointLight(position: at, intensity: intensity)
                                
                                break
                                
                            case "sphere":
                                let shape = Sphere()
                                shape.name = String(describing: shape.self)
                                shape.material = toMaterial(newEntry["material"] as? [String:Any])
                                shape.transform = toTransform(newEntry["transform"] as? [Any])
                                world.objects.append(shape)
                                
                                break
                                
                            case "cube":
                                let shape = Cube()
                                shape.name = String(describing: shape.self)
                                shape.material = toMaterial(newEntry["material"] as? [String:Any])
                                shape.transform = toTransform(newEntry["transform"] as? [Any])
                                world.objects.append(shape)
                                
                                break
                                
                                
                            case "plane":
                                let shape = Plane()
                                shape.name = String(describing: shape.self)
                                shape.material = toMaterial(newEntry["material"] as? [String:Any])
                                shape.transform = toTransform(newEntry["transform"] as? [Any])
                                world.objects.append(shape)
                                
                                break
                                
                                
                            case "cylinder":
                                let shape = Cylinder()
                                shape.name = String(describing: shape.self)
                                shape.material = toMaterial(newEntry["material"] as? [String:Any])
                                shape.transform = toTransform(newEntry["transform"] as? [Any])
                                if let min = newEntry["min"] {
                                    shape.minimum = convertTo(min)
                                }
                                if let max = newEntry["max"] {
                                    shape.maximum = convertTo(max)
                                }
                                if let closed = newEntry["closed"] as? Bool {
                                    shape.closed = closed
                                }
                                
                                world.objects.append(shape)
                                
                                break
                                
                            case "cone":
                                let shape = Cone()
                                shape.name = String(describing: shape.self)
                                shape.material = toMaterial(newEntry["material"] as? [String:Any])
                                shape.transform = toTransform(newEntry["transform"] as? [Any])
                                if let min = newEntry["min"] {
                                    shape.minimum = convertTo(min)
                                }
                                if let max = newEntry["max"] {
                                    shape.maximum = convertTo(max)
                                }
                                if let closed = newEntry["closed"] as? String {
                                    shape.closed = closed == "true"
                                }
                                
                                world.objects.append(shape)
                                
                                break
                                
                            default:
                                break;
                                
                            }
                        }
                        
                        if let define = newEntry["define"] as? String {
                            switch define {
                                
                            default:
                                break;
                                
                            }
                        }
                    }
                }
                

                print("f")

            } catch {}
        }
        
        return world
    }
    
    var objects: [Shape] = []
    var light: PointLight? = nil
    var camera: Camera? = nil
}
