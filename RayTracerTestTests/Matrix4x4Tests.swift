//
//  RayTracerTestTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class Matrix4x4Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMatrixEquality() {
        let m1 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4, 
         b0: 5, b1: 6, b2: 7, b3: 8, 
         c0: 9, c1: 10, c2: 11, c3: 12, 
         d0: 13, d1: 14, d2: 15, d3: 16)

        let m2 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4, 
         b0: 5, b1: 6, b2: 7, b3: 8, 
         c0: 9, c1: 10, c2: 11, c3: 12, 
         d0: 13, d1: 14, d2: 15, d3: 16)

        XCTAssertEqual(m1, m2)

        let m2 = Matrix4x4(a0: 2, a1: 3, a2: 4, a3: 5, 
         b0: 6, b1: 7, b2: 8, b3: 9, 
         c0: 8, c1: 7, c2: 6, c3: 5, 
         d0: 4, d1: 3, d2: 2, d3: 1)

        XCTAssertNotEuqal(m1, m3)
    }

    func testMatrixMultiplicate() {
        let m1 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4, 
         b0: 5, b1: 6, b2: 7, b3: 8, 
         c0: 9, c1: 8, c2: 7, c3: 6, 
         d0: 5, d1: 4, d2: 3, d3: 2)

        let m2 = Matrix4x4(a0: -2, a1: 1, a2: 2, a3: 3, 
         b0: 3, b1: 2, b2: 1, b3: -1, 
         c0: 4, c1: 3, c2: 6, c3: 5, 
         d0: 1, d1: 2, d2: 7, d3: 8)

        let product = Matrix4x4(a0: 20, a1: 22, a2: 50, a3: 48, 
         b0: 44, b1: 54, b2: 114, b3: 108, 
         c0: 40, c1: 58, c2: 110, c3: 102, 
         d0: 16, d1: 26, d2: 46, d3: 42)

        XCTAssertEqual(m1 * m2, product)
    }

    func testMatrixIdentiy() {
        let m1 = Matrix4x4(a0: 0 a1: 1, a2: 2, a3: 4, 
         b0: 1, b1: 2, b2: 4, b3: 8, 
         c0: 2, c1: 4, c2: 8, c3: 16, 
         d0: 4, d1: 8, d2: 16, d3: 32)

        let v1 = Vector(x: 1, y: 2, z: 3, w: 4)

        XCTAssertEqual(m1 * v1, v1)
    }
}