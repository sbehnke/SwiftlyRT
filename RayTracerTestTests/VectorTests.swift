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
        let b = Vector4()
        XCTAssertEqual(b, Vector4.zero)
    }
    
    func testDefaultInit() {
        let a = Vector4(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        XCTAssert(a.x == 4.3 && a.y == -4.2 && a.z == 3.1 && a.w == 1.0)
    }
    
    func testEquality() {
        let a = Vector4(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        let b = Vector4(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        XCTAssertEqual(a, b)
    }
    
    func testInequality() {
        let a = Vector4(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        let b = Vector4()
        XCTAssertNotEqual(a, b)
    }
    
    func testAddition() {
        let a1 = Vector4(x: 3, y: -2, z: 5, w: 1)
        let a2 = Vector4(x: -2, y: 3, z: 1, w: 0)
        let sum = Vector4(x: 1, y: 1, z: 6, w: 1)
        XCTAssertEqual(a1 + a2, sum)
    }
    
    func testSubtraction() {
        let p1 = Vector4(x: 3, y: 2, z: 1)
        let p2 = Vector4(x: 5, y: 6, z: 7)
        let difference = Vector4(x:-2, y: -4, z: -6, w: 0)
        XCTAssertEqual(p1 - p2, difference)
    }
    
    func testMultiplyByScalar() {
        let a = Vector4(x: 1, y: -2, z: 3, w: -4)
        let product = Vector4(x: 3.5, y: -7, z: 10.5, w: -14)
        XCTAssertEqual(a * 3.5, product)
    }
    
    func testMultiplyByScalarFraction() {
        let a = Vector4(x: 1, y: -2, z: 3, w: -4)
        let product = Vector4(x: 0.5, y: -1, z: 1.5, w: -2)
        XCTAssertEqual(a * 0.5, product)
    }
    
    func testDivision() {
        let a = Vector4(x: 1, y: -2, z: 3, w: -4)
        let quotient = Vector4(x: 0.5, y: -1, z: 1.5, w: -2)
        XCTAssertEqual(a / 2, quotient)
    }
    
    func testMagnitude() {
        var a = Vector4(x: 1, y: 0, z: 0)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Vector4(x: 0, y: 1, z: 0)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Vector4(x: 0, y: 0, z: 1)
        XCTAssertEqual(1.0, a.magnitude);
        
        a = Vector4(x: 1, y: 2, z: 3);
        XCTAssert(Vector4.almostEqual(lhs: a.magnitude, rhs: sqrt(14)))
    }
    
    func testNormalization() {
        var v = Vector4(x: 4, y: 0, z: 0)
        v.normalize()
        XCTAssertEqual(v, Vector4(x: 1, y: 0, z: 0))
        
        v = Vector4(x: 1, y: 2, z: 3)
        v.normalize()
        XCTAssert(Vector4.almostEqual(lhs: v.x, rhs: 0.26726) &&
            Vector4.almostEqual(lhs: v.y, rhs: 0.53452) &&
            Vector4.almostEqual(lhs: v.z, rhs: 0.80178) &&
            v.w == 0.0)
        XCTAssertEqual(v.magnitude, 1.0)
    }
    
    func testDotProduct() {
        let a = Vector4(x: 1, y: 2, z: 3)
        let b = Vector4(x: 2, y: 3, z: 4)
        let dotProduct = a.dot(rhs: b)
        XCTAssertEqual(20.0, dotProduct)
    }
    
    func testCrossProduct() {
        let a = Vector4(x: 1, y: 2, z: 3)
        let b = Vector4(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(rhs: b), Vector4(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(rhs: a), Vector4(x: 1, y: -2, z: 1))
    }
}
