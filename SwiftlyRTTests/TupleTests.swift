//
//  VectorTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import SwiftlyRT

class TupleTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPoint() {
        //    Scenario: A tuple with w=1.0 is a point
        //    Given a ← tuple(4.3, -4.2, 3.1, 1.0)
        //    Then a.x = 4.3
        //    And a.y = -4.2
        //    And a.z = 3.1
        //    And a.w = 1.0
        //    And a is a point
        //    And a is not a vector
        
        let a = Tuple.Point(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        XCTAssertEqual(a.x, 4.3)
        XCTAssertEqual(a.y, -4.2)
        XCTAssertEqual(a.z, 3.1)
        XCTAssertEqual(a.w, 1.0)
        XCTAssertTrue(a.isPoint())
        XCTAssertFalse(a.isVector())
    }
    
    func testVector() {
        //    Scenario: A tuple with w=0 is a vector
        //    Given a ← tuple(4.3, -4.2, 3.1, 0.0)
        //    Then a.x = 4.3
        //    And a.y = -4.2
        //    And a.z = 3.1
        //    And a.w = 0.0
        //    And a is not a point
        //    And a is a vector
        
        let a = Tuple.Vector(x: 4.3, y: -4.2, z: 3.1, w: 0.0)
        XCTAssertEqual(a.x, 4.3)
        XCTAssertEqual(a.y, -4.2)
        XCTAssertEqual(a.z, 3.1)
        XCTAssertEqual(a.w, 0.0)
        XCTAssertFalse(a.isPoint())
        XCTAssertTrue(a.isVector())
    }
    
    func testAddition() {
//        Scenario: Adding two tuples
//        Given a1 ← tuple(3, -2, 5, 1)
//        And a2 ← tuple(-2, 3, 1, 0)
//        Then a1 + a2 = tuple(1, 1, 6, 1)
        
        let a1 = Tuple.Point(x: 3, y: -2, z: 5)
        let a2 = Tuple.Vector(x: -2, y: 3, z: 1)
        let sum = Tuple.Point(x: 1, y: 1, z: 6)
        XCTAssertEqual(a1 + a2, sum)
    }
    
    func testSubtraction() {
//        Scenario: Subtracting two points
//        Given p1 ← point(3, 2, 1)
//        And p2 ← point(5, 6, 7)
//        Then p1 - p2 = vector(-2, -4, -6)
        
        let p1 = Tuple.Vector(x: 3, y: 2, z: 1)
        let p2 = Tuple.Vector(x: 5, y: 6, z: 7)
        let difference = Tuple.Vector(x:-2, y: -4, z: -6)
        XCTAssertEqual(p1 - p2, difference)
    }
    
    func testPointDefaultConstructor() {
        //    Scenario: point() creates tuples with w=1
        //    Given p ← point(4, -4, 3)
        //    Then p = tuple(4, -4, 3, 1)
        
        let p = Tuple.Point(x: 4, y: -4, z: 3)
        XCTAssertEqual(p.x, 4)
        XCTAssertEqual(p.y, -4)
        XCTAssertEqual(p.z, 3)
        XCTAssertEqual(p.w, 1)
    }
    
    func testVectorDefaultConstructor() {
        //    Scenario: vector() creates tuples with w=0
        //    Given v ← vector(4, -4, 3)
        //    Then v = tuple(4, -4, 3, 0)
        
        let v = Tuple.Vector(x: 4, y: -4, z: 3)
        XCTAssertEqual(v.x, 4)
        XCTAssertEqual(v.y, -4)
        XCTAssertEqual(v.z, 3)
        XCTAssertEqual(v.w, 0)
    }
    
    func testInit() {
        let b = Tuple.Vector()
        XCTAssertEqual(b, Tuple.zero)
    }
    
    func testDefaultInit() {
        let a = Tuple.Point(x: 4.3, y: -4.2, z: 3.1)
        XCTAssert(a.x == 4.3 && a.y == -4.2 && a.z == 3.1 && a.w == 1.0)
    }
    
    func testEquality() {
        let a = Tuple.Point(x: 4.3, y: -4.2, z: 3.1)
        let b = Tuple.Point(x: 4.3, y: -4.2, z: 3.1)
        XCTAssertEqual(a, b)
    }
    
    func testInequality() {
        let a = Tuple.Point(x: 4.3, y: -4.2, z: 3.1)
        let b = Tuple.Point()
        XCTAssertNotEqual(a, b)
    }
    
    
    
    func testMultiplyByScalar() {
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        let product = Tuple.Vector(x: 3.5, y: -7, z: 10.5, w: -14)
        XCTAssertEqual(a * 3.5, product)
    }
    
    func testMultiplyByScalarFraction() {
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        let product = Tuple.Vector(x: 0.5, y: -1, z: 1.5, w: -2)
        XCTAssertEqual(a * 0.5, product)
    }
    
    func testDivision() {
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        let quotient = Tuple.Vector(x: 0.5, y: -1, z: 1.5, w: -2)
        XCTAssertEqual(a / 2, quotient)
    }
    
    func testMagnitude() {
        var a = Tuple.Vector(x: 1, y: 0, z: 0)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Tuple.Vector(x: 0, y: 1, z: 0)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Tuple.Vector(x: 0, y: 0, z: 1)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Tuple.Vector(x: 1, y: 2, z: 3);
        XCTAssertEqual(a.magnitude, sqrt(14), accuracy: Tuple.epsilon)
    }
    
    func testNormalization() {
        var v = Tuple.Vector(x: 4, y: 0, z: 0).normalized()
        XCTAssertEqual(v, Tuple.Vector(x: 1, y: 0, z: 0))
        
        v = Tuple.Vector(x: 1, y: 2, z: 3).normalized()
        XCTAssertEqual(v.x, 0.26726, accuracy: Tuple.epsilon)
        XCTAssertEqual(v.y, 0.53452, accuracy: Tuple.epsilon)
        XCTAssertEqual(v.z, 0.80178, accuracy: Tuple.epsilon)
        XCTAssertEqual(v.w, 0.0)
        XCTAssertEqual(v.magnitude, 1.0)
    }
    
    func testDotProduct() {
        let a = Tuple.Vector(x: 1, y: 2, z: 3)
        let b = Tuple.Vector(x: 2, y: 3, z: 4)
        let dotProduct = a.dot(b)
        XCTAssertEqual(20.0, dotProduct)
    }
    
    func testCrossProduct() {
//        Scenario: The cross product of two vectors
//        Given a ← vector(1, 2, 3)
//        And b ← vector(2, 3, 4)
//        Then cross(a, b) = vector(-1, 2, -1)
//        And cross(b, a) = vector(1, -2, 1)

        let a = Tuple.Vector(x: 1, y: 2, z: 3)
        let b = Tuple.Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(b), Tuple.Vector(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(a), Tuple.Vector(x: 1, y: -2, z: 1))
    }
    
    func testAddTuples() {
        //    Scenario: Adding two tuples
        //    Given a1 ← tuple(3, -2, 5, 1)
        //    And a2 ← tuple(-2, 3, 1, 0)
        //    Then a1 + a2 = tuple(1, 1, 6, 1)
        
        let a1 = Tuple.Point(x: 3, y: -2, z: 5, w: 1)
        let a2 = Tuple.Vector(x: -2, y: 3, z: 1, w: 0)
        let result = Tuple.Point(x: 1, y: 1, z: 6, w: 1)
        XCTAssertEqual(a1 + a2, result)
    }
    
    func testSubtractTuple() {
        //    Scenario: Subtracting two points
        //    Given p1 ← point(3, 2, 1)
        //    And p2 ← point(5, 6, 7)
        //    Then p1 - p2 = vector(-2, -4, -6)
        let p1 = Tuple.Point(x: 3, y: 2, z: 1)
        let p2 = Tuple.Point(x: 5, y: 6, z: 7)
        XCTAssertEqual(p1 - p2, Tuple.Vector(x: -2, y: -4, z: -6))
    }
    
    func testSubtractVectorFromPoint() {
        //    Scenario: Subtracting a vector from a point
        //    Given p ← point(3, 2, 1)
        //    And v ← vector(5, 6, 7)
        //    Then p - v = point(-2, -4, -6)
        
        let p = Tuple.Point(x: 3, y: 2, z: 1)
        let v = Tuple.Vector(x: 5, y: 6, z: 7)
        XCTAssertEqual(p - v, Tuple.Point(x: -2, y: -4, z: -6))
    }
    
    func testSubtractTwoVectors() {
        //    Scenario: Subtracting two vectors
        //    Given v1 ← vector(3, 2, 1)
        //    And v2 ← vector(5, 6, 7)
        //    Then v1 - v2 = vector(-2, -4, -6)
        
        let v1 = Tuple.Vector(x: 3, y: 2, z: 1)
        let v2 = Tuple.Vector(x: 5, y: 6, z: 7)
        XCTAssertEqual(v1 - v2, Tuple.Vector(x: -2, y: -4, z: -6))
    }
    
    func testSubtractVectorFromZeroVector() {
        //    Scenario: Subtracting a vector from the zero vector
        //    Given zero ← vector(0, 0, 0)
        //    And v ← vector(1, -2, 3)
        //    Then zero - v = vector(-1, 2, -3)
        
        let zero = Tuple.zero
        let v = Tuple.Vector(x: 1, y: -2, z: 3)
        XCTAssertEqual(zero - v, Tuple.Vector(x: -1, y: 2, z: -3))
    }
    
    func testNegatingATuple() {
        //    Scenario: Negating a tuple
        //    Given a ← tuple(1, -2, 3, -4)
        //    Then -a = tuple(-1, 2, -3, 4)
        
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(-a,  Tuple.Vector(x: -1, y: 2, z: -3, w: 4))
    }
    
    func testMultiplyTupleByScalar() {
        //    Scenario: Multiplying a tuple by a scalar
        //    Given a ← tuple(1, -2, 3, -4)
        //    Then a * 3.5 = tuple(3.5, -7, 10.5, -14)
        
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a * 3.5, Tuple.Vector(x: 3.5, y: -7, z: 10.5, w: -14))
    }
    
    func testMultiplyTupleByFraction() {
        //    Scenario: Multiplying a tuple by a fraction
        //    Given a ← tuple(1, -2, 3, -4)
        //    Then a * 0.5 = tuple(0.5, -1, 1.5, -2)
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a * 0.5, Tuple.Vector(x: 0.5, y: -1, z: 1.5, w: -2))
    }
    
    func testDividingTupleByScalar() {
        //    Scenario: Dividing a tuple by a scalar
        //    Given a ← tuple(1, -2, 3, -4)
        //    Then a / 2 = tuple(0.5, -1, 1.5, -2)
        let a = Tuple.Vector(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a / 2, Tuple.Vector(x: 0.5, y: -1, z: 1.5, w: -2))
    }
    
    func testVectorMagnitudeX() {
        //    Scenario: Computing the magnitude of vector(1, 0, 0)
        //    Given v ← vector(1, 0, 0)
        //    Then magnitude(v) = 1
        
        let v = Tuple.Vector(x: 1, y: 0, z: 0)
        XCTAssertEqual(1.0, v.magnitude)
    }
    
    func testVectorMagnitudeY() {
        //    Scenario: Computing the magnitude of vector(0, 1, 0)
        //    Given v ← vector(0, 1, 0)
        //    Then magnitude(v) = 1
        
        let v = Tuple.Vector(x: 0, y: 1.0, z: 0)
        XCTAssertEqual(1.0, v.magnitude)
    }
    
    func testVectorMagnitudeZ() {
        //    Scenario: Computing the magnitude of vector(0, 0, 1)
        //    Given v ← vector(0, 0, 1)
        //    Then magnitude(v) = 1
        
        let v = Tuple.Vector(x: 0, y: 0, z: 1.0)
        XCTAssertEqual(1.0, v.magnitude)
    }
    
    func testVectorMagnitudeXYZ() {
        //    Scenario: Computing the magnitude of vector(1, 2, 3)
        //    Given v ← vector(1, 2, 3)
        //    Then magnitude(v) = √14
        let v = Tuple.Vector(x: 1, y: 2, z: 3)
        XCTAssertEqual(sqrt(14), v.magnitude, accuracy: Tuple.epsilon)
    }
    
    func testVectorMagnitudeNegativeXYZ() {
        //    Scenario: Computing the magnitude of vector(-1, -2, -3)
        //    Given v ← vector(-1, -2, -3)
        //    Then magnitude(v) = √14
        
        let v = Tuple.Vector(x: -1, y: -2, z: -3)
        XCTAssertEqual(sqrt(14), v.magnitude, accuracy: Tuple.epsilon)
    }
    
    func testNormalizingVector() {
        //    Scenario: Normalizing vector(4, 0, 0) gives (1, 0, 0)
        //    Given v ← vector(4, 0, 0)
        //    Then normalize(v) = vector(1, 0, 0)
        
        let v = Tuple.Vector(x: 4.0, y: 0, z: 0)
        XCTAssertEqual(v.normalized(), Tuple.Vector(x: 1, y: 0, z: 0))
    }
    
    func testNormalizingVector2() {
        //    Scenario: Normalizing vector(1, 2, 3)
        //    Given v ← vector(1, 2, 3)
        //    # vector(1/√14,   2/√14,   3/√14)
        //    Then normalize(v) = approximately vector(0.26726, 0.53452, 0.80178)
        
        let v = Tuple.Vector(x: 1.0, y: 2.0, z: 3.0)
        let mag = sqrt(14.0)
        XCTAssertEqual(v.normalized(), Tuple.Vector(x: 1.0/mag, y: 2.0/mag, z: 3.0/mag))
    }
    
    func testMagnitudeOfNormalizedVector() {
        //    Scenario: The magnitude of a normalized vector
        //    Given v ← vector(1, 2, 3)
        //    When norm ← normalize(v)
        //    Then magnitude(norm) = 1
        let v = Tuple.Vector(x: 1.0, y: 2.0, z: 3.0).normalized()
        XCTAssertEqual(1.0, v.magnitude)
    }
    
    func testDotProductOfTuples() {
        //    Scenario: The dot product of two tuples
        //    Given a ← vector(1, 2, 3)
        //    And b ← vector(2, 3, 4)
        //    Then dot(a, b) = 20
        
        let a = Tuple.Vector(x: 1, y: 2, z: 3)
        let b = Tuple.Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.dot(b), 20.0)
    }
    
    func testCrossProductOfVectors() {
        //    Scenario: The cross product of two vectors
        //    Given a ← vector(1, 2, 3)
        //    And b ← vector(2, 3, 4)
        //    Then cross(a, b) = vector(-1, 2, -1)
        //    And cross(b, a) = vector(1, -2, 1)
        
        let a = Tuple.Vector(x: 1, y: 2, z: 3)
        let b = Tuple.Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(b), Tuple.Vector(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(a), Tuple.Vector(x: 1, y: -2, z: 1))
    }
    
    func testColorComponents() {
        //    Scenario: Colors are (red, green, blue) tuples
        //    Given c ← color(-0.5, 0.4, 1.7)
        //    Then c.red = -0.5
        //    And c.green = 0.4
        //    And c.blue = 1.7
        
        let c = Color(r: -0.5, g: 0.4, b: 1.7)
        XCTAssertEqual(-0.5, c.r)
        XCTAssertEqual(0.4, c.g)
        XCTAssertEqual(1.7, c.b)
    }
    
    func testAddingColors() {
        //    Scenario: Adding colors
        //    Given c1 ← color(0.9, 0.6, 0.75)
        //    And c2 ← color(0.7, 0.1, 0.25)
        //    Then c1 + c2 = color(1.6, 0.7, 1.0)
        
        let c1 = Color(r: 0.9, g: 0.6, b: 0.75)
        let c2 = Color(r: 0.7, g: 0.1, b: 0.25)
        XCTAssertEqual(c1 + c2, Color(r: 1.6, g: 0.7, b: 1.0))
    }
    
    func testSubtractingColors() {
        //    Scenario: Subtracting colors
        //    Given c1 ← color(0.9, 0.6, 0.75)
        //    And c2 ← color(0.7, 0.1, 0.25)
        //    Then c1 - c2 = color(0.2, 0.5, 0.5)
        let c1 = Color(r: 0.9, g: 0.6, b: 0.75)
        let c2 = Color(r: 0.7, g: 0.1, b: 0.25)
        XCTAssertEqual(c1 - c2, Color(r: 0.2, g: 0.5, b: 0.5))
    }
    
    func testMultiplyColorByScalar() {
        //    Scenario: Multiplying a color by a scalar
        //    Given c ← color(0.2, 0.3, 0.4)
        //    Then c * 2 = color(0.4, 0.6, 0.8)
        let c = Color(r: 0.2, g: 0.3, b: 0.4)
        XCTAssertEqual(c * 2.0, Color(r: 0.4, g: 0.6, b: 0.8))
    }
    
    func testMultiplyColors() {
        //    Scenario: Multiplying colors
        //    Given c1 ← color(1, 0.2, 0.4)
        //    And c2 ← color(0.9, 1, 0.1)
        //    Then c1 * c2 = color(0.9, 0.2, 0.04)
        
        let c1 = Color(r: 1, g: 0.2, b: 0.4)
        let c2 = Color(r: 0.9, g: 1, b: 0.1)
        XCTAssertEqual(c1 * c2, Color(r: 0.9, g: 0.2, b: 0.04))
    }
    
    func testReflectVector() {
        //    Scenario: Reflecting a vector approaching at 45°
        //    Given v ← vector(1, -1, 0)
        //    And n ← vector(0, 1, 0)
        //    When r ← reflect(v, n)
        //    Then r = vector(1, 1, 0)
        

        let v = Tuple.Vector(x: 1, y: -1, z: 0)
        let n = Tuple.Vector(x: 0, y: 1, z: 0)
        let r = v.reflected(normal: n)
        XCTAssertEqual(r, Tuple.Vector(x: 1, y: 1, z: 0))
    }
    
    func testReflectionSlantedSurface() {
        //    Scenario: Reflecting a vector off a slanted surface
        //    Given v ← vector(0, -1, 0)
        //    And n ← vector(√2/2, √2/2, 0)
        //    When r ← reflect(v, n)
        //    Then r = vector(1, 0, 0)

        let v = Tuple.Vector(x: 0, y: -1, z: 0)
        let n = Tuple.Vector(x: sqrt(2.0)/2.0, y: sqrt(2.0)/2.0, z: 0)
        let r = v.reflected(normal: n)
        XCTAssertEqual(r, Tuple.Vector(x: 1, y: 0, z: 0))

    }
}
