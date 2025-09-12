//
//  WorldLoader.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/14/19.
//  Copyright © 2025 Luster Images. All rights reserved.
//

import Foundation
import Yams
import OSLog

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let worldLoaderLogger = OSLog(subsystem: subsystem, category: "WorldLoader")
}

struct WorldLoader {

    static func convertTo<T>(_ value: Any?) -> T {

        if T.self is Double.Type {
            return ((value as? NSNumber)?.doubleValue as! T)

        } else if T.self is Float.Type {
            return ((value as? NSNumber)?.floatValue as! T)

        } else if T.self is Int.Type {
            return ((value as? NSNumber)?.intValue as! T)
        } else if T.self is String.Type {
            return (value as? String ?? "") as! T
        } else if T.self is Bool.Type {
            return ((value as? Bool) ?? false) as! T
        }

        return value as! T
    }

    static func toArray<T>(_ values: [Any]?) -> [T] {
        var output: [T] = []

        if let v = values {
            for value in v {
                output.append(convertTo(value))
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

    func toUvPattern(_ uvEntry: [String: Any]) -> Pattern? {
        var uvPattern: Pattern? = nil

        if let uvType = uvEntry["type"] as? String {

            switch uvType {
            case "checkers":
                if let colors = uvEntry["colors"] {
                    let a = WorldLoader.toColor((colors as? [Any])?.first as? [Any])
                    let b = WorldLoader.toColor((colors as? [Any])?.last as? [Any])

                    let width = uvEntry["width"] as? Int ?? 1
                    let height = uvEntry["height"] as? Int ?? 1

                    uvPattern = UVCheckers(width: width, height: height, a: a, b: b)
                }

            case "align_check":
                if let colors = uvEntry["colors"] as? [String: [Any]] {

                    var main = Color.white
                    var ul = Color.white
                    var ur = Color.white
                    var bl = Color.white
                    var br = Color.white

                    if let colorValues = colors["main"] {
                        main = WorldLoader.toColor(colorValues)
                    }

                    if let colorValues = colors["ul"] {
                        ul = WorldLoader.toColor(colorValues)
                    }

                    if let colorValues = colors["ur"] {
                        ur = WorldLoader.toColor(colorValues)
                    }

                    if let colorValues = colors["bl"] {
                        bl = WorldLoader.toColor(colorValues)
                    }

                    if let colorValues = colors["br"] {
                        br = WorldLoader.toColor(colorValues)
                    }

                    uvPattern = UVAlignCheck(main: main, ul: ul, ur: ur, bl: bl, br: br)
                }

            case "image":
                if let file = uvEntry["file"] as? String {
                    let objUrl = URL.init(
                        fileURLWithPath: (rootPath as NSString).appendingPathComponent(file))
                    if let canvas = Canvas(fromUrl: objUrl) {
                        uvPattern = UVImage(canvas: canvas)
                    }
                }

            default:
                os_log("Unsupported type", log: OSLog.worldLoaderLogger, type: .error)
            }
        }

        //        uvPattern?.transform = toTransform(uvEntry["transform"] as? [Any])
        return uvPattern
    }

    func toPattern(_ values: [String: Any]) -> Pattern? {
        let type: String = WorldLoader.convertTo(values["type"])
        var pattern: Pattern? = nil

        switch type {
        case "checkers":
            if let colors = values["colors"] {
                let a = WorldLoader.toColor((colors as? [Any])?.first as? [Any])
                let b = WorldLoader.toColor((colors as? [Any])?.last as? [Any])
                pattern = CheckerPattern(a: a, b: b)
            }

        case "gradients":
            if let colors = values["colors"] {
                let a = WorldLoader.toColor((colors as? [Any])?.first as? [Any])
                let b = WorldLoader.toColor((colors as? [Any])?.last as? [Any])
                pattern = GradientPattern(a: a, b: b)
            }

        case "stripes":
            if let colors = values["colors"] {
                let a = WorldLoader.toColor((colors as? [Any])?.first as? [Any])
                let b = WorldLoader.toColor((colors as? [Any])?.last as? [Any])
                pattern = StripePattern(a: a, b: b)
            }

        case "solid-color":
            if let colors = values["colors"] {
                let a = WorldLoader.toColor((colors as? [Any])?.first as? [Any])
                pattern = SolidColorPattern(a)
            }

        case "test":
            pattern = TestPattern()

        case "rings":
            if let colors = values["colors"] {
                let a = WorldLoader.toColor((colors as? [Any])?.first as? [Any])
                let b = WorldLoader.toColor((colors as? [Any])?.last as? [Any])
                pattern = RingPattern(a: a, b: b)
            }

        case "map":
            var mapping = Mapping.Spherical
            if let mapType = values["mapping"] as? String {
                mapping = Mapping(rawValue: mapType) ?? Mapping.Spherical
            }

            if mapping == .Cube {
                var left: Pattern? = nil
                var right: Pattern? = nil
                var up: Pattern? = nil
                var down: Pattern? = nil
                var front: Pattern? = nil
                var back: Pattern? = nil

                if let sideEntry = values["left"] as? [String: Any] {
                    left = toUvPattern(sideEntry)
                }

                if let sideEntry = values["right"] as? [String: Any] {
                    right = toUvPattern(sideEntry)
                }

                if let sideEntry = values["up"] as? [String: Any] {
                    up = toUvPattern(sideEntry)
                }

                if let sideEntry = values["down"] as? [String: Any] {
                    down = toUvPattern(sideEntry)
                }

                if let sideEntry = values["back"] as? [String: Any] {
                    back = toUvPattern(sideEntry)
                }

                if let sideEntry = values["front"] as? [String: Any] {
                    front = toUvPattern(sideEntry)
                }

                pattern = CubeMapPattern(
                    left: left, front: front, right: right, back: back, up: up, down: down)
            }

            if let uvEntry = values["uv_pattern"] as? [String: Any] {
                if let uvPattern = toUvPattern(uvEntry) {
                    pattern = TextureMapPattern(mapping: mapping, uvPattern: uvPattern)
                }
            }

        default:
            return pattern
        }

        pattern?.transform = toTransform(values["transform"] as? [Any])

        return pattern
    }

    func toMaterial(_ key: String?, values: [String: Any]?) -> Material {
        var m = Material()
        var localValues = values

        if localValues == nil && key != nil {
            if let materialValues = definedMaterials[key!] as? [String: Any] {
                if let extendedMaterial = materialValues["extend"] as? String {
                    m = toMaterial(
                        extendedMaterial, values: materialValues["value"] as? [String: Any])
                } else {
                    localValues = definedMaterials[key!] as? [String: Any]
                }
            }
        }

        if localValues != nil {
            if let pattern = localValues!["pattern"] as? [String: Any] {
                m.pattern = toPattern(pattern)
            }

            if let color = localValues!["color"] as? [Any] {
                m.color = WorldLoader.toColor(color)
            }

            if let ambient = localValues!["ambient"] {
                m.ambient = WorldLoader.convertTo(ambient)
            }

            if let specular = localValues!["specular"] {
                m.specular = WorldLoader.convertTo(specular)
            }

            if let shininess = localValues!["shininess"] {
                m.shininess = WorldLoader.convertTo(shininess)
            }

            if let diffuse = localValues!["diffuse"] {
                m.diffuse = WorldLoader.convertTo(diffuse)
            }

            if let reflective = localValues!["reflective"] {
                m.reflective = WorldLoader.convertTo(reflective)
            }

            if let transparency = localValues!["transparency"] {
                m.transparency = WorldLoader.convertTo(transparency)
            }

            if let refractiveIndex = localValues!["refractive-index"] {
                m.refractiveIndex = WorldLoader.convertTo(refractiveIndex)
            }
        }

        return m
    }

    func toTransformArray(_ values: [Any]?) -> [Matrix4x4] {
        var operations: [Matrix4x4] = []

        if let v = values {
            for transform in v {

                if let tran = transform as? String {
                    if tran.hasSuffix("-object") {
                        if let definedOps = definedObjects[tran] as? [Any] {
                            operations.append(contentsOf: toTransformArray(definedOps))
                        }
                    }

                    if tran.hasSuffix("-transform") {
                        if let definedOps = definedTransforms[tran] {
                            operations.append(contentsOf: toTransformArray(definedOps))
                        }
                    }
                }

                if let tran = transform as? [Any] {
                    if let type = tran[0] as? String {
                        switch type {
                        case "scale":
                            let a: Double = WorldLoader.convertTo(tran[1])
                            let b: Double = WorldLoader.convertTo(tran[2])
                            let c: Double = WorldLoader.convertTo(tran[3])
                            let m = Matrix4x4.scaled(x: a, y: b, z: c)
                            operations.insert(m, at: 0)
                            break

                        case "rotate-x":
                            let a: Double = WorldLoader.convertTo(tran[1])
                            let m = Matrix4x4.rotatedX(a)
                            operations.insert(m, at: 0)
                            break

                        case "rotate-y":
                            let a: Double = WorldLoader.convertTo(tran[1])
                            let m = Matrix4x4.rotatedY(a)
                            operations.insert(m, at: 0)
                            break

                        case "rotate-z":
                            let a: Double = WorldLoader.convertTo(tran[1])
                            let m = Matrix4x4.rotatedZ(a)
                            operations.insert(m, at: 0)
                            break

                        case "translate":
                            let a: Double = WorldLoader.convertTo(tran[1])
                            let b: Double = WorldLoader.convertTo(tran[2])
                            let c: Double = WorldLoader.convertTo(tran[3])
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

    func toTransform(_ values: [Any]?) -> Matrix4x4 {
        var output = Matrix4x4.identity
        let operations = toTransformArray(values)

        for m in operations {
            output *= m
        }

        return output
    }

    func toShape(_ type: String, newEntry: [String: Any]) -> Shape? {
        var newShape: Shape? = nil

        switch type {
        case "sphere":
            newShape = Sphere()
            break

        case "cube":
            newShape = Cube()
            break

        case "plane":
            newShape = Plane()
            break

        case "fir_branch":
            newShape = FirBranch()
            break

        case "cylinder":
            let shape = Cylinder()
            if let min = newEntry["min"] {
                shape.minimum = WorldLoader.convertTo(min)
            }
            if let max = newEntry["max"] {
                shape.maximum = WorldLoader.convertTo(max)
            }

            shape.closed = WorldLoader.convertTo(newEntry["closed"])
            newShape = shape
            break

        case "cone":
            let shape = Cone()
            if let min = newEntry["min"] {
                shape.minimum = WorldLoader.convertTo(min)
            }
            if let max = newEntry["max"] {
                shape.maximum = WorldLoader.convertTo(max)
            }

            shape.closed = WorldLoader.convertTo(newEntry["closed"])
            newShape = shape
            break

        case "csg":
            var csg: CSG? = nil
            var leftShape: Shape? = nil
            var rightShape: Shape? = nil

            if let left = newEntry["left"] as? [String: Any] {
                if let type = left["type"] as? String {
                    leftShape = toShape(type, newEntry: left)
                }
            }

            if let right = newEntry["right"] as? [String: Any] {
                if let type = right["type"] as? String {
                    rightShape = toShape(type, newEntry: right)
                }
            }

            if let operation = newEntry["operation"] as? String {
                if leftShape != nil && rightShape != nil {
                    switch operation {
                    case "difference":
                        csg = CSG.difference(left: leftShape!, right: rightShape!)
                        break
                    case "intersection":
                        csg = CSG.intersection(left: leftShape!, right: rightShape!)
                        break
                    case "union":
                        csg = CSG.union(left: leftShape!, right: rightShape!)
                        break

                    default:
                        break
                    }
                }
            }

            newShape = csg
            break

        case "group":
            let group = Group()

            if let children = newEntry["children"] as? [Any] {
                for c in children {
                    if let childEntry = c as? [String: Any] {
                        if let add = childEntry["add"] as? String {
                            let child = toShape(add, newEntry: childEntry)
                            if child != nil {
                                group.addChild(child!)
                            }
                        }
                    }
                }
            }

            newShape = group
            break

        case "obj":
            let group = Group()
            group.filename = newEntry["file"] as? String
            let resize = (newEntry["resize"] as? Bool) ?? false
            if let file = group.filename {
                let objUrl = URL.init(
                    fileURLWithPath: (rootPath as NSString).appendingPathComponent(file))
                let objParser = ObjParser.parse(objFilePath: objUrl, resizeObject: resize)
                group.addChild(objParser.toGroup())
                group.divide(threshold: 1)
            }

            newShape = group

            break

        default:
            if let definedEntry = definedShapes[type] as? [String: Any] {
                if let addType = definedEntry["add"] as? String {
                    let shape = toShape(addType, newEntry: definedEntry)
                    newShape = shape
                }
            }

            break
        }

        if let shape = newShape {
            shape.name = String(describing: shape.self)
            let material = toMaterial(
                newEntry["material"] as? String, values: newEntry["material"] as? [String: Any])
            if material != Material() {
                shape.material = material
            }
            shape.transform = toTransform(newEntry["transform"] as? [Any]) * shape.transform

            if let shadows = newEntry["shadow"] {
                shape.castsShadow = WorldLoader.convertTo(shadows)
            }
        }

        return newShape
    }

    mutating func loadWorld(fromYamlFile: URL?) -> World {
        let filePath = fromYamlFile

        definedShapes.removeAll()
        definedMaterials.removeAll()

        let world = World()

        if let url = filePath {
            rootPath = ((url.path) as NSString).deletingLastPathComponent

            do {
                let contents: String = try String.init(contentsOf: url, encoding: .ascii)
                let loadedArray = try Yams.load(yaml: contents) as? [Any]

                for entry in loadedArray! {
                    if let newEntry = entry as? [String: Any] {
                        if let add = newEntry["add"] as? String {

                            switch add {
                            case "camera":
                                let fieldOfView: Double = WorldLoader.convertTo(
                                    newEntry["field-of-view"])
                                let from = WorldLoader.toPoint(newEntry["from"] as? [Any])
                                let to = WorldLoader.toPoint(newEntry["to"] as? [Any])
                                let up = WorldLoader.toVector(newEntry["up"] as? [Any])
                                let height: Int = WorldLoader.convertTo(newEntry["height"])
                                let width: Int = WorldLoader.convertTo(newEntry["width"])

                                if width > 0 && height > 0 {
                                    var camera = Camera(
                                        w: width, h: height, fieldOfView: fieldOfView)
                                    camera.transform = Matrix4x4.viewTransformed(
                                        from: from, to: to, up: up)
                                    camera.from = from
                                    camera.to = to
                                    camera.up = up
                                    world.camera = camera
                                }

                            case "light":
                                let intensity = WorldLoader.toColor(newEntry["intensity"] as? [Any])
                                if let _ = newEntry["corner"] as? [Any] {
                                    let corner = WorldLoader.toPoint(newEntry["corner"] as? [Any])
                                    let uvec = WorldLoader.toVector(newEntry["uvec"] as? [Any])
                                    let vvec = WorldLoader.toVector(newEntry["vvec"] as? [Any])
                                    let usteps: Int = WorldLoader.convertTo(newEntry["usteps"])
                                    let vsteps: Int = WorldLoader.convertTo(newEntry["vsteps"])
                                    let jitter: Bool = newEntry["jitter"] as? Bool ?? false
                                    let intensity = WorldLoader.toColor(
                                        newEntry["intensity"] as? [Any])

                                    var areaLight = AreaLight(
                                        corner: corner, uvec: uvec, usteps: usteps, vvec: vvec,
                                        vsteps: vsteps, intensity: intensity)
                                    areaLight.jitter = jitter
                                    world.lights.append(areaLight)
                                } else {
                                    let at = WorldLoader.toPoint(newEntry["at"] as? [Any])
                                    world.lights.append(
                                        PointLight(position: at, intensity: intensity))
                                }

                            default:
                                let newShape: Shape? = toShape(add, newEntry: newEntry)
                                if let shape = newShape {
                                    world.objects.append(shape)
                                } else {
                                    os_log("Invalid option %{public}@", log: OSLog.worldLoaderLogger, type: .error, String(describing: newEntry))
                                }
                            }
                        }

                        if let define = newEntry["define"] as? String {
                            if define.hasSuffix("-material") {
                                if let extendsKey = newEntry["extend"] as? String {
                                    let extendedEntry = [
                                        "extend": extendsKey, "value": newEntry["value"],
                                    ]
                                    definedMaterials[define] = extendedEntry as [String: Any]
                                } else if let value = newEntry["value"] as? [String: Any] {
                                    definedMaterials[define] = value
                                }
                            } else if define.hasSuffix("-transform") {
                                if let value = newEntry["value"] as? [Any] {
                                    definedTransforms[define] = value
                                }
                            } else if define.hasSuffix("-object") {
                                if let value = newEntry["value"] as? [Any] {
                                    definedObjects[define] = value
                                }
                            } else {
                                if let value = newEntry["value"] as? [String: Any] {
                                    definedShapes[define] = value
                                }
                            }
                        }
                    }
                }

            } catch {
                os_log("Error loading file: %{public}@", log: OSLog.worldLoaderLogger, type: .error, error.localizedDescription)
            }
        }

        return world
    }

    private var definedObjects: [String: Any] = [:]
    private var definedShapes: [String: Any] = [:]
    private var definedMaterials: [String: [String: Any]?] = [:]
    private var definedTransforms: [String: [Any]?] = [:]

    var rootPath: String = ""
}
