//
//  PatternTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class PatternTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testingStripPatternConstructor() {
//    Background:
//    Given black ← color(0, 0, 0)
//    And white ← color(1, 1, 1)
//
//    Scenario: Creating a stripe pattern
//    Given pattern ← stripe_pattern(white, black)
//    Then pattern.a = white
//    And pattern.b = black

        let pattern = StripePattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.a, Color.white)
        XCTAssertEqual(pattern.b, Color.black)
    }
    
    func testStripePatternConstantY() {
//    Scenario: A stripe pattern is constant in y
//    Given pattern ← stripe_pattern(white, black)
//    Then stripe_at(pattern, point(0, 0, 0)) = white
//    And stripe_at(pattern, point(0, 1, 0)) = white
//    And stripe_at(pattern, point(0, 2, 0)) = white
    
        let p = StripePattern(a: Color.white, b: Color.black)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 1, z: 0)), Color.white)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 2, z: 0)), Color.white)
    }
    
    func testStripePatternConstantX() {
//    Scenario: A stripe pattern is constant in z
//    Given pattern ← stripe_pattern(white, black)
//    Then stripe_at(pattern, point(0, 0, 0)) = white
//    And stripe_at(pattern, point(0, 0, 1)) = white
//    And stripe_at(pattern, point(0, 0, 2)) = white
    
        let p = StripePattern(a: Color.white, b: Color.black)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 0, z: 1)), Color.white)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 0, z: 2)), Color.white)
    }
    
    func testStripePatternAlternates() {
//    Scenario: A stripe pattern alternates in x
//    Given pattern ← stripe_pattern(white, black)
//    Then stripe_at(pattern, point(0, 0, 0)) = white
//    And stripe_at(pattern, point(0.9, 0, 0)) = white
//    And stripe_at(pattern, point(1, 0, 0)) = black
//    And stripe_at(pattern, point(-0.1, 0, 0)) = black
//    And stripe_at(pattern, point(-1, 0, 0)) = black
//    And stripe_at(pattern, point(-1.1, 0, 0)) = white
    
        let p = StripePattern(a: Color.white, b: Color.black)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(p.patternAt(point: .Point(x: 0.9, y: 0, z: 0)), Color.white)
        XCTAssertEqual(p.patternAt(point: .Point(x: 1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(p.patternAt(point: .Point(x: -0.1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(p.patternAt(point: .Point(x: -1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(p.patternAt(point: .Point(x: -1.1, y: 0, z: 0)), Color.white)
        
        let object = TestShape()
        XCTAssertEqual(p.patternAtShape(object: object, point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(p.patternAtShape(object: object, point: .Point(x: 0.9, y: 0, z: 0)), Color.white)
        XCTAssertEqual(p.patternAtShape(object: object, point: .Point(x: 1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(p.patternAtShape(object: object, point: .Point(x: -0.1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(p.patternAtShape(object: object, point: .Point(x: -1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(p.patternAtShape(object: object, point: .Point(x: -1.1, y: 0, z: 0)), Color.white)
    }
    
    func testStripesWithObjectTransformation() {
//    Scenario: Stripes with an object transformation
//    Given object ← sphere()
//    And set_transform(object, scaling(2, 2, 2))
//    And pattern ← stripe_pattern(white, black)
//    When c ← stripe_at_object(pattern, object, point(1.5, 0, 0))
//    Then c = white

        let object = Sphere()
        object.transform = Matrix4x4.scaled(x: 2, y: 2, z: 2)
        let pattern = StripePattern(a: Color.white, b: Color.black)
        let c = pattern.patternAtShape(object: object, point: Tuple.Point(x: 1.5, y: 0, z: 0))
        let c2 = pattern.patternAtShape(object: object, point: Tuple.Point(x: 1.5, y: 0, z: 0))
        XCTAssertEqual(c, Color.white)
        XCTAssertEqual(c2, Color.white)
    }
    
    func testStripesWithPatternTransformation() {
//    Scenario: Stripes with a pattern transformation
//    Given object ← sphere()
//    And pattern ← stripe_pattern(white, black)
//    And set_pattern_transform(pattern, scaling(2, 2, 2))
//    When c ← stripe_at_object(pattern, object, point(1.5, 0, 0))
//    Then c = white
        
        let object = Sphere()
        let pattern = StripePattern(a: Color.white, b: Color.black)
        pattern.transform = Matrix4x4.scaled(x: 2, y: 2, z: 2)
        let c = pattern.patternAtShape(object: object, point: Tuple.Point(x: 1.5, y: 0, z: 0))
        XCTAssertEqual(c, Color.white)
    }
    
    func testStripesWithBothObjectAndPatternTransform() {
//    Scenario: Stripes with both an object and a pattern transformation
//    Given object ← sphere()
//    And set_transform(object, scaling(2, 2, 2))
//    And pattern ← stripe_pattern(white, black)
//    And set_pattern_transform(pattern, translation(0.5, 0, 0))
//    When c ← stripe_at_object(pattern, object, point(2.5, 0, 0))
//    Then c = white

        let object = Sphere()
        object.transform = Matrix4x4.scaled(x: 2, y: 2, z: 2)
        let pattern = StripePattern(a: Color.white, b: Color.black)
        pattern.transform = Matrix4x4.translated(x: 0.5, y: 0, z: 0)
        let c = pattern.patternAtShape(object: object, point: Tuple.Point(x: 1.5, y: 0, z: 0))
        XCTAssertEqual(c, Color.white)
    }
    
    func testDefaultPatternTransformation() {
//    Scenario: The default pattern transformation
//    Given pattern ← test_pattern()
//    Then pattern.transform = identity_matrix
        
        let p = TestPattern()
        XCTAssertEqual(p.transform, Matrix4x4.identity)
    }
    
    func testAssigningTransformation() {
//    Scenario: Assigning a transformation
//    Given pattern ← test_pattern()
//    When set_pattern_transform(pattern, translation(1, 2, 3))
//    Then pattern.transform = translation(1, 2, 3)
    
        let p = TestPattern()
        p.transform = Matrix4x4.translated(x: 1, y: 2, z: 3)
        XCTAssertEqual(p.transform, Matrix4x4.translated(x: 1, y: 2, z: 3))
    }
    
    func testPatternWithObjectTransformation() {
//    Scenario: A pattern with an object transformation
//    Given shape ← sphere()
//    And set_transform(shape, scaling(2, 2, 2))
//    And pattern ← test_pattern()
//    When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
//    Then c = color(1, 1.5, 2)

        let shape = Sphere()
        shape.transform = .scaled(x: 2, y: 2, z: 2)
        let pattern = TestPattern()
        let c = pattern.patternAtShape(object: shape, point: Tuple.Point(x: 2, y: 3, z: 4))
        XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
    }
    
    func testPatternWithTransformation() {
//    Scenario: A pattern with a pattern transformation
//    Given shape ← sphere()
//    And pattern ← test_pattern()
//    And set_pattern_transform(pattern, scaling(2, 2, 2))
//    When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
//    Then c = color(1, 1.5, 2)

        let shape = Sphere()
        let pattern = TestPattern()
        pattern.transform = .scaled(x: 2, y: 2, z: 2)
        let c = pattern.patternAtShape(object: shape, point: Tuple.Point(x: 2, y: 3, z: 4))
        XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
    }
    
    func testObjectAndPatternTransformation() {
//    Scenario: A pattern with both an object and a pattern transformation
//    Given shape ← sphere()
//    And set_transform(shape, scaling(2, 2, 2))
//    And pattern ← test_pattern()
//    And set_pattern_transform(pattern, translation(0.5, 1, 1.5))
//    When c ← pattern_at_shape(pattern, shape, point(2.5, 3, 3.5))
//    Then c = color(0.75, 0.5, 0.25)
        
        let shape = Sphere()
        shape.transform = .scaled(x: 2, y: 2, z: 2)
        let pattern = TestPattern()
        pattern.transform = Matrix4x4.translated(x: 0.5, y: 1, z: 1.5)
        let c = pattern.patternAtShape(object: shape, point: Tuple.Point(x: 2.5, y: 3, z: 3.5))
        XCTAssertEqual(c, Color(r: 0.75, g: 0.5, b: 0.25))
    }
    
    func testGradiantLinearInteroplation() {
//    Scenario: A gradient linearly interpolates between colors
//    Given pattern ← gradient_pattern(white, black)
//    Then pattern_at(pattern, point(0, 0, 0)) = white
//    And pattern_at(pattern, point(0.25, 0, 0)) = color(0.75, 0.75, 0.75)
//    And pattern_at(pattern, point(0.5, 0, 0)) = color(0.5, 0.5, 0.5)
//    And pattern_at(pattern, point(0.75, 0, 0)) = color(0.25, 0.25, 0.25)

        let pattern = GradientPattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0.25, y: 0, z: 0)), Color(r: 0.75, g: 0.75, b: 0.75))
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0.5, y: 0, z: 0)), Color(r: 0.5, g: 0.5, b: 0.5))
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0.75, y: 0, z: 0)), Color(r: 0.25, g: 0.25, b: 0.25))
    }
    
    func testRingExtendingBothXandY() {
//    Scenario: A ring should extend in both x and z
//    Given pattern ← ring_pattern(white, black)
//    Then pattern_at(pattern, point(0, 0, 0)) = white
//    And pattern_at(pattern, point(1, 0, 0)) = black
//    And pattern_at(pattern, point(0, 0, 1)) = black
//    # 0.708 = just slightly more than √2/2
//    And pattern_at(pattern, point(0.708, 0, 0.708)) = black
    
        let pattern = RingPattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 1, y: 0, z: 0)), Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 1)), Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0.708, y: 0, z: 0.708)), Color.black)
    }
    
    func testCheckersRepeatingX() {
//    Scenario: Checkers should repeat in x
//    Given pattern ← checkers_pattern(white, black)
//    Then pattern_at(pattern, point(0, 0, 0)) = white
//    And pattern_at(pattern, point(0.99, 0, 0)) = white
//    And pattern_at(pattern, point(1.01, 0, 0)) = black
        
        let pattern = CheckerPattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0.99, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 1.01, y: 0, z: 0)), Color.black)
    }
    
    func testCheckersRepeatingY() {
//    Scenario: Checkers should repeat in y
//    Given pattern ← checkers_pattern(white, black)
//    Then pattern_at(pattern, point(0, 0, 0)) = white
//    And pattern_at(pattern, point(0, 0.99, 0)) = white
//    And pattern_at(pattern, point(0, 1.01, 0)) = black
        
        let pattern = CheckerPattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0.99, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 1.01, z: 0)), Color.black)
    }
    
    func testCheckersRepeatingZ() {
//    Scenario: Checkers should repeat in z
//    Given pattern ← checkers_pattern(white, black)
//    Then pattern_at(pattern, point(0, 0, 0)) = white
//    And pattern_at(pattern, point(0, 0, 0.99)) = white
//    And pattern_at(pattern, point(0, 0, 1.01)) = black
        
        let pattern = CheckerPattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0.99)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 1.01)), Color.black)
    }
    
    func testCheckerPatternOutlinedIn2D() {
//    Scenario Outline: Checker pattern in 2D
//    Given checkers ← uv_checkers(2, 2, black, white)
//    When color ← uv_pattern_at(checkers, <u>, <v>)
//    Then color = <expected>
//
//    Examples:
//    | u   | v   | expected |
//    | 0.0 | 0.0 | black    |
//    | 0.5 | 0.0 | white    |
//    | 0.0 | 0.5 | white    |
//    | 0.5 | 0.5 | black    |
//    | 1.0 | 1.0 | black    |

        let u: [Double] = [0.0, 0.5, 0.0, 0.5, 1.0]
        let v: [Double] = [0.0, 0.0, 0.5, 0.5, 1.0]
        let color: [Color] = [Color.black, Color.white, Color.white, Color.black, Color.black]
        
        let checkers = UVCheckers(width: 2, height: 2, a: Color.black, b: Color.white)
        
        for index in 0..<u.count {
            XCTAssertEqual(checkers.uvPatternAt(u: u[index], v: v[index]), color[index], "Color does not match at index: \(index)")
        }
    }
    
    func testSphereicalMapping() {
//        Scenario Outline: Using a spherical mapping on a 3D point
//        Given p ← <point>
//        When (u, v) ← spherical_map(p)
//        Then u = <u>
//        And v = <v>
//
//        Examples:
//        | point                | u    | v    |
//        | point(0, 0, -1)      | 0.0  | 0.5  |
//        | point(1, 0, 0)       | 0.25 | 0.5  |
//        | point(0, 0, 1)       | 0.5  | 0.5  |
//        | point(-1, 0, 0)      | 0.75 | 0.5  |
//        | point(0, 1, 0)       | 0.5  | 1.0  |
//        | point(0, -1, 0)      | 0.5  | 0.0  |
//        | point(√2/2, √2/2, 0) | 0.25 | 0.75 |
        
        let points: [Tuple] = [.Point(x: 0,  y: 0,  z: -1),
                               .Point(x: 1,  y: 0,  z: 0),
                               .Point(x: 0,  y: 0,  z: 1),
                               .Point(x: -1, y: 0,  z: 0),
                               .Point(x: 0,  y: 1,  z: 0),
                               .Point(x: 0,  y: -1, z:  0),
                               .Point(x: sqrt(2)/2, y: sqrt(2)/2, z: 0),]
        let u: [Double] = [0.0, 0.25, 0.5, 0.75, 0.5, 0.5, 0.25, ]
        let v: [Double] = [0.5, 0.5, 0.5, 0.5, 1.0, 0.0, 0.75, ]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].sphericalMap()
            XCTAssertEqual(uOut, u[index], "u does not match for index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match for index: \(index)")
        }
    }
    
    func testUsingTextureMapPatternWithSphericalMap() {
//        Scenario Outline: Using a texture map pattern with a spherical map
//        Given checkers ← uv_checkers(16, 8, black, white)
//        And pattern ← texture_map(checkers, spherical_map)
//        Then pattern_at(pattern, <point>) = <color>
//
//        Examples:
//        | point                            | color |
//        | point(0.4315, 0.4670, 0.7719)    | white |
//        | point(-0.9654, 0.2552, -0.0534)  | black |
//        | point(0.1039, 0.7090, 0.6975)    | white |
//        | point(-0.4986, -0.7856, -0.3663) | black |
//        | point(-0.0317, -0.9395, 0.3411)  | black |
//        | point(0.4809, -0.7721, 0.4154)   | black |
//        | point(0.0285, -0.9612, -0.2745)  | black |
//        | point(-0.5734, -0.2162, -0.7903) | white |
//        | point(0.7688, -0.1470, 0.6223)   | black |
//        | point(-0.7652, 0.2175, 0.6060)   | black |
        
        let points: [Tuple] = [
            .Point(x: 0.4315,  y: 0.4670,   z: 0.7719),
            .Point(x: -0.9654, y:  0.2552,  z: -0.0534),
            .Point(x: 0.1039,  y: 0.7090,   z: 0.6975),
            .Point(x: -0.4986, y:  -0.7856, z: -0.3663),
            .Point(x: -0.0317, y:  -0.9395, z:  0.3411),
            .Point(x: 0.4809,  y: -0.7721,  z:  0.4154),
            .Point(x: 0.0285,  y: -0.9612,  z: -0.2745),
            .Point(x: -0.5734, y:  -0.2162, z: -0.7903),
            .Point(x: 0.7688,  y: -0.1470,  z:  0.6223),
            .Point(x: -0.7652, y:  0.2175,  z:  0.6060),
        ]
        let colors: [Color] = [
            Color.white,
            Color.black,
            Color.white,
            Color.black,
            Color.black,
            Color.black,
            Color.black,
            Color.white,
            Color.black,
            Color.black,
        ]
        
        let uvCheckers = UVCheckers(width: 16, height: 8, a: Color.black, b: Color.white)
        let pattern = TextureMapPattern(mapping: .Spherical, uvPattern: uvCheckers)
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }
    }
    
    func testPlanarMaping() {
//        Scenario Outline: Using a planar mapping on a 3D point
//        Given p ← <point>
//        When (u, v) ← planar_map(p)
//        Then u = <u>
//        And v = <v>
//
//        Examples:
//        | point                   | u    | v    |
//        | point(0.25, 0, 0.5)     | 0.25 | 0.5  |
//        | point(0.25, 0, -0.25)   | 0.25 | 0.75 |
//        | point(0.25, 0.5, -0.25) | 0.25 | 0.75 |
//        | point(1.25, 0, 0.5)     | 0.25 | 0.5  |
//        | point(0.25, 0, -1.75)   | 0.25 | 0.25 |
//        | point(1, 0, -1)         | 0.0  | 0.0  |
//        | point(0, 0, 0)          | 0.0  | 0.0  |

        let points: [Tuple] = [
            .Point(x: 0.25, y: 0,   z:  0.5),
            .Point(x: 0.25, y: 0,   z: -0.25),
            .Point(x: 0.25, y: 0.5, z: -0.25),
            .Point(x: 1.25, y: 0,   z:  0.5),
            .Point(x: 0.25, y: 0,   z: -1.75),
            .Point(x: 1,    y: 0,   z: -1),
            .Point(x: 0,    y: 0,   z:  0),
        ]
        let u = [0.25, 0.25, 0.25, 0.25, 0.25, 0.0, 0.0,]
        let v = [0.5, 0.75, 0.75, 0.5, 0.25, 0.0, 0.0,]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].planarMap()
            XCTAssertEqual(u[index], uOut, "u does not match index: \(index)")
            XCTAssertEqual(v[index], vOut, "v does not match index: \(index)")
        }
    }
    
    func testCylindricalMapping() {
//        Scenario Outline: Using a cylindrical mapping on a 3D point
//        Given p ← <point>
//        When (u, v) ← cylindrical_map(p)
//        Then u = <u>
//        And v = <v>
//
//        Examples:
//        | point                          | u     | v    |
//        | point(0, 0, -1)                | 0.0   | 0.0  |
//        | point(0, 0.5, -1)              | 0.0   | 0.5  |
//        | point(0, 1, -1)                | 0.0   | 0.0  |
//        | point(0.70711, 0.5, -0.70711)  | 0.125 | 0.5  |
//        | point(1, 0.5, 0)               | 0.25  | 0.5  |
//        | point(0.70711, 0.5, 0.70711)   | 0.375 | 0.5  |
//        | point(0, -0.25, 1)             | 0.5   | 0.75 |
//        | point(-0.70711, 0.5, 0.70711)  | 0.625 | 0.5  |
//        | point(-1, 1.25, 0)             | 0.75  | 0.25 |
//        | point(-0.70711, 0.5, -0.70711) | 0.875 | 0.5  |
        
        let u = [0.0, 0.0, 0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875,]
        let v = [0.0, 0.5, 0.0, 0.5, 0.5, 0.5, 0.75, 0.5, 0.25, 0.5,]
        
        let points: [Tuple] = [.Point(x: 0, y: 0,   z: -1),
                               .Point(x: 0, y: 0.5, z: -1),
                               .Point(x: 0, y: 1,   z: -1),
                               .Point(x: 0.70711, y: 0.5, z: -0.70711),
                               .Point(x: 1, y: 0.5, z: 0),
                               .Point(x: 0.70711, y: 0.5, z: 0.70711),
                               .Point(x: 0, y: -0.25, z: 1),
                               .Point(x: -0.70711, y: 0.5, z: 0.70711),
                               .Point(x: -1, y: 1.25, z: 0),
                               .Point(x: -0.70711, y: 0.5, z: -0.70711),]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cylindricalMap()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
    
    func testAlignCheckPattern() {
//        Scenario Outline: Layout of the "align check" pattern
//        Given main ← color(1, 1, 1)
//        And ul ← color(1, 0, 0)
//        And ur ← color(1, 1, 0)
//        And bl ← color(0, 1, 0)
//        And br ← color(0, 1, 1)
//        And pattern ← uv_align_check(main, ul, ur, bl, br)
//        When c ← uv_pattern_at(pattern, <u>, <v>)
//        Then c = <expected>
//
//        Examples:
//        | u    | v    | expected |
//        | 0.5  | 0.5  | main     |
//        | 0.1  | 0.9  | ul       |
//        | 0.9  | 0.9  | ur       |
//        | 0.1  | 0.1  | bl       |
//        | 0.9  | 0.1  | br       |

        let main = Color.white
        let ul = Color(r: 1, g: 0, b: 0)
        let ur = Color(r: 1, g: 1, b: 0)
        let bl = Color(r: 0, g: 1, b: 0)
        let br = Color(r: 0, g: 1, b: 1)
        
        let pattern = UVAlignCheck(main: main, ul: ul, ur: ur, bl: bl, br: br)
        
        let u: [Double] = [0.5, 0.1, 0.9, 0.1, 0.9]
        let v: [Double] = [0.5, 0.9, 0.9, 0.1, 0.1]
        let expected: [Color] = [main, ul, ur, bl, br]
        
        for index in 0..<u.count {
            XCTAssertEqual(expected[index], pattern.uvPatternAt(u: u[index], v: v[index]), "Color does not match at index: \(index)")
        }
    }
    
    func testCubeFaceIdentification() {
//        Scenario Outline: Identifying the face of a cube from a point
//        When face ← face_from_point(<point>)
//        Then face = <face>
//        
//        Examples:
//        | point                  | face    |
//        | point(-1, 0.5, -0.25)  | "left"  |
//        | point(1.1, -0.75, 0.8) | "right" |
//        | point(0.1, 0.6, 0.9)   | "front" |
//        | point(-0.7, 0, -2)     | "back"  |
//        | point(0.5, 1, 0.9)     | "up"    |
//        | point(-0.2, -1.3, 1.1) | "down"  |
        
        let points: [Tuple] = [.Point(x: -1,   y:  0.5,  z: -0.25),
                               .Point(x: 1.1,  y: -0.75, z: 0.8),
                               .Point(x: 0.1,  y:  0.6,  z: 0.9),
                               .Point(x: -0.7, y:  0,    z: -2),
                               .Point(x: 0.5,  y:  1,    z: 0.9),
                               .Point(x: -0.2, y:  -1.3, z: 1.1),]
        let faces: [Face] = [.Left, .Right, .Front, .Back, .Up, .Down]
        
        for index in 0..<points.count {
            XCTAssertEqual(points[index].faceFromPoint(), faces[index], "face does not match for index: \(index)")
        }
        
    }
    
    func testUVMappingFrontFaceOfCube() {
//    Scenario Outline: UV mapping the front face of a cube
//    When (u, v) ← cube_uv_front(<point>)
//    Then u = <u>
//    And v = <v>
//
//    Examples:
//    | point                | u    | v    |
//    | point(-0.5, 0.5, 1)  | 0.25 | 0.75 |
//    | point(0.5, -0.5, 1)  | 0.75 | 0.25 |
        

        let points: [Tuple] = [ .Point(x: -0.5, y: 0.5, z: 1),
                                .Point(x: 0.5, y: -0.5, z: 1) ]
        let u: [Double] = [0.25, 0.75]
        let v: [Double] = [0.75, 0.25]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cubeUvFront()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
    
    func testUVMappingBackFaceOfCube() {
//    Scenario Outline: UV mapping the back face of a cube
//    When (u, v) ← cube_uv_back(<point>)
//    Then u = <u>
//    And v = <v>
//
//    Examples:
//    | point                 | u    | v    |
//    | point(0.5, 0.5, -1)   | 0.25 | 0.75 |
//    | point(-0.5, -0.5, -1) | 0.75 | 0.25 |
        
        let points: [Tuple] = [ .Point(x: 0.5, y: 0.5, z: -1),
                                .Point(x: -0.5, y: -0.5, z: -1) ]
        let u: [Double] = [0.25, 0.75]
        let v: [Double] = [0.75, 0.25]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cubeUvBack()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
    
    func testUVMappingLeftFaceOfCube() {
//    Scenario Outline: UV mapping the left face of a cube
//    When (u, v) ← cube_uv_left(<point>)
//    Then u = <u>
//    And v = <v>
//
//    Examples:
//    | point                | u    | v    |
//    | point(-1, 0.5, -0.5) | 0.25 | 0.75 |
//    | point(-1, -0.5, 0.5) | 0.75 | 0.25 |
        
        let points: [Tuple] = [ .Point(x: -1, y:  0.5, z: -0.5),
                                .Point(x: -1, y: -0.5, z: 0.5) ]
        let u: [Double] = [0.25, 0.75]
        let v: [Double] = [0.75, 0.25]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cubeUvLeft()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
    
    func testUVMappingRightFaceOfCube() {
//    Scenario Outline: UV mapping the right face of a cube
//    When (u, v) ← cube_uv_right(<point>)
//    Then u = <u>
//    And v = <v>
//
//    Examples:
//    | point                | u    | v    |
//    | point(1, 0.5, 0.5)   | 0.25 | 0.75 |
//    | point(1, -0.5, -0.5) | 0.75 | 0.25 |
        
        let points: [Tuple] = [ .Point(x: 1, y: 0.5, z: 0.5),
                                .Point(x: 1, y: -0.5, z: -0.5) ]
        let u: [Double] = [0.25, 0.75]
        let v: [Double] = [0.75, 0.25]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cubeUvRight()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
        
    func testUVMappingUpperFaceOfCube() {
//    Scenario Outline: UV mapping the upper face of a cube
//    When (u, v) ← cube_uv_up(<point>)
//    Then u = <u>
//    And v = <v>
//
//    Examples:
//    | point               | u    | v    |
//    | point(-0.5, 1, -0.5) | 0.25 | 0.75 |
//    | point(0.5, 1, 0.5) | 0.75 | 0.25 |
        
        let points: [Tuple] = [ .Point(x: -0.5, y: 1, z: -0.5),
                                .Point(x: 0.5, y: 1, z: 0.5) ]
        let u: [Double] = [0.25, 0.75]
        let v: [Double] = [0.75, 0.25]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cubeUvUp()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
    
    func testUVMappingLowerFaceOfCube() {
//    Scenario Outline: UV mapping the lower face of a cube
//    When (u, v) ← cube_uv_down(<point>)
//    Then u = <u>
//    And v = <v>
//
//    Examples:
//    | point                 | u    | v    |
//    | point(-0.5, -1, 0.5) | 0.25 | 0.75 |
//    | point(0.5, -1, -0.5)   | 0.75 | 0.25 |
        
        let points: [Tuple] = [ .Point(x: -0.5, y: -1, z: 0.5),
                                .Point(x: 0.5, y: -1, z: -0.5) ]
        let u: [Double] = [0.25, 0.75]
        let v: [Double] = [0.75, 0.25]
        
        for index in 0..<points.count {
            let (uOut, vOut) = points[index].cubeUvDown()
            XCTAssertEqual(uOut, u[index], "u does not match index: \(index)")
            XCTAssertEqual(vOut, v[index], "v does not match index: \(index)")
        }
    }
    
    func testColorsOnMappedCube() {
//        Scenario Outline: Finding the colors on a mapped cube
//        When red ← color(1, 0, 0)
//        And yellow ← color(1, 1, 0)
//        And brown ← color(1, 0.5, 0)
//        And green ← color(0, 1, 0)
//        And cyan ← color(0, 1, 1)
//        And blue ← color(0, 0, 1)
//        And purple ← color(1, 0, 1)
//        And white ← color(1, 1, 1)
//        And left ← uv_align_check(yellow, cyan, red, blue, brown)
//        And front ← uv_align_check(cyan, red, yellow, brown, green)
//        And right ← uv_align_check(red, yellow, purple, green, white)
//        And back ← uv_align_check(green, purple, cyan, white, blue)
//        And up ← uv_align_check(brown, cyan, purple, red, yellow)
//        And down ← uv_align_check(purple, brown, green, blue, white)
//        And pattern ← cube_map(left, front, right, back, up, down)
//        Then pattern_at(pattern, <point>) = <color>
//        
//        Examples:
//        |   | point                 | color  |
//        | L | point(-1, 0, 0)       | yellow |
//        |   | point(-1, 0.9, -0.9)  | cyan   |
//        |   | point(-1, 0.9, 0.9)   | red    |
//        |   | point(-1, -0.9, -0.9) | blue   |
//        |   | point(-1, -0.9, 0.9)  | brown  |
//        | F | point(0, 0, 1)        | cyan   |
//        |   | point(-0.9, 0.9, 1)   | red    |
//        |   | point(0.9, 0.9, 1)    | yellow |
//        |   | point(-0.9, -0.9, 1)  | brown  |
//        |   | point(0.9, -0.9, 1)   | green  |
//        | R | point(1, 0, 0)        | red    |
//        |   | point(1, 0.9, 0.9)    | yellow |
//        |   | point(1, 0.9, -0.9)   | purple |
//        |   | point(1, -0.9, 0.9)   | green  |
//        |   | point(1, -0.9, -0.9)  | white  |
//        | B | point(0, 0, -1)       | green  |
//        |   | point(0.9, 0.9, -1)   | purple |
//        |   | point(-0.9, 0.9, -1)  | cyan   |
//        |   | point(0.9, -0.9, -1)  | white  |
//        |   | point(-0.9, -0.9, -1) | blue   |
//        | U | point(0, 1, 0)        | brown  |
//        |   | point(-0.9, 1, -0.9)  | cyan   |
//        |   | point(0.9, 1, -0.9)   | purple |
//        |   | point(-0.9, 1, 0.9)   | red    |
//        |   | point(0.9, 1, 0.9)    | yellow |
//        | D | point(0, -1, 0)       | purple |
//        |   | point(-0.9, -1, 0.9)  | brown  |
//        |   | point(0.9, -1, 0.9)   | green  |
//        |   | point(-0.9, -1, -0.9) | blue   |
//        |   | point(0.9, -1, -0.9)  | white  |
        
        
        let red = Color(r: 1, g: 0, b: 0)
        let yellow = Color(r: 1, g: 1, b: 0)
        let brown = Color(r: 1, g: 0.5, b: 0)
        let green = Color(r: 0, g: 1, b: 0)
        let cyan = Color(r: 0, g: 1, b: 1)
        let blue = Color(r: 0, g: 0, b: 1)
        let purple = Color(r: 1, g: 0, b: 1)
        let white = Color.white
        
        let left = UVAlignCheck(main: yellow, ul: cyan, ur: red, bl: blue, br: brown)
        let front = UVAlignCheck(main: cyan, ul: red, ur: yellow, bl: brown, br: green)
        let right = UVAlignCheck(main: red, ul: yellow, ur: purple, bl: green, br: white)
        let back = UVAlignCheck(main: green, ul: purple, ur: cyan, bl: white, br: blue)
        let up = UVAlignCheck(main: brown, ul: cyan, ur: purple, bl: red, br: yellow)
        let down = UVAlignCheck(main: purple, ul: brown, ur: green, bl: blue, br: white)
        
        let pattern = CubeMapPattern(left: left, front: front, right: right, back: back, up: up, down: down)
        
        //        And pattern ← cube_map(left, front, right, back, up, down)
        //        Then pattern_at(pattern, <point>) = <color>
        //
        //        Examples:
        //        |   | point                 | color  |
        //        | L | point(-1, 0, 0)       | yellow |
        //        |   | point(-1, 0.9, -0.9)  | cyan   |
        //        |   | point(-1, 0.9, 0.9)   | red    |
        //        |   | point(-1, -0.9, -0.9) | blue   |
        //        |   | point(-1, -0.9, 0.9)  | brown  |
        
        var points: [Tuple] = [.Point(x: -1, y: 0,    z:  0),
                                   .Point(x: -1, y: 0.9,  z: -0.9),
                                   .Point(x: -1, y: 0.9,  z:  0.9),
                                   .Point(x: -1, y: -0.9, z: -0.9),
                                   .Point(x: -1, y: -0.9, z:  0.9),]
        var colors: [Color] = [yellow, cyan, red, blue, brown]
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }
        
        //        | F | point(0, 0, 1)        | cyan   |
        //        |   | point(-0.9, 0.9, 1)   | red    |
        //        |   | point(0.9, 0.9, 1)    | yellow |
        //        |   | point(-0.9, -0.9, 1)  | brown  |
        //        |   | point(0.9, -0.9, 1)   | green  |
        
        points = [.Point(x: 0,    y:  0,   z: 1),
                  .Point(x: -0.9, y:  0.9, z: 1),
                  .Point(x: 0.9,  y:  0.9, z: 1),
                  .Point(x: -0.9, y: -0.9, z: 1),
                  .Point(x: 0.9,  y: -0.9, z: 1),]
        colors = [cyan, red, yellow, brown, green]
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }
        
        //        | R | point(1, 0, 0)        | red    |
        //        |   | point(1, 0.9, 0.9)    | yellow |
        //        |   | point(1, 0.9, -0.9)   | purple |
        //        |   | point(1, -0.9, 0.9)   | green  |
        //        |   | point(1, -0.9, -0.9)  | white  |
        points = [.Point(x: 1, y:  0,   z:  0),
                  .Point(x: 1, y:  0.9, z:  0.9),
                  .Point(x: 1, y:  0.9, z: -0.9),
                  .Point(x: 1, y: -0.9, z:  0.9),
                  .Point(x: 1, y: -0.9, z: -0.9),]
        colors = [red, yellow, purple, green, white]
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }
        
        //        | B | point(0, 0, -1)       | green  |
        //        |   | point(0.9, 0.9, -1)   | purple |
        //        |   | point(-0.9, 0.9, -1)  | cyan   |
        //        |   | point(0.9, -0.9, -1)  | white  |
        //        |   | point(-0.9, -0.9, -1) | blue   |
        points = [.Point(x: 0,    y:  0,   z: -1),
                  .Point(x: 0.9,  y:  0.9, z: -1),
                  .Point(x: -0.9, y:  0.9, z: -1),
                  .Point(x: 0.9,  y: -0.9, z: -1),
                  .Point(x: -0.9, y: -0.9, z: -1),]
        colors = [green, purple, cyan, white, blue]
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }

        //        | U | point(0, 1, 0)        | brown  |
        //        |   | point(-0.9, 1, -0.9)  | cyan   |
        //        |   | point(0.9, 1, -0.9)   | purple |
        //        |   | point(-0.9, 1, 0.9)   | red    |
        //        |   | point(0.9, 1, 0.9)    | yellow |
        points = [.Point(x:0,    y: 1, z:  0),
                  .Point(x:-0.9, y: 1, z: -0.9),
                  .Point(x:0.9,  y: 1, z: -0.9),
                  .Point(x:-0.9, y: 1, z:  0.9),
                  .Point(x:0.9,  y: 1, z:  0.9),]
        colors = [brown, cyan, purple, red, yellow]
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }

        //        | D | point(0, -1, 0)       | purple |
        //        |   | point(-0.9, -1, 0.9)  | brown  |
        //        |   | point(0.9, -1, 0.9)   | green  |
        //        |   | point(-0.9, -1, -0.9) | blue   |
        //        |   | point(0.9, -1, -0.9)  | white  |
        points = [.Point(x: 0,    y: -1, z: 0),
                  .Point(x: -0.9, y: -1, z: 0.9),
                  .Point(x: 0.9,  y: -1, z: 0.9),
                  .Point(x: -0.9, y: -1, z: -0.9),
                  .Point(x: 0.9,  y: -1, z: -0.9),]
        colors = [purple, brown, green, blue, white]
        
        for index in 0..<points.count {
            XCTAssertEqual(pattern.patternAt(point: points[index]), colors[index], "Color does not match for index: \(index)")
        }    }
    
    func testCheckerPatternIn2D() {
//        Scenario Outline: Checker pattern in 2D
//        Given ppm ← a file containing:
//        """
//        P3
//        10 10
//        10
//        0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9
//        1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0
//        2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1
//        3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2
//        4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3
//        5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4
//        6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5
//        7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6
//        8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7
//        9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8
//        """
//        And canvas ← canvas_from_ppm(ppm)
//        And pattern ← uv_image(canvas)
//        When color ← uv_pattern_at(pattern, <u>, <v>)
//        Then color = <expected>
//        
//        Examples:
//        | u   | v   | expected             |
//        | 0   | 0   | color(0.9, 0.9, 0.9) |
//        | 0.3 | 0   | color(0.2, 0.2, 0.2) |
//        | 0.6 | 0.3 | color(0.1, 0.1, 0.1) |
//        | 1   | 1   | color(0.9, 0.9, 0.9) |
        
        let ppm = """
P3
10 10
10
0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9
1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0
2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1
3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2
4 4 4  5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3
5 5 5  6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4
6 6 6  7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5
7 7 7  8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6
8 8 8  9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7
9 9 9  0 0 0  1 1 1  2 2 2  3 3 3  4 4 4  5 5 5  6 6 6  7 7 7  8 8 8
"""
        let canvasValue = Canvas(fromString: ppm)
        if let canvas = canvasValue {
            let pattern = UVImage(canvas: canvas)
            
            let u: [Double] = [0, 0.3, 0.6, 1]
            let v: [Double] = [0, 0, 0.3, 1]
            let colors: [Color] = [Color(r: 0.9, g: 0.9, b: 0.9),
                                   Color(r: 0.2, g: 0.2, b: 0.2),
                                   Color(r: 0.1, g: 0.1, b: 0.1),
                                   Color(r: 0.9, g: 0.9, b: 0.9),]
            
            for index in 0..<u.count {
                XCTAssertEqual(pattern.uvPatternAt(u: u[index], v: v[index]) , colors[index], "Color does not match for index: \(index)")
            }
        }
        
        XCTAssertNotNil(canvasValue)
    }
}
