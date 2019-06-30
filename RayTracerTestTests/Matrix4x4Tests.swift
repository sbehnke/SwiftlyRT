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

        let m3 = Matrix4x4(a0: 2, a1: 3, a2: 4, a3: 5,
         b0: 6, b1: 7, b2: 8, b3: 9, 
         c0: 8, c1: 7, c2: 6, c3: 5, 
         d0: 4, d1: 3, d2: 2, d3: 1)

        XCTAssertNotEqual(m1, m3)
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
        let m1 = Matrix4x4(a0: 0, a1: 1, a2: 2, a3: 4,
         b0: 1, b1: 2, b2: 4, b3: 8, 
         c0: 2, c1: 4, c2: 8, c3: 16, 
         d0: 4, d1: 8, d2: 16, d3: 32)
        
        XCTAssertEqual(m1 * Matrix4x4.identity, m1)
    }
    
    func testMatrixVectorMultiplication() {
//        cenario: A matrix multiplied by a tuple
//        Given the following matrix A:
//        | 1 | 2 | 3 | 4 |
//        | 2 | 4 | 4 | 2 |
//        | 8 | 6 | 4 | 1 |
//        | 0 | 0 | 0 | 1 |
//        And b â† tuple(1, 2, 3, 1)
//        Then A * b = tuple(18, 24, 33, 1)
        
        let m1 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4,
                           b0: 2, b1: 4, b2: 4, b3: 2,
                           c0: 8, c1: 6, c2: 4, c3: 1,
                           d0: 0, d1: 0, d2: 0, d3: 1)
        
        let v1 = Vector4(x: 1, y: 2, z: 3, w: 1)
        let product = Vector4(x: 18, y: 24, z: 33, w: 1)
        
        XCTAssertEqual(m1 * v1, product)
    }
    
    func testTranspose() {



        //        Scenario: Transposing a matrix
        //        Given the following matrix A:
        //        | 0 | 9 | 3 | 0 |
        //        | 9 | 8 | 0 | 8 |
        //        | 1 | 8 | 5 | 3 |
        //        | 0 | 0 | 5 | 8 |
        let m1 = Matrix4x4(a0: 0, a1: 9, a2: 3, a3: 0,
                           b0: 9, b1: 8, b2: 0, b3: 8,
                           c0: 1, c1: 8, c2: 5, c3: 3,
                           d0: 0, d1: 0, d2: 5, d3: 8)
        
        //        Then transpose(A) is the following matrix:
        //        | 0 | 9 | 1 | 0 |
        //        | 9 | 8 | 8 | 0 |
        //        | 3 | 0 | 5 | 5 |
        //        | 0 | 8 | 3 | 8 |
        let m2 = Matrix4x4(a0: 0, a1: 9, a2: 1, a3: 0,
                           b0: 9, b1: 8, b2: 8, b3: 0,
                           c0: 3, c1: 0, c2: 5, c3: 5,
                           d0: 0, d1: 8, d2: 3, d3: 8)

        let m3 = m1.transpose()
        XCTAssertEqual(m3.transpose(), m1)
        XCTAssertEqual(Matrix4x4.identity.transpose(), Matrix4x4.identity)
        XCTAssertEqual(m3, m2)
    }
    
    func testSubMatrix() {
//        Scenario: A submatrix of a 4x4 matrix is a 3x3 matrix
//        Given the following 4x4 matrix A:
//        | -6 |  1 |  1 |  6 |
//        | -8 |  5 |  8 |  6 |
//        | -1 |  0 |  8 |  2 |
//        | -7 |  1 | -1 |  1 |
        let m1 = Matrix4x4(a0: -6, a1: 1, a2: 1, a3: 6,
                           b0: -8, b1: 5, b2: 8, b3: 6,
                           c0: -1, c1: 0, c2: 8, c3: 2,
                           d0: -7, d1: 1, d2: -1, d3: 1)

        //        Then submatrix(A, 2, 1) is the following 3x3 matrix:
        //        | -6 |  1 | 6 |
        //        | -8 |  8 | 6 |
        //        | -7 | -1 | 1 |
        let subMatrix = Matrix3x3(a0: -6, a1: 1, a2: 6,
                                  b0: -8, b1: 8, b2: 6,
                                  c0: -7, c1: -1, c2: 1)

        let result = m1.subMatrix(row: 2, column: 1)
        XCTAssertEqual(subMatrix, result)
    }
    
    func testDeterminate() {
//        Scenario: Calculating the determinant of a 4x4 matrix
//        Given the following 4x4 matrix A:
//        | -2 | -8 |  3 |  5 |
//        | -3 |  1 |  7 |  3 |
//        |  1 |  2 | -9 |  6 |
//        | -6 |  7 |  7 | -9 |

        let m1 = Matrix4x4(a0: -2, a1: -8, a2: 3, a3: 5,
                           b0: -3, b1: 1, b2: 7, b3: 3,
                           c0: 1, c1: 2, c2: -9, c3: 6,
                           d0: -6, d1: 7, d2: 7, d3: -9)
        
//        Then cofactor(A, 0, 0) = 690
//        And cofactor(A, 0, 1) = 447
//        And cofactor(A, 0, 2) = 210
//        And cofactor(A, 0, 3) = 51
//        And determinant(A) = -4071
        
        XCTAssertEqual(690, m1.cofactor(row: 0, column: 0))
        XCTAssertEqual(447, m1.cofactor(row: 0, column: 1))
        XCTAssertEqual(210, m1.cofactor(row: 0, column: 2))
        XCTAssertEqual(51, m1.cofactor(row: 0, column: 3))
        XCTAssertEqual(-4071, m1.determinate())
    }
    
    func testInvertability() {
//        Scenario: Testing an invertible matrix for invertibility
//            Given the following 4x4 matrix A:
//        |  6 |  4 |  4 |  4 |
//        |  5 |  5 |  7 |  6 |
//        |  4 | -9 |  3 | -7 |
//        |  9 |  1 |  7 | -6 |
//        Then determinant(A) = -2120
//        And A is invertible
        
        let m1 = Matrix4x4(a0: 6, a1: 4, a2: 4, a3: 4,
                           b0: 5, b1: 5, b2: 7, b3: 6,
                           c0: 4, c1: -9, c2: 3, c3: -7,
                           d0: 9, d1: 1, d2: 7, d3: -6)
        
        XCTAssertEqual(-2120, m1.determinate())
        XCTAssertTrue(m1.canInvert())
        
//
//        Scenario: Testing a noninvertible matrix for invertibility
//            Given the following 4x4 matrix A:
//        | -4 |  2 | -2 | -3 |
//        |  9 |  6 |  2 |  6 |
//        |  0 | -5 |  1 | -5 |
//        |  0 |  0 |  0 |  0 |
//        Then determinant(A) = 0
//        And A is not invertible
        
        let m2 = Matrix4x4(a0: -4, a1: 2, a2: -2, a3: -3,
                           b0: 9, b1: 6, b2: 2, b3: 6,
                           c0: 0, c1: -5, c2: 1, c3: -5,
                           d0: 0, d1: 0, d2: 0, d3: 0)
        
        XCTAssertEqual(0, m2.determinate())
        XCTAssertFalse(m2.canInvert())
    }
    
    func testInvert() {
//        Scenario: Calculating the inverse of a matrix
//        Given the following 4x4 matrix A:
//        | -5 |  2 |  6 | -8 |
//        |  1 | -5 |  1 |  8 |
//        |  7 |  7 | -6 | -7 |
//        |  1 | -3 |  7 |  4 |

        let m1 = Matrix4x4(a0: -5, a1: 2, a2: 6, a3: -8,
                           b0: 1, b1: -5, b2: 1, b3: 8,
                           c0: 7, c1: 7, c2: -6, c3: -7,
                           d0: 1, d1: -3, d2: 7, d3: 4)
        
        //        And B â† inverse(A)
        //        Then determinant(A) = 532
        //        And cofactor(A, 2, 3) = -160
        //        And B[3,2] = -160/532
        //        And cofactor(A, 3, 2) = 105
        //        And B[2,3] = 105/532
        
        XCTAssertEqual(532, m1.determinate())

        XCTAssertEqual(116, m1.cofactor(row: 0, column: 0))
        XCTAssertEqual(-430, m1.cofactor(row: 0, column: 1))
        XCTAssertEqual(-42, m1.cofactor(row: 0, column: 2))
        XCTAssertEqual(-278, m1.cofactor(row: 0, column: 3))

        XCTAssertEqual(240, m1.cofactor(row: 1, column: 0))
        XCTAssertEqual(-775, m1.cofactor(row: 1, column: 1))
        XCTAssertEqual(-119, m1.cofactor(row: 1, column: 2))
        XCTAssertEqual(-433, m1.cofactor(row: 1, column: 3))
        
        XCTAssertEqual(128, m1.cofactor(row: 2, column: 0))
        XCTAssertEqual(-236, m1.cofactor(row: 2, column: 1))
        XCTAssertEqual(-28, m1.cofactor(row: 2, column: 2))
        XCTAssertEqual(-160, m1.cofactor(row: 2, column: 3))
        
        XCTAssertEqual(-24, m1.cofactor(row: 3, column: 0))
        XCTAssertEqual(277, m1.cofactor(row: 3, column: 1))
        XCTAssertEqual(105, m1.cofactor(row: 3, column: 2))
        XCTAssertEqual(163, m1.cofactor(row: 3, column: 3))

        let m2 = m1.invert()
        
        let values = [0.21805, 0.45113,  0.24060, -0.04511,
                      -0.80827, -1.45677, -0.44361, 0.52068,
                      -0.07895, -0.22368, -0.05263, 0.19737,
                      -0.52256, -0.81391, -0.30075, 0.30639]
        
        //        And B is the following 4x4 matrix:
        //        |  0.21805 |  0.45113 |  0.24060 | -0.04511 |
        //        | -0.80827 | -1.45677 | -0.44361 |  0.52068 |
        //        | -0.07895 | -0.22368 | -0.05263 |  0.19737 |
        //        | -0.52256 | -0.81391 | -0.30075 |  0.30639 |
        
        for i in 0..<16 {
            XCTAssertTrue(Point.almostEqual(lhs: m2[i], rhs: values[i]))
        }
    }
}
