//
//  PatternTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

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
        object.transform = Matrix4x4.scale(x: 2, y: 2, z: 2)
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
        pattern.transform = Matrix4x4.scale(x: 2, y: 2, z: 2)
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
        object.transform = Matrix4x4.scale(x: 2, y: 2, z: 2)
        let pattern = StripePattern(a: Color.white, b: Color.black)
        pattern.transform = Matrix4x4.translate(x: 0.5, y: 0, z: 0)
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
        p.transform = Matrix4x4.translate(x: 1, y: 2, z: 3)
        XCTAssertEqual(p.transform, Matrix4x4.translate(x: 1, y: 2, z: 3))
    }
    
    func testPatternWithObjectTransformation() {
//    Scenario: A pattern with an object transformation
//    Given shape ← sphere()
//    And set_transform(shape, scaling(2, 2, 2))
//    And pattern ← test_pattern()
//    When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
//    Then c = color(1, 1.5, 2)

        let shape = Sphere()
        shape.transform = .scale(x: 2, y: 2, z: 2)
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
        pattern.transform = .scale(x: 2, y: 2, z: 2)
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
        shape.transform = .scale(x: 2, y: 2, z: 2)
        let pattern = TestPattern()
        pattern.transform = Matrix4x4.translate(x: 0.5, y: 1, z: 1.5)
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
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 1.01, z: 0)), Color.black)    }
    
    func testCheckersRepeatingZ() {
//    Scenario: Checkers should repeat in z
//    Given pattern ← checkers_pattern(white, black)
//    Then pattern_at(pattern, point(0, 0, 0)) = white
//    And pattern_at(pattern, point(0, 0, 0.99)) = white
//    And pattern_at(pattern, point(0, 0, 1.01)) = black
        
        let pattern = CheckerPattern(a: Color.white, b: Color.black)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 0.99)), Color.white)
        XCTAssertEqual(pattern.patternAt(point: .Point(x: 0, y: 0, z: 1.01)), Color.black)    }
}
