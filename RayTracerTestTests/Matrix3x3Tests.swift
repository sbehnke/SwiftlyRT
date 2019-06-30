//
//  Matrix3x3Tests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/30/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class Matrix3x3Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubMatrix() {
//        Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix
//        Given the following 3x3 matrix A:
//        |  1 | 5 |  0 |
//        | -3 | 2 |  7 |
//        |  0 | 6 | -3 |
        
        let m1 = Matrix3x3(a0: 1, a1: 5, a2: 0,
                           b0: -3, b1: 2, b2: 7,
                           c0: 0, c1: 6, c2: -3)
        
//        Then submatrix(A, 0, 2) is the following 2x2 matrix:
//        | -3 | 2 |
//        |  0 | 6 |
        
        let submatrix = Matrix2x2(a0: -3, a1: 2,
                                  b0: 0, b1: 6)
        
        let result = m1.subMatrix(row: 0, column: 2)
        XCTAssertEqual(submatrix, result)
    }
    
    func testMinor() {
//        Scenario: Calculating a minor of a 3x3 matrix
//        Given the following 3x3 matrix A:
//        |  3 |  5 |  0 |
//        |  2 | -1 | -7 |
//        |  6 | -1 |  5 |
        let m1 = Matrix3x3(a0: 3, a1: 5, a2: 0,
                           b0: 2, b1: -1, b2: -7,
                           c0: 6, c1: -1, c2: 5)
        
//        And B â† submatrix(A, 1, 0)
//        Then determinant(B) = 25
//        And minor(A, 1, 0) = 25
        
        let minor = m1.minor(row: 1, column: 0)
        XCTAssertEqual(minor, 25.0)
    }
    
    func testCoFactor() {
//        Scenario: Calculating a cofactor of a 3x3 matrix
//        Given the following 3x3 matrix A:
//        |  3 |  5 |  0 |
//        |  2 | -1 | -7 |
//        |  6 | -1 |  5 |

        let m1 = Matrix3x3(a0: 3, a1: 5, a2: 0,
                           b0: 2, b1: -1, b2: -7,
                           c0: 6, c1: -1, c2: 5)

        //        Then minor(A, 0, 0) = -12
        //        And cofactor(A, 0, 0) = -12
        //        And minor(A, 1, 0) = 25
        //        And cofactor(A, 1, 0) = -25
        
        XCTAssertEqual(-12, m1.minor(row: 0, column: 0))
        XCTAssertEqual(-12, m1.cofactor(row: 0, column: 0))
        XCTAssertEqual(25, m1.minor(row: 1, column: 0))
        XCTAssertEqual(-25, m1.cofactor(row: 1, column: 0))
    }
    
    func testDeterminate() {
//        Scenario: Calculating the determinant of a 3x3 matrix
//        Given the following 3x3 matrix A:
//        |  1 |  2 |  6 |
//        | -5 |  8 | -4 |
//        |  2 |  6 |  4 |
        
        let m1 = Matrix3x3(a0: 1, a1: 2, a2: 6,
                           b0: -5, b1: 8, b2: -4,
                           c0: 2, c1: 6, c2: 4)
        
        //        Then cofactor(A, 0, 0) = 56
        //        And cofactor(A, 0, 1) = 12
        //        And cofactor(A, 0, 2) = -46
        //        And determinant(A) = -196
        
        XCTAssertEqual(56, m1.cofactor(row: 0, column: 0))
        XCTAssertEqual(12, m1.cofactor(row: 0, column: 1))
        XCTAssertEqual(-46, m1.cofactor(row: 0, column: 2))
        XCTAssertEqual(-196, m1.determinate())
    }
}
