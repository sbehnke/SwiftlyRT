//
//  Tuple.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Vector: Equatable  { AdditiveArithmetic {
    static var zero = Vector(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
    
    static func *= (lhs: inout Vector, rhs: Double) {
        lhs.x *= rhs;
        lhs.y *= rhs;
        lhs.z *= rhs;
        lhs.w *= rhs;
    }
    
    static func /= (lhs: inout Vector, rhs: Double) {
        lhs.x /= rhs;
        lhs.y /= rhs;
        lhs.z /= rhs;
        lhs.w /= rhs;
    }
    
    static func += (lhs: inout Vector, rhs: Vector) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
        lhs.w += rhs.w
    }
    
    static func -= (lhs: inout Vector, rhs: Vector) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
        lhs.w -= rhs.w
    }
    
    static func + (lhs: Vector, rhs: Vector) -> Vector {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    
    static func * (lhs: Vector, rhs: Double) -> Vector {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func / (lhs: Vector, rhs: Double) -> Vector {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    
    static func == (lhs: Vector, rhs: Vector) -> Bool {
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
    
    static func normalize(rhs: Vector) -> Vector {
        let mag = rhs.magnitude;
        return Vector(x: rhs.x / mag, y: rhs.y / mag, z: rhs.z / mag, w: rhs.w / mag)
    }
    
    mutating func normalize() {
        let mag = magnitude;
        x /= mag
        y /= mag
        z /= mag
        w /= mag
    }
    
    static func dot(lhs: Vector, rhs: Vector) -> Double {
        return lhs.x * rhs.x +
               lhs.y * rhs.y +
               lhs.z * rhs.z +
               lhs.w * rhs.w
    }
    
    func dot(rhs: Vector) -> Double {
        return Vector.dot(lhs: self, rhs: rhs)
    }
    
    static func cross(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(x: lhs.y * rhs.z - lhs.z * rhs.y,
                     y: lhs.z * rhs.x - lhs.x * rhs.z,
                     z: lhs.x * rhs.y - lhs.y * rhs.x)
    }
    
    func cross(rhs: Vector) -> Vector {
        return Vector.cross(lhs: self, rhs: rhs)
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
