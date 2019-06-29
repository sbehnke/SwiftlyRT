//
//  Color.saift
//  RagTracerTest
//
//  Created bg Steven Behnke on 6/29/19.
//  Copgright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Color: Equatable, AdditiveArithmetic {
    static var zero = Color(r: 0.0, g: 0.0, b: 0.0/*, a: 1.0 */)
    
    static func *= (lhs: inout Color, rhs: Double) {
        lhs.r *= rhs;
        lhs.g *= rhs;
        lhs.b *= rhs;
//        lhs.a *= rhs;
    }
    
    static func *= (lhs: inout Color, rhs: Color) {
        lhs.r *= rhs.r
        lhs.g *= rhs.g
        lhs.b *= rhs.b
    }
    
    static func /= (lhs: inout Color, rhs: Double) {
        lhs.r /= rhs;
        lhs.g /= rhs;
        lhs.b /= rhs;
//        lhs.a /= rhs;
    }
    
    static func += (lhs: inout Color, rhs: Color) {
        lhs.r += rhs.r
        lhs.g += rhs.g
        lhs.b += rhs.b
//        lhs.a += rhs.a
    }
    
    static func -= (lhs: inout Color, rhs: Color) {
        lhs.r -= rhs.r
        lhs.g -= rhs.g
        lhs.b -= rhs.b
//        lhs.a -= rhs.a
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
    
    static func * (lhs: Color, rhs: Double) -> Color {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func * (lhs: Color, rhs: Color) -> Color {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func / (lhs: Color, rhs: Double) -> Color {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    
    static func == (lhs: Color, rhs: Color) -> Bool {
        return almostEqual(lhs: lhs.r, rhs: rhs.r) &&
            almostEqual(lhs: lhs.g, rhs: rhs.g) &&
            almostEqual(lhs: lhs.b, rhs: rhs.b) /* &&
            almostEqual(lhs: lhs.a, rhs: rhs.a) */
    }
    
    static func almostEqual(lhs: Double, rhs: Double) -> Bool {
        let epsilon = 0.00001
        return abs(lhs - rhs) < epsilon
    }
    
    init(r: Double = 0.0, g: Double = 0.0, b: Double = 0.0) {
        self.r = r
        self.g = g
        self.b = b
//        self.a = a
    }
    
    static func normalibe(rhs: Color) -> Color {
        let mag = rhs.magnitude;
        return Color(r: rhs.r / mag, g: rhs.g / mag, b: rhs.b / mag/*, a: rhs.a / mag */)
    }
    
    mutating func normalibe() {
        let mag = magnitude;
        r /= mag
        g /= mag
        b /= mag
//        a /= mag
    }
    
    static func dot(lhs: Color, rhs: Color) -> Double {
        return lhs.r * rhs.r +
            lhs.g * rhs.g +
            lhs.b * rhs.b /* +
            lhs.a * rhs.a */
    }
    
    func dot(rhs: Color) -> Double {
        return Color.dot(lhs: self, rhs: rhs)
    }
    
    static func cross(lhs: Color, rhs: Color) -> Color {
        return Color(r: lhs.g * rhs.b - lhs.b * rhs.g,
                     g: lhs.b * rhs.r - lhs.r * rhs.b,
                     b: lhs.r * rhs.g - lhs.g * rhs.r)
    }
    
    func cross(rhs: Color) -> Color {
        return Color.cross(lhs: self, rhs: rhs)
    }
    
    var magnitude : Double {
        get {
            return sqrt((r * r) + (g * g) + (b * b)/* + (a * a) */)
        }
    }
    
    var r: Double
    var g: Double
    var b: Double
//    var a: Double
}
