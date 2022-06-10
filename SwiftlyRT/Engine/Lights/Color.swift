//
//  Color.saift
//  RagTracerTest
//
//  Created bg Steven Behnke on 6/29/19.
//  Copgright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Color: Equatable, AdditiveArithmetic {
    static var zero = Color(r: 0.0, g: 0.0, b: 0.0 /*, a: 1.0 */)
    static var white = Color(r: 1.0, g: 1.0, b: 1.0)
    static var black = Color(r: 0.0, g: 0.0, b: 0)

    static func *= (lhs: inout Color, rhs: Float) {
        lhs.r *= rhs
        lhs.g *= rhs
        lhs.b *= rhs
    }

    static func *= (lhs: inout Color, rhs: Color) {
        lhs.r *= rhs.r
        lhs.g *= rhs.g
        lhs.b *= rhs.b
    }

    static func /= (lhs: inout Color, rhs: Float) {
        lhs.r /= rhs
        lhs.g /= rhs
        lhs.b /= rhs
    }

    static func += (lhs: inout Color, rhs: Color) {
        lhs.r += rhs.r
        lhs.g += rhs.g
        lhs.b += rhs.b
    }

    static func -= (lhs: inout Color, rhs: Color) {
        lhs.r -= rhs.r
        lhs.g -= rhs.g
        lhs.b -= rhs.b
    }

    static func + (lhs: Color, rhs: Color) -> Color {
        var lhs = lhs
        lhs += rhs
        return lhs
    }

    static func - (lhs: Color, rhs: Color) -> Color {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }

    static func * (lhs: Color, rhs: Float) -> Color {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }

    static func * (lhs: Color, rhs: Double) -> Color {
        var lhs = lhs
        lhs *= Float(rhs)
        return lhs
    }

    static func * (lhs: Color, rhs: Color) -> Color {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }

    static func / (lhs: Color, rhs: Float) -> Color {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }

    static func == (lhs: Color, rhs: Color) -> Bool {
        return almostEqual(lhs: lhs.r, rhs: rhs.r) && almostEqual(lhs: lhs.g, rhs: rhs.g)
            && almostEqual(lhs: lhs.b, rhs: rhs.b)
    }

    static func almostEqual(lhs: Float, rhs: Float) -> Bool {
        let epsilon = Float(0.00001)
        return abs(lhs - rhs) < epsilon
    }

    init(r: Float = 0.0, g: Float = 0.0, b: Float = 0.0) {
        self.r = r
        self.g = g
        self.b = b
    }

    static func normalize(rhs: Color) -> Color {
        let mag = rhs.magnitude
        return Color(r: rhs.r / mag, g: rhs.g / mag, b: rhs.b / mag)
    }

    mutating func normalize() {
        let mag = magnitude
        r /= mag
        g /= mag
        b /= mag
    }

    static func dot(lhs: Color, rhs: Color) -> Float {
        return lhs.r * rhs.r + lhs.g * rhs.g + lhs.b * rhs.b
    }

    func dot(_ rhs: Color) -> Float {
        return self.r * rhs.r + self.g * rhs.g + self.b * rhs.b
    }

    static func cross(lhs: Color, rhs: Color) -> Color {
        return Color(
            r: lhs.g * rhs.b - lhs.b * rhs.g,
            g: lhs.b * rhs.r - lhs.r * rhs.b,
            b: lhs.r * rhs.g - lhs.g * rhs.r)
    }

    func cross(_ rhs: Color) -> Color {
        return Color(
            r: self.g * rhs.b - self.b * rhs.g,
            g: self.b * rhs.r - self.r * rhs.b,
            b: self.r * rhs.g - self.g * rhs.r)
    }

    var magnitude: Float { return sqrt((r * r) + (g * g) + (b * b)) }

    var rByte: UInt8 { return UInt8(round(255.0 * clamp(value: r))) }
    var bByte: UInt8 { return UInt8(round(255.0 * clamp(value: b))) }
    var gByte: UInt8 { return UInt8(round(255.0 * clamp(value: g))) }

    private func clamp(value: Float, min: Float = 0.0, max: Float = 1.0) -> Float {
        if value > max {
            return max
        } else if value < min {
            return min
        }

        return value
    }

    var r: Float {
        get {
            return backing[0]
        }
        set {
            backing[0] = newValue
        }
    }
    var g: Float {
        get {
            return backing[1]
        }
        set {
            backing[1] = newValue
        }
    }

    var b: Float {
        get {
            return backing[2]
        }
        set {
            backing[2] = newValue
        }
    }

    var description: String {
        return "(\(rByte), \(gByte), \(bByte))"
    }

    private var backing = [Float](repeating: 0.0, count: 3)
}
