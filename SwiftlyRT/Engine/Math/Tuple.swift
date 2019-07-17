//
//  Tuple.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

extension Double {
    func modulo(_ b: Double) -> Double {
        return self - b * floor(self / b)
    }
}

struct Tuple: Equatable, AdditiveArithmetic {
    
    static let epsilon = 0.00001
    static var zero = Tuple(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
    static var pointZero = Tuple(x: 0.0, y: 0.0, z: 0.0, w: 1.0)

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
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    static func *= (lhs: inout Tuple, rhs: Double) {
        lhs.x *= rhs;
        lhs.y *= rhs;
        lhs.z *= rhs;
        lhs.w *= rhs;
    }
    
    static func /= (lhs: inout Tuple, rhs: Double) {
        lhs.x /= rhs;
        lhs.y /= rhs;
        lhs.z /= rhs;
        lhs.w /= rhs;
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
        return almostEqual(lhs: lhs.x, rhs: rhs.x) &&
            almostEqual(lhs: lhs.y, rhs: rhs.y) &&
            almostEqual(lhs: lhs.z, rhs: rhs.z) &&
            almostEqual(lhs: lhs.w, rhs: rhs.w)
    }
    
    static prefix func - (lhs: Tuple) ->Tuple {
        return lhs * -1.0
    }
    
    static func almostEqual(lhs: Double, rhs: Double) -> Bool {
        if abs(lhs) == .infinity && abs(rhs) == .infinity {
            return true
        }
        
        return abs(lhs - rhs) < epsilon
    }
    
    mutating func normalize() {
        self /= magnitude
    }
    
    func normalized() -> Tuple {
        let mag = magnitude;
        return Tuple(x: x/mag, y: y/mag, z: z/mag, w: w/mag)
    }
    
    static func dot(lhs: Tuple, rhs: Tuple) -> Double {
        return lhs.x * rhs.x +
               lhs.y * rhs.y +
               lhs.z * rhs.z +
               lhs.w * rhs.w
    }
    
    func dot(_ rhs: Tuple) -> Double {
        return self.x * rhs.x +
               self.y * rhs.y +
               self.z * rhs.z +
               self.w * rhs.w
    }
    
    static func cross(lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(x: lhs.y * rhs.z - lhs.z * rhs.y,
                     y: lhs.z * rhs.x - lhs.x * rhs.z,
                     z: lhs.x * rhs.y - lhs.y * rhs.x)
    }
    
    func cross(_ rhs: Tuple) -> Tuple {
        return Tuple(x: self.y * rhs.z - self.z * rhs.y,
                     y: self.z * rhs.x - self.x * rhs.z,
                     z: self.x * rhs.y - self.y * rhs.x)
    }

    func reflected(normal: Tuple) -> Tuple {
        return self - normal * 2 * self.dot(normal)
    }
    
    func toColor() -> Color {
        return Color(r: Float(x), g: Float(y), b: Float(z))
    }
    
    func sphericalMap() -> (Double, Double) {
        let π = Double.pi
        let theta = atan2(x, y)
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
        
        return (0.0, 0.0)
    }
    
    
    func cubeUvFront() -> (Double, Double) {
//        function cube_uv_front(point)
//        let u ← ((point.x + 1) mod 2.0) / 2.0
//        let v ← ((point.y + 1) mod 2.0) / 2.0
//
//        return (u, v)
//        end
//
        return (0.0, 0.0)
    }
    
    func cubeUvBack() -> (Double, Double) {
//        function cube_uv_back(point)
//        let u ← ((1 - point.x) mod 2.0) / 2.0
//        let v ← ((point.y + 1) mod 2.0) / 2.0
//
//        return (u, v)
//        end
//
        return (0.0, 0.0)
    }
    
    func cubeUvLeft() -> (Double, Double) {
        return (0.0, 0.0)
    }
    
    func cubeUvRight() -> (Double, Double) {
        return (0.0, 0.0)
    }
    
    func cubeUvTop() -> (Double, Double) {

        return (0.0, 0.0)
    }
    
    func cubeUvBottom() -> (Double, Double) {
        return (0.0, 0.0)
    }
    
    var magnitude : Double {
        if isVector() {
            return sqrt((x * x) + (y * y) + (z * z))
        } else {
            return sqrt((x * x)/w + (y * y)/w + (z * z)/w)
        }
    }

    subscript(index:Int) -> Double {
        get {
            assert(index >= 0 && index < backing.count, "Index out of range")
            return backing[index]
        }
        set {
            assert(index >= 0 && index < backing.count, "Index out of range")
            backing[index] = newValue
        }
    }
    
    var description : String {
        return "[ \(x), \(y), \(z), \(w) ]"
    }
    
    var x: Double {
        get {
            return backing[0]
        }
        set {
            backing[0] = newValue
        }
    }
    var y: Double {
        get {
            return backing[1]
        }
        set {
            backing[1] = newValue
        }
    }
    var z: Double {
        get {
            return backing[2]
        }
        set {
            backing[2] = newValue
        }
    }
    var w: Double {
        get {
            return backing[3]
        }
        set {
            backing[3] = newValue
        }
    }

    private var backing = Array<Double>(repeating: 0.0, count: 4)
}
