//
//  Tuple.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Vector4: Equatable, AdditiveArithmetic {
    static var zero = Vector4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
    static var pointZero = Vector4(x: 0.0, y: 0.0, z: 0.0, w: 1.0)
    
    static func *= (lhs: inout Vector4, rhs: Double) {
        lhs.x *= rhs;
        lhs.y *= rhs;
        lhs.z *= rhs;
        lhs.w *= rhs;
    }
    
    static func /= (lhs: inout Vector4, rhs: Double) {
        lhs.x /= rhs;
        lhs.y /= rhs;
        lhs.z /= rhs;
        lhs.w /= rhs;
    }
    
    static func += (lhs: inout Vector4, rhs: Vector4) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
        lhs.w += rhs.w
    }
    
    static func -= (lhs: inout Vector4, rhs: Vector4) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
        lhs.w -= rhs.w
    }
    
    static func + (lhs: Vector4, rhs: Vector4) -> Vector4 {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func - (lhs: Vector4, rhs: Vector4) -> Vector4 {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    
    static func * (lhs: Vector4, rhs: Double) -> Vector4 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func / (lhs: Vector4, rhs: Double) -> Vector4 {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    
    static func == (lhs: Vector4, rhs: Vector4) -> Bool {
        return almostEqual(lhs: lhs.x, rhs: rhs.x) &&
            almostEqual(lhs: lhs.y, rhs: rhs.y) &&
            almostEqual(lhs: lhs.z, rhs: rhs.z) &&
            almostEqual(lhs: lhs.w, rhs: rhs.w)
    }
    
    static func almostEqual(lhs: Double, rhs: Double) -> Bool {
        let epsilon = 0.00001
        return abs(lhs - rhs) < epsilon
    }
    
    init(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0, w: Double = 0.0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    static func normalize(rhs: Vector4) -> Vector4 {
        let mag = rhs.magnitude;
        return Vector4(x: rhs.x / mag, y: rhs.y / mag, z: rhs.z / mag, w: rhs.w / mag)
    }
    
    mutating func normalize() {
        let mag = magnitude;
        x /= mag
        y /= mag
        z /= mag
        w /= mag
    }
    
    static func dot(lhs: Vector4, rhs: Vector4) -> Double {
        return lhs.x * rhs.x +
               lhs.y * rhs.y +
               lhs.z * rhs.z +
               lhs.w * rhs.w
    }
    
    func dot(rhs: Vector4) -> Double {
        return Vector4.dot(lhs: self, rhs: rhs)
    }
    
    static func cross(lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(x: lhs.y * rhs.z - lhs.z * rhs.y,
                     y: lhs.z * rhs.x - lhs.x * rhs.z,
                     z: lhs.x * rhs.y - lhs.y * rhs.x)
    }
    
    func cross(rhs: Vector4) -> Vector4 {
        return Vector4.cross(lhs: self, rhs: rhs)
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
