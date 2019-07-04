//
//  Tuple.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

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
        return abs(lhs - rhs) < epsilon
    }
    
    static func normalize(rhs: Tuple) -> Tuple {
        let mag = rhs.magnitude;
        return Tuple(x: rhs.x / mag, y: rhs.y / mag, z: rhs.z / mag, w: rhs.w / mag)
    }
    
    func normalize() -> Tuple {
        let mag = magnitude;
        return Tuple(x: x/mag, y: y/mag, z: z/mag, w: w/mag)
    }
    
    static func dot(lhs: Tuple, rhs: Tuple) -> Double {
        return lhs.x * rhs.x +
               lhs.y * rhs.y +
               lhs.z * rhs.z +
               lhs.w * rhs.w
    }
    
    func dot(rhs: Tuple) -> Double {
        return Tuple.dot(lhs: self, rhs: rhs)
    }
    
    static func cross(lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(x: lhs.y * rhs.z - lhs.z * rhs.y,
                     y: lhs.z * rhs.x - lhs.x * rhs.z,
                     z: lhs.x * rhs.y - lhs.y * rhs.x)
    }
    
    func cross(rhs: Tuple) -> Tuple {
        return Tuple.cross(lhs: self, rhs: rhs)
    }
    
    static func reflect(lhs: Tuple, normal: Tuple) -> Tuple {
        return lhs - normal * 2 * Tuple.dot(lhs: lhs, rhs: normal)
    }

    func reflect(normal: Tuple) -> Tuple {
        return Tuple.reflect(lhs: self, normal: normal)
    }
    
    func toColor() -> Color {
        return Color(r: Float(x), g: Float(y), b: Float(z))
    }
    
    var magnitude : Double {
        get {
            return sqrt((x * x) + (y * y) + (z * z) + (w * w))
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
        get {
            return "[ \(x), \(y), \(z), \(w) ]"
        }
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
