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
        let b = Vector()
        XCTAssertEqual(b, Vector.zero)
    }
    
    func testDefaultInit() {
        let a = Vector(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        XCTAssert(a.x == 4.3 && a.y == -4.2 && a.z == 3.1 && a.w == 1.0)
    }
    
    func testEquality() {
        let a = Vector(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        let b = Vector(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        XCTAssertEqual(a, b)
    }
    
    func testInequality() {
        let a = Vector(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        let b = Vector()
        XCTAssertNotEqual(a, b)
    }
    
    func testAddition() {
        let a1 = Vector(x: 3, y: -2, z: 5, w: 1)
        let a2 = Vector(x: -2, y: 3, z: 1, w: 0)
        let sum = Vector(x: 1, y: 1, z: 6, w: 1)
        XCTAssertEqual(a1 + a2, sum)
    }
    
    func testSubtraction() {
        let p1 = Vector(x: 3, y: 2, z: 1)
        let p2 = Vector(x: 5, y: 6, z: 7)
        let difference = Vector(x:-2, y: -4, z: -6, w: 0)
        XCTAssertEqual(p1 - p2, difference)
    }
    
    func testMultiplyByScalar() {
        let a = Vector(x: 1, y: -2, z: 3, w: -4)
        let product = Vector(x: 3.5, y: -7, z: 10.5, w: -14)
        XCTAssertEqual(a * 3.5, product)
    }
    
    func testMultiplyByScalarFraction() {
        let a = Vector(x: 1, y: -2, z: 3, w: -4)
        let product = Vector(x: 0.5, y: -1, z: 1.5, w: -2)
        XCTAssertEqual(a * 0.5, product)
    }
    
    func testDivision() {
        let a = Vector(x: 1, y: -2, z: 3, w: -4)
        let quotient = Vector(x: 0.5, y: -1, z: 1.5, w: -2)
        XCTAssertEqual(a / 2, quotient)
    }
    
    func testMagnitude() {
        var a = Vector(x: 1, y: 0, z: 0)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Vector(x: 0, y: 1, z: 0)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Vector(x: 0, y: 0, z: 1)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Vector(x: 1, y: 2, z: 3);
        XCTAssert(Vector.almostEqual(lhs: a.magnitude, rhs: sqrt(14)))
    }
    
    func testNormalization() {
        var v = Vector(x: 4, y: 0, z: 0)
        v.normalize()
        XCTAssertEqual(v, Vector(x: 1, y: 0, z: 0))
        
        v = Vector(x: 1, y: 2, z: 3)
        v.normalize()
        XCTAssert(Vector.almostEqual(lhs: v.x, rhs: 0.26726) &&
            Vector.almostEqual(lhs: v.y, rhs: 0.53452) &&
            Vector.almostEqual(lhs: v.z, rhs: 0.80178) &&
            v.w == 0.0)
        XCTAssertEqual(v.magnitude, 1.0)
    }
    
    func testDotProduct() {
        let a = Vector(x: 1, y: 2, z: 3)
        let b = Vector(x: 2, y: 3, z: 4)
        let dotProduct = a.dot(rhs: b)
        XCTAssertEqual(20.0, dotProduct)
    }
    
    func testCrossProduct() {
        let a = Vector(x: 1, y: 2, z: 3)
        let b = Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(rhs: b), Vector(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(rhs: a), Vector(x: 1, y: -2, z: 1))
    }
}
