//
//  Tuple.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import simd

extension Double {
    func modulo(_ b: Double) -> Double {
        return self - b * floor(self / b)
    }
}

struct Tuple: Equatable, AdditiveArithmetic {

    static let epsilon = 0.00001
    static let zero = Tuple(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
    static let pointZero = Tuple(x: 0.0, y: 0.0, z: 0.0, w: 1.0)

    public static func Vector() -> Tuple {
        return Tuple(x: 0, y: 0, z: 0, w: 0)
    }

    public static func Vector(x: Double, y: Double, z: Double) -> Tuple {
        return Tuple(x: x, y: y, z: z, w: 0)
    }

    public static func Vector(x: Double, y: Double, z: Double, w: Double) -> Tuple {
        return Tuple(x: x, y: y, z: z, w: w)
    }

    public static func Point() -> Tuple {
        return Tuple(x: 0, y: 0, z: 0, w: 1)
    }

    public static func Point(x: Double, y: Double, z: Double) -> Tuple {
        return Tuple(x: x, y: y, z: z, w: 1.0)
    }

    public static func Point(x: Double, y: Double, z: Double, w: Double) -> Tuple {
        return Tuple(x: x, y: y, z: z, w: w)
    }

    func isVector() -> Bool {
        return w == 0.0
    }

    func isPoint() -> Bool {
        return w == 1.0
    }

    internal init(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0, w: Double = 0.0) {
        self.backingSIMD = SIMD4<Float>(Float(x), Float(y), Float(z), Float(w))
    }

    static func *= (lhs: inout Tuple, rhs: Double) {
        lhs.x *= rhs
        lhs.y *= rhs
        lhs.z *= rhs
        lhs.w *= rhs
    }

    static func /= (lhs: inout Tuple, rhs: Double) {
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
        lhs.w /= rhs
    }

    static func += (lhs: inout Tuple, rhs: Tuple) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
        lhs.w += rhs.w
    }

    static func -= (lhs: inout Tuple, rhs: Tuple) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
        lhs.w -= rhs.w
    }

    static func + (lhs: Tuple, rhs: Tuple) -> Tuple {
        var lhs = lhs
        lhs += rhs
        return lhs
    }

    static func - (lhs: Tuple, rhs: Tuple) -> Tuple {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }

    static func * (lhs: Tuple, rhs: Double) -> Tuple {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }

    static func / (lhs: Tuple, rhs: Double) -> Tuple {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }

    static func == (lhs: Tuple, rhs: Tuple) -> Bool {
        return almostEqual(lhs: lhs.x, rhs: rhs.x) && almostEqual(lhs: lhs.y, rhs: rhs.y)
            && almostEqual(lhs: lhs.z, rhs: rhs.z) && almostEqual(lhs: lhs.w, rhs: rhs.w)
    }

    static prefix func - (lhs: Tuple) -> Tuple {
        return lhs * -1.0
    }

    static func almostEqual(lhs: Double, rhs: Double) -> Bool {
        if abs(lhs) == .infinity && abs(rhs) == .infinity {
            return true
        }

        return abs(lhs - rhs) < epsilon
    }

    mutating func normalize() {
        let mag = self.magnitude
        if mag != 0 { 
            self.x /= mag
            self.y /= mag
            self.z /= mag
            self.w /= mag
        }
    }

    func normalized() -> Tuple {
        let mag = self.magnitude
        if mag == 0 { return self }
        return Tuple(x: x / mag, y: y / mag, z: z / mag, w: w / mag)
    }

    static func dot(lhs: Tuple, rhs: Tuple) -> Double {
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z + lhs.w * rhs.w
    }

    func dot(_ rhs: Tuple) -> Double {
        return Tuple.dot(lhs: self, rhs: rhs)
    }

    static func cross(lhs: Tuple, rhs: Tuple) -> Tuple {
        let x = lhs.y * rhs.z - lhs.z * rhs.y
        let y = lhs.z * rhs.x - lhs.x * rhs.z
        let z = lhs.x * rhs.y - lhs.y * rhs.x
        return Tuple.Vector(x: x, y: y, z: z)
    }

    func cross(_ rhs: Tuple) -> Tuple {
        return Tuple.cross(lhs: self, rhs: rhs)
    }

    func reflected(normal: Tuple) -> Tuple {
        return self - normal * 2 * self.dot(normal)
    }

    func toColor() -> Color {
        return Color(r: Float(x), g: Float(y), b: Float(z))
    }

    func sphericalMap() -> (Double, Double) {
        let π = Double.pi
        let theta = atan2(x, z)
        let vec = Tuple.Vector(x: x, y: y, z: z)
        let radius = vec.magnitude
        let phi = acos(y / radius)
        let rawU = theta / (2 * π)
        let u = 1 - (rawU + 0.5)
        let v = 1 - phi / π
        return (u, v)
    }

    func planarMap() -> (Double, Double) {
        let u = x.modulo(1.0)
        let v = z.modulo(1.0)

        return (u, v)
    }

    func cylindricalMap() -> (Double, Double) {
        //        function cylindrical_map(p)
        //        # compute the azimuthal angle, same as with spherical_map()
        //        let theta ← arctan2(p.x, p.y)
        //        let raw_u ← theta / (2 * π)
        //        let u ← 1 - (raw_u + 0.5)
        //
        //        # let v go from 0 to 1 between whole units of y
        //        let v ← p.y mod 1
        //
        //        return (u, v)
        //        end function

        let theta = atan2(x, z)
        let rawU = theta / (2 * .pi)
        let u = 1 - (rawU + 0.5)

        let v = y.modulo(1)

        return (u, v)
    }

    func faceFromPoint() -> Face {
        let absX = abs(x)
        let absY = abs(y)
        let absZ = abs(z)

        let coord = max(absX, absY, absZ)

        if coord == x {
            return .Right
        }

        if coord == -x {
            return .Left
        }

        if coord == y {
            return .Up
        }

        if coord == -y {
            return .Down
        }

        if coord == z {
            return .Front
        }

        return .Back
    }

    func cubeUvFront() -> (Double, Double) {
        //        function cube_uv_front(point)
        //        let u ← ((point.x + 1) mod 2.0) / 2.0
        //        let v ← ((point.y + 1) mod 2.0) / 2.0
        //
        //        return (u, v)
        //        end

        let u = (x + 1).modulo(2.0) / 2.0
        let v = (y + 1).modulo(2.0) / 2.0
        return (u, v)
    }

    func cubeUvBack() -> (Double, Double) {
        //        function cube_uv_back(point)
        //        let u ← ((1 - point.x) mod 2.0) / 2.0
        //        let v ← ((point.y + 1) mod 2.0) / 2.0
        //
        //        return (u, v)
        //        end
        //
        let u = (1 - x).modulo(2.0) / 2.0
        let v = (y + 1).modulo(2.0) / 2.0

        return (u, v)
    }

    func cubeUvLeft() -> (Double, Double) {
        let u = (z - 1).modulo(2.0) / 2.0
        let v = (y + 1).modulo(2.0) / 2.0

        return (u, v)
    }

    func cubeUvRight() -> (Double, Double) {
        let u = (1 - z).modulo(2.0) / 2.0
        let v = (y + 1).modulo(2.0) / 2.0

        return (u, v)
    }

    func cubeUvUp() -> (Double, Double) {
        let u = (x + 1).modulo(2.0) / 2.0
        let v = (1 - z).modulo(2.0) / 2.0

        return (u, v)
    }

    func cubeUvDown() -> (Double, Double) {
        let u = (x - 1).modulo(2.0) / 2.0
        let v = (z + 1).modulo(2.0) / 2.0

        return (u, v)
    }

    var magnitude: Double {
        if isVector() {
            return sqrt(x * x + y * y + z * z)
        } else {
            // Treat as homogeneous point; divide by w
            if w == 0 { return 0 }
            let nx = x / w
            let ny = y / w
            let nz = z / w
            return sqrt(nx * nx + ny * ny + nz * nz)
        }
    }

    subscript(index: Int) -> Double {
        get {
            assert(index >= 0 && index < 4, "Index out of range")
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default: return w
            }
        }
        set {
            assert(index >= 0 && index < 4, "Index out of range")
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default: w = newValue
            }
        }
    }

    var description: String {
        return "[ \(x), \(y), \(z), \(w) ]"
    }

    var x: Double {
        get { Double(backingSIMD.x) }
        set { backingSIMD.x = Float(newValue) }
    }
    var y: Double {
        get { Double(backingSIMD.y) }
        set { backingSIMD.y = Float(newValue) }
    }
    var z: Double {
        get { Double(backingSIMD.z) }
        set { backingSIMD.z = Float(newValue) }
    }
    var w: Double {
        get { Double(backingSIMD.w) }
        set { backingSIMD.w = Float(newValue) }
    }

    private var backingSIMD: SIMD4<Float> = SIMD4<Float>(0, 0, 0, 0)
}
