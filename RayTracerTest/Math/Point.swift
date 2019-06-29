//
//  Point.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Point: Equatable, AdditiveArithmetic {
    static var zero = Point(x: 0.0, y: 0.0, z: 0.0, w: 1.0)
    
    static func *= (lhs: inout Point, rhs: Double) {
        lhs.x *= rhs;
        lhs.y *= rhs;
        lhs.z *= rhs;
        lhs.w *= rhs;
    }
    
    static func /= (lhs: inout Point, rhs: Double) {
        lhs.x /= rhs;
        lhs.y /= rhs;
        lhs.z /= rhs;
        lhs.w /= rhs;
    }
    
    static func += (lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
        lhs.w += rhs.w
    }
    
    static func += (lhs: inout Point, rhs: Vector) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    static func -= (lhs: inout Point, rhs: Point) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
        lhs.w -= rhs.w
    }
    
    static func + (lhs: Point, rhs: Point) -> Point {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func + (lhs: Point, rhs: Vector) -> Point {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func - (lhs: Point, rhs: Point) -> Point {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    
    static func * (lhs: Point, rhs: Double) -> Point {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func / (lhs: Point, rhs: Double) -> Point {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return almostEqual(lhs: lhs.x, rhs: rhs.x) &&
            almostEqual(lhs: lhs.y, rhs: rhs.y) &&
            almostEqual(lhs: lhs.z, rhs: rhs.z) &&
            almostEqual(lhs: lhs.w, rhs: rhs.w)
    }
    
    static func almostEqual(lhs: Double, rhs: Double) -> Bool {
        let epsilon = 0.00001
        return abs(lhs - rhs) < epsilon
    }
    
    init(x: Double = 0.0, y: Double = 0.0, z: Double = 0.0, w: Double = 1.0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    static func normalize(rhs: Point) -> Point {
        let mag = rhs.magnitude;
        return Point(x: rhs.x / mag, y: rhs.y / mag, z: rhs.z / mag, w: rhs.w / mag)
    }
    
    mutating func normalize() {
        let mag = magnitude;
        x /= mag
        y /= mag
        z /= mag
        w /= mag
    }
    
    static func dot(lhs: Point, rhs: Point) -> Double {
        return lhs.x * rhs.x +
            lhs.y * rhs.y +
            lhs.z * rhs.z +
            lhs.w * rhs.w
    }
    
    func dot(rhs: Point) -> Double {
        return Point.dot(lhs: self, rhs: rhs)
    }
    
    static func cross(lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.y * rhs.z - lhs.z * rhs.y,
                      y: lhs.z * rhs.x - lhs.x * rhs.z,
                      z: lhs.x * rhs.y - lhs.y * rhs.x)
    }
    
    func cross(rhs: Point) -> Point {
        return Point.cross(lhs: self, rhs: rhs)
    }
    
    var magnitude : Double {
        get {
            return sqrt((x * x) + (y * y) + (z * z) + (w * w))
        }
    }
    
    var x: Double
    var y: Double
    var z: Double
    var w: Double
}
