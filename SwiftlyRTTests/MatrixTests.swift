//
//  MatrixTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
import simd
@testable import SwiftlyRT

class MatrixTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test4x4DeterminateSpeed() {
        measure {
            for _ in 0..<1000 {
                let m1 = Matrix4x4(a0: -2, a1: -8, a2: 3, a3: 5,
                                   b0: -3, b1: 1, b2: 7, b3: 3,
                                   c0: 1, c1: 2, c2: -9, c3: 6,
                                   d0: -6, d1: 7, d2: 7, d3: -9)
                XCTAssertEqual(-4071, m1.determinate())
            }
        }
    }
    
    func test4x4DeterminateSIMDSpeed() {
        measure {
            for _ in 0..<1000 {
                let m1 = matrix_double4x4(vector4(-2.0, -8.0, 3.0,  5.0),
                                          vector4(-3.0,  1.0,  7.0,   3.0),
                                          vector4(1.0,  2.0, -9.0,   6.0),
                                          vector4(-6.0,  7.0,  7.0,  -9.0))
                
                XCTAssertEqual(-4071, simd_determinant(m1))
            }
        }
    }
    
    func testMatrix4x4() {
        //        Scenario: Constructing and inspecting a 4x4 matrix
        //        Given the following 4x4 matrix M:
        //        |  1   |  2   |  3   |  4   |
        //        |  5.5 |  6.5 |  7.5 |  8.5 |
        //        |  9   | 10   | 11   | 12   |
        //        | 13.5 | 14.5 | 15.5 | 16.5 |
        //        Then M[0,0] = 1
        //        And M[0,3] = 4
        //        And M[1,0] = 5.5
        //        And M[1,2] = 7.5
        //        And M[2,2] = 11
        //        And M[3,0] = 13.5
        //        And M[3,2] = 15.5
        
        let values = [ 1  ,  2  ,  3  ,  4  ,
                       5.5,  6.5,  7.5,  8.5,
                       9  , 10  , 11  , 12  ,
                       13.5, 14.5, 15.5, 16.5]
        let M = Matrix4x4(values)
        XCTAssertEqual(M[0, 0], 1)
        XCTAssertEqual(M[0, 3], 4)
        XCTAssertEqual(M[1, 0], 5.5)
        XCTAssertEqual(M[1, 2], 7.5)
        XCTAssertEqual(M[2, 2], 11)
        XCTAssertEqual(M[3, 0], 13.5)
        XCTAssertEqual(M[3, 2], 15.5)
    }
    
    func testMatrix2x2() {
        //        Scenario: A 2x2 matrix ought to be representable
        //        Given the following 2x2 matrix M:
        //        | -3 |  5 |
        //        |  1 | -2 |
        //        Then M[0,0] = -3
        //        And M[0,1] = 5
        //        And M[1,0] = 1
        //        And M[1,1] = -2
        
        let M = Matrix2x2(a0: -3, a1: 5,
                          b0: 1, b1: -2)
        XCTAssertEqual(-3, M[0, 0])
        XCTAssertEqual(5, M[0, 1])
        XCTAssertEqual(1, M[1, 0])
        XCTAssertEqual(-2, M[1, 1])
    }
    
    func testMatrix3x3() {
        //        Scenario: A 3x3 matrix ought to be representable
        //        Given the following 3x3 matrix M:
        //        | -3 |  5 |  0 |
        //        |  1 | -2 | -7 |
        //        |  0 |  1 |  1 |
        //        Then M[0,0] = -3
        //        And M[1,1] = -2
        //        And M[2,2] = 1
        
        let values = [-3.0,  5.0,  0.0,
                      1.0, -2.0, -7.0,
                      0.0,  1.0,  1.0]
        
        let M = Matrix3x3(values)
        XCTAssertEqual(M[0,0], -3)
        XCTAssertEqual(M[1,1], -2)
        XCTAssertEqual(M[2,2], 1)
    }
    
    func testMatrixEquality() {
        //        Scenario: Matrix equality with identical matrices
        //        Given the following matrix A:
        //        | 1 | 2 | 3 | 4 |
        //        | 5 | 6 | 7 | 8 |
        //        | 9 | 8 | 7 | 6 |
        //        | 5 | 4 | 3 | 2 |
        //        And the following matrix B:
        //        | 1 | 2 | 3 | 4 |
        //        | 5 | 6 | 7 | 8 |
        //        | 9 | 8 | 7 | 6 |
        //        | 5 | 4 | 3 | 2 |
        //        Then A = B
        //
        let m1 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4,
                           b0: 5, b1: 6, b2: 7, b3: 8,
                           c0: 9, c1: 10, c2: 11, c3: 12,
                           d0: 13, d1: 14, d2: 15, d3: 16)
        
        let m2 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4,
                           b0: 5, b1: 6, b2: 7, b3: 8,
                           c0: 9, c1: 10, c2: 11, c3: 12,
                           d0: 13, d1: 14, d2: 15, d3: 16)
        
        XCTAssertEqual(m1, m2)
    }
    
    func testMatrixInequality() {
        //        Scenario: Matrix equality with different matrices
        //        Given the following matrix A:
        //        | 1 | 2 | 3 | 4 |
        //        | 5 | 6 | 7 | 8 |
        //        | 9 | 8 | 7 | 6 |
        //        | 5 | 4 | 3 | 2 |
        //        And the following matrix B:
        //        | 2 | 3 | 4 | 5 |
        //        | 6 | 7 | 8 | 9 |
        //        | 8 | 7 | 6 | 5 |
        //        | 4 | 3 | 2 | 1 |
        //        Then A != B
        
        let m1 = Matrix4x4(a0: 1, a1: 2, a2: 3, a3: 4,
                           b0: 5, b1: 6, b2: 7, b3: 8,
                           c0: 9, c1: 10, c2: 11, c3: 12,
                           d0: 13, d1: 14, d2: 15, d3: 16)
        
        let m3 = Matrix4x4(a0: 2, a1: 3, a2: 4, a3: 5,
                           b0: 6, b1: 7, b2: 8, b3: 9,
                           c0: 8, c1: 7, c2: 6, c3: 5,
                           d0: 4, d1: 3, d2: 2, d3: 1)
        
        XCTAssertNotEqual(m1, m3)
    }
    
    func testMatrixMultiplicate() {
        //        Scenario: Multiplying two matrices
        //        Given the following matrix A:
        //        | 1 | 2 | 3 | 4 |
        //        | 5 | 6 | 7 | 8 |
        //        | 9 | 8 | 7 | 6 |
        //        | 5 | 4 | 3 | 2 |
        //        And the following matrix B:
        //        | -2 | 1 | 2 |  3 |
        //        |  3 | 2 | 1 | -1 |
        //        |  4 | 3 | 6 |  5 |
        //        |  1 | 2 | 7 |  8 |
        //        Then A * B is the following 4x4 matrix:
        //        | 20|  22 |  50 |  48 |
        //        | 44|  54 | 114 | 108 |
        //        | 40|  58 | 110 | 102 |
        //        | 16|  26 |  46 |  42 |
        //
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
        
        let v1 = Tuple.Point(x: 1, y: 2, z: 3)
        let product = Tuple.Point(x: 18, y: 24, z: 33)
        
        XCTAssertEqual(m1 * v1, product)
    }
    
    func testMatrixIdentiy() {
        //        Scenario: Multiplying a matrix by the identity matrix
        //        Given the following matrix A:
        //        | 0 | 1 |  2 |  4 |
        //        | 1 | 2 |  4 |  8 |
        //        | 2 | 4 |  8 | 16 |
        //        | 4 | 8 | 16 | 32 |
        //        Then A * identity_matrix = A
        
        let m1 = Matrix4x4(a0: 0, a1: 1, a2: 2, a3: 4,
                           b0: 1, b1: 2, b2: 4, b3: 8,
                           c0: 2, c1: 4, c2: 8, c3: 16,
                           d0: 4, d1: 8, d2: 16, d3: 32)
        
        XCTAssertEqual(m1 * Matrix4x4.identity, m1)
    }
    
    func testMatrixIdentiyMultipliedByTuple() {
        //        Scenario: Multiplying the identity matrix by a tuple
        //        Given a ← tuple(1, 2, 3, 4)
        //        Then identity_matrix * a = a
        
        let a = Tuple.Vector(x: 1, y: 2, z: 3, w: 4)
        XCTAssertEqual(Matrix4x4.identity * a, a)
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
        
        let m3 = m1.transposed()
        XCTAssertEqual(m3.transposed(), m1)
        XCTAssertEqual(Matrix4x4.identity.transposed(), Matrix4x4.identity)
        XCTAssertEqual(m3, m2)
    }
    
    func testIdentityTranspose() {
        //        Scenario: Transposing the identity matrix
        //        Given A ← transpose(identity_matrix)
        //        Then A = identity_matrix
        
        let A = Matrix4x4.identity.transposed()
        XCTAssertEqual(A, Matrix4x4.identity)
    }
    
    func test2x2Determinate() {
        //        Scenario: Calculating the determinant of a 2x2 matrix
        //        Given the following 2x2 matrix A:
        //        |  1 | 5 |
        //        | -3 | 2 |
        //        Then determinant(A) = 17
        
        let m1 = Matrix2x2(a0: 1, a1: 5,
                           b0: -3, b1: 2)
        
        let determinate = m1.determinate()
        XCTAssertEqual(determinate, 17)
    }
    
    func test3x3SubMatrix() {
        //        Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix
        //        Given the following 3x3 matrix A:
        //        |  1 | 5 |  0 |
        //        | -3 | 2 |  7 |
        //        |  0 | 6 | -3 |
        //        Then submatrix(A, 0, 2) is the following 2x2 matrix:
        //        | -3 | 2 |
        //        |  0 | 6 |
        
        let m1 = Matrix3x3(a0: 1, a1: 5, a2: 0,
                           b0: -3, b1: 2, b2: 7,
                           c0: 0, c1: 6, c2: -3)
        
        let submatrix = Matrix2x2(a0: -3, a1: 2,
                                  b0: 0, b1: 6)
        
        let result = m1.subMatrix(row: 0, column: 2)
        XCTAssertEqual(submatrix, result)
    }
    
    func test4x4SubMatrix() {
        //        Scenario: A submatrix of a 4x4 matrix is a 3x3 matrix
        //        Given the following 4x4 matrix A:
        //        | -6 |  1 |  1 |  6 |
        //        | -8 |  5 |  8 |  6 |
        //        | -1 |  0 |  8 |  2 |
        //        | -7 |  1 | -1 |  1 |
        //        Then submatrix(A, 2, 1) is the following 3x3 matrix:
        //        | -6 |  1 | 6 |
        //        | -8 |  8 | 6 |
        //        | -7 | -1 | 1 |
        
        let m1 = Matrix4x4(a0: -6, a1: 1, a2: 1, a3: 6,
                           b0: -8, b1: 5, b2: 8, b3: 6,
                           c0: -1, c1: 0, c2: 8, c3: 2,
                           d0: -7, d1: 1, d2: -1, d3: 1)
        
        let subMatrix = Matrix3x3(a0: -6, a1: 1, a2: 6,
                                  b0: -8, b1: 8, b2: 6,
                                  c0: -7, c1: -1, c2: 1)
        
        let result = m1.subMatrix(row: 2, column: 1)
        XCTAssertEqual(subMatrix, result)
    }
    
    
    func test3x3Minor() {
        //        Scenario: Calculating a minor of a 3x3 matrix
        //        Given the following 3x3 matrix A:
        //        |  3 |  5 |  0 |
        //        |  2 | -1 | -7 |
        //        |  6 | -1 |  5 |
        //        And B ← submatrix(A, 1, 0)
        //        Then determinant(B) = 25
        //        And minor(A, 1, 0) = 25
        
        let m1 = Matrix3x3(a0: 3, a1: 5, a2: 0,
                           b0: 2, b1: -1, b2: -7,
                           c0: 6, c1: -1, c2: 5)
        
        let minor = m1.minor(row: 1, column: 0)
        XCTAssertEqual(minor, 25.0)
    }
    
    func test3x3CoFactor() {
        //        Scenario: Calculating a cofactor of a 3x3 matrix
        //        Given the following 3x3 matrix A:
        //        |  3 |  5 |  0 |
        //        |  2 | -1 | -7 |
        //        |  6 | -1 |  5 |
        //        Then minor(A, 0, 0) = -12
        //        And cofactor(A, 0, 0) = -12
        //        And minor(A, 1, 0) = 25
        //        And cofactor(A, 1, 0) = -25
        
        let m1 = Matrix3x3(a0: 3, a1: 5, a2: 0,
                           b0: 2, b1: -1, b2: -7,
                           c0: 6, c1: -1, c2: 5)
        
        XCTAssertEqual(-12, m1.minor(row: 0, column: 0))
        XCTAssertEqual(-12, m1.cofactor(row: 0, column: 0))
        XCTAssertEqual(25, m1.minor(row: 1, column: 0))
        XCTAssertEqual(-25, m1.cofactor(row: 1, column: 0))
    }
    
    func test3x3Determinate() {
        //        Scenario: Calculating the determinant of a 3x3 matrix
        //        Given the following 3x3 matrix A:
        //        |  1 |  2 |  6 |
        //        | -5 |  8 | -4 |
        //        |  2 |  6 |  4 |
        //        Then cofactor(A, 0, 0) = 56
        //        And cofactor(A, 0, 1) = 12
        //        And cofactor(A, 0, 2) = -46
        //        And determinant(A) = -196
        
        let m1 = Matrix3x3(a0: 1, a1: 2, a2: 6,
                           b0: -5, b1: 8, b2: -4,
                           c0: 2, c1: 6, c2: 4)
        
        XCTAssertEqual(56, m1.cofactor(row: 0, column: 0))
        XCTAssertEqual(12, m1.cofactor(row: 0, column: 1))
        XCTAssertEqual(-46, m1.cofactor(row: 0, column: 2))
        XCTAssertEqual(-196, m1.determinate())
    }
    
    func test4x4Determinate() {
        //        Scenario: Calculating the determinant of a 4x4 matrix
        //        Given the following 4x4 matrix A:
        //        | -2 | -8 |  3 |  5 |
        //        | -3 |  1 |  7 |  3 |
        //        |  1 |  2 | -9 |  6 |
        //        | -6 |  7 |  7 | -9 |
        //        Then cofactor(A, 0, 0) = 690
        //        And cofactor(A, 0, 1) = 447
        //        And cofactor(A, 0, 2) = 210
        //        And cofactor(A, 0, 3) = 51
        //        And determinant(A) = -4071
        
        let m1 = Matrix4x4(a0: -2, a1: -8, a2: 3, a3: 5,
                           b0: -3, b1: 1, b2: 7, b3: 3,
                           c0: 1, c1: 2, c2: -9, c3: 6,
                           d0: -6, d1: 7, d2: 7, d3: -9)
        
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
    }
    
    func testNonInvertability() {
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
        //        And B ← inverse(A)
        //        Then determinant(A) = 532
        //        And cofactor(A, 2, 3) = -160
        //        And B[3,2] = -160/532
        //        And cofactor(A, 3, 2) = 105
        //        And B[2,3] = 105/532
        //        And B is the following 4x4 matrix:
        //        |  0.21805 |  0.45113 |  0.24060 | -0.04511 |
        //        | -0.80827 | -1.45677 | -0.44361 |  0.52068 |
        //        | -0.07895 | -0.22368 | -0.05263 |  0.19737 |
        //        | -0.52256 | -0.81391 | -0.30075 |  0.30639 |
        
        let m1 = Matrix4x4(a0: -5, a1: 2, a2: 6, a3: -8,
                           b0: 1, b1: -5, b2: 1, b3: 8,
                           c0: 7, c1: 7, c2: -6, c3: -7,
                           d0: 1, d1: -3, d2: 7, d3: 4)
        
        
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
        
        let m2 = m1.inversed()
        
        let values = Matrix4x4([0.21805, 0.45113,  0.24060, -0.04511,
                                -0.80827, -1.45677, -0.44361, 0.52068,
                                -0.07895, -0.22368, -0.05263, 0.19737,
                                -0.52256, -0.81391, -0.30075, 0.30639])
        
        XCTAssertEqual(m2, values)
    }
    
    
    func testInverse2() {
        //        Scenario: Calculating the inverse of another matrix
        //        Given the following 4x4 matrix A:
        //        |  8 | -5 |  9 |  2 |
        //        |  7 |  5 |  6 |  1 |
        //        | -6 |  0 |  9 |  6 |
        //        | -3 |  0 | -9 | -4 |
        //        Then inverse(A) is the following 4x4 matrix:
        //        | -0.15385 | -0.15385 | -0.28205 | -0.53846 |
        //        | -0.07692 |  0.12308 |  0.02564 |  0.03077 |
        //        |  0.35897 |  0.35897 |  0.43590 |  0.92308 |
        //        | -0.69231 | -0.69231 | -0.76923 | -1.92308 |
        
        let m1 = Matrix4x4([8, -5,  9,  2,
                            7,  5,  6,  1,
                            -6,  0,  9,  6,
                            -3,  0, -9, -4])
        
        let inverse = Matrix4x4([-0.15385, -0.15385, -0.28205, -0.53846,
                                 -0.07692,  0.12308,  0.02564,  0.03077,
                                 0.35897,  0.35897,  0.43590,  0.92308,
                                 -0.69231, -0.69231, -0.76923, -1.92308])
        
        let m2 = m1.inversed()
        XCTAssertEqual(m2, inverse)
    }
    
    func testInverse3() {
        //        Scenario: Calculating the inverse of a third matrix
        //        Given the following 4x4 matrix A:
        //        |  9 |  3 |  0 |  9 |
        //        | -5 | -2 | -6 | -3 |
        //        | -4 |  9 |  6 |  4 |
        //        | -7 |  6 |  6 |  2 |
        //        Then inverse(A) is the following 4x4 matrix:
        //        | -0.04074 | -0.07778 |  0.14444 | -0.22222 |
        //        | -0.07778 |  0.03333 |  0.36667 | -0.33333 |
        //        | -0.02901 | -0.14630 | -0.10926 |  0.12963 |
        //        |  0.17778 |  0.06667 | -0.26667 |  0.33333 |
        
        let m1 = Matrix4x4([9,  3,  0,  9,
                            -5, -2, -6, -3,
                            -4,  9,  6,  4,
                            -7,  6,  6,  2])
        
        let m2 = m1.inversed()
        let inverse = Matrix4x4([-0.04074, -0.07778,  0.14444, -0.22222,
                                 -0.07778,  0.03333,  0.36667, -0.33333,
                                 -0.02901, -0.14630, -0.10926,  0.12963,
                                 0.17778,  0.06667, -0.26667,  0.33333])
        
        for i in 0..<16 {
            XCTAssertEqual(m2[i], inverse[i], accuracy: Tuple.epsilon)
        }
    }
    
    func testInverseMultliplication() {
        //        Scenario: Multiplying a product by its inverse
        //        Given the following 4x4 matrix A:
        //        |  3 | -9 |  7 |  3 |
        //        |  3 | -8 |  2 | -9 |
        //        | -4 |  4 |  4 |  1 |
        //        | -6 |  5 | -1 |  1 |
        //        And the following 4x4 matrix B:
        //        |  8 |  2 |  2 |  2 |
        //        |  3 | -1 |  7 |  0 |
        //        |  7 |  0 |  5 |  4 |
        //        |  6 | -2 |  0 |  5 |
        //        And C ← A * B
        //        Then C * inverse(B) = A
        
        
        let a = Matrix4x4([3, -9,  7,  3,
                           3, -8,  2, -9,
                           -4,  4,  4,  1,
                           -6,  5, -1,  1])
        
        let b = Matrix4x4([8,  2, 2, 2,
                           3, -1, 7, 0,
                           7,  0, 5, 4,
                           6, -2, 0, 5])
        
        let bInverse = b.inversed()
        let m2 = a * b * bInverse
        
        XCTAssertEqual(m2, a)
    }
}
