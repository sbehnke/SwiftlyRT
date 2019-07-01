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
//        And b ← tuple(1, 2, 3, 1)
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
        
        //        And B ← inverse(A)
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
        
        let values = Matrix4x4([0.21805, 0.45113,  0.24060, -0.04511,
                                -0.80827, -1.45677, -0.44361, 0.52068,
                                -0.07895, -0.22368, -0.05263, 0.19737,
                                -0.52256, -0.81391, -0.30075, 0.30639])
        
        //        And B is the following 4x4 matrix:
        //        |  0.21805 |  0.45113 |  0.24060 | -0.04511 |
        //        | -0.80827 | -1.45677 | -0.44361 |  0.52068 |
        //        | -0.07895 | -0.22368 | -0.05263 |  0.19737 |
        //        | -0.52256 | -0.81391 | -0.30075 |  0.30639 |
        XCTAssertEqual(m2, values)
    }
    
    
    func testInverse2() {
//        Scenario: Calculating the inverse of another matrix
//        Given the following 4x4 matrix A:
//        |  8 | -5 |  9 |  2 |
//        |  7 |  5 |  6 |  1 |
//        | -6 |  0 |  9 |  6 |
//        | -3 |  0 | -9 | -4 |
//
        let m1 = Matrix4x4([8, -5,  9,  2,
                            7,  5,  6,  1,
                            -6,  0,  9,  6,
                            -3,  0, -9, -4])

        //Then inverse(A) is the following 4x4 matrix:
        
        let inverse = Matrix4x4([-0.15385, -0.15385, -0.28205, -0.53846,
                                 -0.07692,  0.12308,  0.02564,  0.03077,
                                 0.35897,  0.35897,  0.43590,  0.92308,
                                 -0.69231, -0.69231, -0.76923, -1.92308])
        
        let m2 = m1.invert()
        XCTAssertEqual(m2, inverse)
    }
    
    func testInverse3() {
//        Scenario: Calculating the inverse of a third matrix
//        Given the following 4x4 matrix A:
//        |  9 |  3 |  0 |  9 |
//        | -5 | -2 | -6 | -3 |
//        | -4 |  9 |  6 |  4 |
//        | -7 |  6 |  6 |  2 |
        
        let m1 = Matrix4x4([9,  3,  0,  9,
                            -5, -2, -6, -3,
                            -4,  9,  6,  4,
                            -7,  6,  6,  2])
        
        let m2 = m1.invert()
//        Then inverse(A) is the following 4x4 matrix:
//        | -0.04074 | -0.07778 |  0.14444 | -0.22222 |
//        | -0.07778 |  0.03333 |  0.36667 | -0.33333 |
//        | -0.02901 | -0.14630 | -0.10926 |  0.12963 |
//        |  0.17778 |  0.06667 | -0.26667 |  0.33333 |

        let inverse = Matrix4x4([-0.04074, -0.07778,  0.14444, -0.22222,
                                 -0.07778,  0.03333,  0.36667, -0.33333,
                                 -0.02901, -0.14630, -0.10926,  0.12963,
                                 0.17778,  0.06667, -0.26667,  0.33333])
        
        for i in 0..<16 {
            XCTAssertTrue(Vector4.almostEqual(lhs: m2[i], rhs: inverse[i]))
        }
    }
    
    func testInverseMultliplication() {
//        Scenario: Multiplying a product by its inverse
//        Given the following 4x4 matrix A:
//        |  3 | -9 |  7 |  3 |
//        |  3 | -8 |  2 | -9 |
//        | -4 |  4 |  4 |  1 |
//        | -6 |  5 | -1 |  1 |
        
    
        let a = Matrix4x4([3, -9,  7,  3,
                           3, -8,  2, -9,
                           -4,  4,  4,  1,
                           -6,  5, -1,  1])
        
//        And the following 4x4 matrix B:
//        |  8 |  2 |  2 |  2 |
//        |  3 | -1 |  7 |  0 |
//        |  7 |  0 |  5 |  4 |
//        |  6 | -2 |  0 |  5 |
//        And C ← A * B
//        Then C * inverse(B) = A
        
        let b = Matrix4x4([8,  2, 2, 2,
                           3, -1, 7, 0,
                           7,  0, 5, 4,
                           6, -2, 0, 5])
        
        let bInverse = b.invert()
        let m2 = a * b * bInverse
        
        XCTAssertEqual(m2, a)
    }
    
    func testTranslate() {
//        Scenario: Multiplying by a translation matrix
//        Given transform ← translation(5, -3, 2)
//        And p ← point(-3, 4, 5)
//        Then transform * p = point(2, 1, 7)
        
        let point = Vector4(x: -3, y: 4, z: 5, w: 1.0)
        let transformed = Matrix4x4.translate(x: 5, y: -3, z: 2) * point
        let result = Vector4(x: 2, y: 1, z: 7, w: 1.0)
        XCTAssertEqual(transformed, result)
    }
    
    func testInverseTranslate() {
//        Scenario: Multiplying by the inverse of a translation matrix
//        Given transform ← translation(5, -3, 2)
//        And inv ← inverse(transform)
//        And p ← point(-3, 4, 5)
//        Then inv * p = point(-8, 7, 3)
        let point = Vector4(x: -3, y: 4, z: 5, w: 1.0)
        let translate = Matrix4x4.translate(x: 5, y: -3, z: 2)
        let inverse = translate.invert()
        let translated = inverse * point
        let result = Vector4(x: -8, y: 7, z: 3, w: 1.0)
        XCTAssertEqual(result, translated)
    }
    
    func testVector() {
//        Scenario: Translation does not affect vectors
//        Given transform ← translation(5, -3, 2)
//        And v ← vector(-3, 4, 5)
//        Then transform * v = v

        let vector = Vector4(x: -3, y: 4, z: 5, w: 0)
        let transform = Matrix4x4.translate(x: 5, y: -3, z: 2)
        XCTAssertEqual(transform * vector, vector)
    }
    
    func testScaling() {
//        Scenario: A scaling matrix applied to a point
//        Given transform ← scaling(2, 3, 4)
//        And p ← point(-4, 6, 8)
//        Then transform * p = point(-8, 18, 32)
//
        
        let transform = Matrix4x4.scale(x: 2, y: 3, z: 4)
        let point = Vector4(x: -4, y: 6, z: 8, w: 1.0)
        let transformed = transform * point
        let result = Vector4(x: -8, y: 18, z: 32, w: 1.0)
        
        XCTAssertEqual(result, transformed)
    }
    
    func testScalingVector() {
//        Scenario: A scaling matrix applied to a vector
//        Given transform ← scaling(2, 3, 4)
//        And v ← vector(-4, 6, 8)
//        Then transform * v = vector(-8, 18, 32)
//
        let transform = Matrix4x4.scale(x: 2, y: 3, z: 4)
        let v = Vector4(x: -4, y: 6, z: 8, w: 0)
        let transformed = transform * v
        let result = Vector4(x: -8, y: 18, z: 32, w: 0)
        XCTAssertEqual(result, transformed)
    }
    
    func testInverseScaling() {
//        Scenario: Multiplying by the inverse of a scaling matrix
//        Given transform ← scaling(2, 3, 4)
//        And inv ← inverse(transform)
//        And v ← vector(-4, 6, 8)
//        Then inv * v = vector(-2, 2, 2)
//
        let transform = Matrix4x4.scale(x: 2, y: 3, z: 4)
        let inverse = transform.invert()
        let v = Vector4(x: -4, y: 6, z: 8, w: 0)
        let transformed = inverse * v
        let result = Vector4(x: -2, y: 2, z: 2, w: 0)
        XCTAssertEqual(result, transformed)
    }
    
    func testReflection() {
//        Scenario: Reflection is scaling by a negative value
//        Given transform ← scaling(-1, 1, 1)
//        And p ← point(2, 3, 4)
//        Then transform * p = point(-2, 3, 4)
        let transform = Matrix4x4.scale(x: -1, y: 1, z: 1)
        let point = Vector4(x: 2, y: 3, z: 4, w: 1)
        let transformed = transform * point
        let result = Vector4(x: -2, y: 3, z: 4, w: 1)
        XCTAssertEqual(result, transformed)
    }
    
    func testRotateX() {
//        Scenario: Rotating a point around the x axis
//        Given p ← point(0, 1, 0)
//        And half_quarter ← rotation_x(π / 4)
//        And full_quarter ← rotation_x(π / 2)
//        Then half_quarter * p = point(0, √2/2, √2/2)
//        And full_quarter * p = point(0, 0, 1)
        
        let p = Vector4(x: 0, y: 1, z: 0, w: 1)
        let halfQuarter = Matrix4x4.rotateX(Double.pi / 4)
        let fullQuarter = Matrix4x4.rotateX(Double.pi / 2)
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Vector4(x: 0, y: sqrt2Over2, z: sqrt2Over2, w: 1.0)
        let rotatedFull = Vector4(x: 0, y: 0, z: 1, w: 1.0)
        
        let t1 = halfQuarter * p
        let t2 = fullQuarter * p
        
        XCTAssertEqual(t1, rotatedHalf)
        XCTAssertEqual(t2, rotatedFull)
    }
    
    func testRotateXBackward() {
//        Scenario: The inverse of an x-rotation rotates in the opposite direction
//        Given p ← point(0, 1, 0)
//        And half_quarter ← rotation_x(π / 4)
//        And inv ← inverse(half_quarter)
//        Then inv * p = point(0, √2/2, -√2/2)

        let p = Vector4(x: 0, y: 1, z: 0, w: 1)
        let halfQuarter = Matrix4x4.rotateX(Double.pi / 4).invert()
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Vector4(x: 0, y: sqrt2Over2, z: -sqrt2Over2, w: 1.0)
        
        let t1 = halfQuarter * p
        
        XCTAssertEqual(t1, rotatedHalf)
    }
    
    func testRotateY() {
//        Scenario: Rotating a point around the y axis
//        Given p ← point(0, 0, 1)
//        And half_quarter ← rotation_y(π / 4)
//        And full_quarter ← rotation_y(π / 2)
//        Then half_quarter * p = point(√2/2, 0, √2/2)
//        And full_quarter * p = point(1, 0, 0)
        
        let p = Vector4(x: 0, y: 0, z: 1, w: 1)
        let halfQuarter = Matrix4x4.rotateY(Double.pi / 4)
        let fullQuarter = Matrix4x4.rotateY(Double.pi / 2)
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Vector4(x: sqrt2Over2, y: 0, z: sqrt2Over2, w: 1.0)
        let rotatedFull = Vector4(x: 1, y: 0, z: 0, w: 1.0)
        
        let t1 = halfQuarter * p
        let t2 = fullQuarter * p
        
        XCTAssertEqual(t1, rotatedHalf)
        XCTAssertEqual(t2, rotatedFull)
    }
    
    func testRotateZ() {
//        Scenario: Rotating a point around the z axis
//        Given p ← point(0, 1, 0)
//        And half_quarter ← rotation_z(π / 4)
//        And full_quarter ← rotation_z(π / 2)
//        Then half_quarter * p = point(-√2/2, √2/2, 0)
//        And full_quarter * p = point(-1, 0, 0)
        
        let p = Vector4(x: 0, y: 1, z: 0, w: 1)
        let halfQuarter = Matrix4x4.rotateZ(Double.pi / 4)
        let fullQuarter = Matrix4x4.rotateZ(Double.pi / 2)
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Vector4(x: -sqrt2Over2, y: sqrt2Over2, z: 0, w: 1.0)
        let rotatedFull = Vector4(x: -1, y: 0, z: 0, w: 1.0)
        
        let t1 = halfQuarter * p
        let t2 = fullQuarter * p
        
        XCTAssertEqual(t1, rotatedHalf)
        XCTAssertEqual(t2, rotatedFull)
    }
}
