//
//  VectorTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class VectorTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testAddition() {
        let a1 = Tuple.Point(x: 3, y: -2, z: 5)
        let a2 = Tuple.Vector(x: -2, y: 3, z: 1)
        let sum = Tuple.Point(x: 1, y: 1, z: 6)
        XCTAssertEqual(a1 + a2, sum)
    }
    
    func testSubtraction() {
        let p1 = Tuple.Vector(x: 3, y: 2, z: 1)
        let p2 = Tuple.Vector(x: 5, y: 6, z: 7)
        let difference = Tuple.Vector(x:-2, y: -4, z: -6)
        XCTAssertEqual(p1 - p2, difference)
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
        XCTAssert(Tuple.almostEqual(lhs: a.magnitude, rhs: sqrt(14)))
    }
    
    func testNormalization() {
        var v = Tuple.Vector(x: 4, y: 0, z: 0)
        v.normalize()
        XCTAssertEqual(v, Tuple.Vector(x: 1, y: 0, z: 0))
        
        v = Tuple.Vector(x: 1, y: 2, z: 3)
        v.normalize()
        XCTAssert(Tuple.almostEqual(lhs: v.x, rhs: 0.26726) &&
            Tuple.almostEqual(lhs: v.y, rhs: 0.53452) &&
            Tuple.almostEqual(lhs: v.z, rhs: 0.80178) &&
            v.w == 0.0)
        XCTAssertEqual(v.magnitude, 1.0)
    }
    
    func testDotProduct() {
        let a = Tuple.Vector(x: 1, y: 2, z: 3)
        let b = Tuple.Vector(x: 2, y: 3, z: 4)
        let dotProduct = a.dot(rhs: b)
        XCTAssertEqual(20.0, dotProduct)
    }
    
    func testCrossProduct() {
        let a = Tuple.Vector(x: 1, y: 2, z: 3)
        let b = Tuple.Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(rhs: b), Tuple.Vector(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(rhs: a), Tuple.Vector(x: 1, y: -2, z: 1))
    }
}
