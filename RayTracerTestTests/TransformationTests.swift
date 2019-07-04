//
//  TransformationTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class TransformationTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTranslate() {
        //        Scenario: Multiplying by a translation matrix
        //        Given transform ← translation(5, -3, 2)
        //        And p ← point(-3, 4, 5)
        //        Then transform * p = point(2, 1, 7)
        
        let point = Tuple.Point(x: -3, y: 4, z: 5)
        let transformed = Matrix4x4.translate(x: 5, y: -3, z: 2) * point
        let result = Tuple.Point(x: 2, y: 1, z: 7)
        XCTAssertEqual(transformed, result)
    }
    
    func testInverseTranslate() {
        //        Scenario: Multiplying by the inverse of a translation matrix
        //        Given transform ← translation(5, -3, 2)
        //        And inv ← inverse(transform)
        //        And p ← point(-3, 4, 5)
        //        Then inv * p = point(-8, 7, 3)
        let point = Tuple.Point(x: -3, y: 4, z: 5)
        let translate = Matrix4x4.translate(x: 5, y: -3, z: 2)
        let inverse = translate.invert()
        let translated = inverse * point
        let result = Tuple.Point(x: -8, y: 7, z: 3)
        XCTAssertEqual(result, translated)
    }
    
    func testVector() {
        //        Scenario: Translation does not affect vectors
        //        Given transform ← translation(5, -3, 2)
        //        And v ← vector(-3, 4, 5)
        //        Then transform * v = v
        
        let vector = Tuple.Vector(x: -3, y: 4, z: 5)
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
        let point = Tuple.Point(x: -4, y: 6, z: 8)
        let transformed = transform * point
        let result = Tuple.Point(x: -8, y: 18, z: 32)
        
        XCTAssertEqual(result, transformed)
    }
    
    func testScalingVector() {
        //        Scenario: A scaling matrix applied to a vector
        //        Given transform ← scaling(2, 3, 4)
        //        And v ← vector(-4, 6, 8)
        //        Then transform * v = vector(-8, 18, 32)
        //
        let transform = Matrix4x4.scale(x: 2, y: 3, z: 4)
        let v = Tuple.Vector(x: -4, y: 6, z: 8)
        let transformed = transform * v
        let result = Tuple.Vector(x: -8, y: 18, z: 32)
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
        let v = Tuple.Vector(x: -4, y: 6, z: 8)
        let transformed = inverse * v
        let result = Tuple.Vector(x: -2, y: 2, z: 2)
        XCTAssertEqual(result, transformed)
    }
    
    func testReflection() {
        //        Scenario: Reflection is scaling by a negative value
        //        Given transform ← scaling(-1, 1, 1)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(-2, 3, 4)
        let transform = Matrix4x4.scale(x: -1, y: 1, z: 1)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = transform * point
        let result = Tuple.Point(x: -2, y: 3, z: 4)
        XCTAssertEqual(result, transformed)
    }
    
    func testRotateX() {
        //        Scenario: Rotating a point around the x axis
        //        Given p ← point(0, 1, 0)
        //        And half_quarter ← rotation_x(π / 4)
        //        And full_quarter ← rotation_x(π / 2)
        //        Then half_quarter * p = point(0, √2/2, √2/2)
        //        And full_quarter * p = point(0, 0, 1)
        
        let p = Tuple.Point(x: 0, y: 1, z: 0)
        let halfQuarter = Matrix4x4.rotateX(Double.pi / 4)
        let fullQuarter = Matrix4x4.rotateX(Double.pi / 2)
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Tuple.Point(x: 0, y: sqrt2Over2, z: sqrt2Over2)
        let rotatedFull = Tuple.Point(x: 0, y: 0, z: 1)
        
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
        
        let p = Tuple.Point(x: 0, y: 1, z: 0)
        let halfQuarter = Matrix4x4.rotateX(Double.pi / 4).invert()
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Tuple.Point(x: 0, y: sqrt2Over2, z: -sqrt2Over2)
        
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
        
        let p = Tuple.Point(x: 0, y: 0, z: 1)
        let halfQuarter = Matrix4x4.rotateY(Double.pi / 4)
        let fullQuarter = Matrix4x4.rotateY(Double.pi / 2)
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Tuple.Point(x: sqrt2Over2, y: 0, z: sqrt2Over2)
        let rotatedFull = Tuple.Point(x: 1, y: 0, z: 0)
        
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
        
        let p = Tuple.Point(x: 0, y: 1, z: 0, w: 1)
        let halfQuarter = Matrix4x4.rotateZ(Double.pi / 4)
        let fullQuarter = Matrix4x4.rotateZ(Double.pi / 2)
        
        let sqrt2Over2 = sqrt(2) / 2.0
        let rotatedHalf = Tuple.Point(x: -sqrt2Over2, y: sqrt2Over2, z: 0)
        let rotatedFull = Tuple.Point(x: -1, y: 0, z: 0)
        
        let t1 = halfQuarter * p
        let t2 = fullQuarter * p
        
        XCTAssertEqual(t1, rotatedHalf)
        XCTAssertEqual(t2, rotatedFull)
    }
    
    func testShearingXY() {
        //        Scenario: A shearing transformation moves x in proportion to y
        //        Given transform ← shearing(1, 0, 0, 0, 0, 0)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(5, 3, 4)
        
        let transform = Matrix4x4.shear(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = Tuple.Point(x: 5, y: 3, z: 4)
        let result = transform * point
        XCTAssertEqual(result, transformed)
    }
    
    func testShearingXZ() {
        //        Scenario: A shearing transformation moves x in proportion to z
        //        Given transform ← shearing(0, 1, 0, 0, 0, 0)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(6, 3, 4)
        
        let transform = Matrix4x4.shear(xy: 0, xz: 1, yx: 0, yz: 0, zx: 0, zy: 0)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = Tuple.Point(x: 6, y: 3, z: 4)
        let result = transform * point
        XCTAssertEqual(result, transformed)
    }
    
    func testShearingYX() {
        //        Scenario: A shearing transformation moves y in proportion to x
        //        Given transform ← shearing(0, 0, 1, 0, 0, 0)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(2, 5, 4)
        
        let transform = Matrix4x4.shear(xy: 0, xz: 0, yx: 1, yz: 0, zx: 0, zy: 0)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = Tuple.Point(x: 2, y: 5, z: 4)
        let result = transform * point
        XCTAssertEqual(result, transformed)
    }
    
    func testShearingYZ() {
        //        Scenario: A shearing transformation moves y in proportion to z
        //        Given transform ← shearing(0, 0, 0, 1, 0, 0)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(2, 7, 4)
        
        let transform = Matrix4x4.shear(xy: 0, xz: 0, yx: 0, yz: 1, zx: 0, zy: 0)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = Tuple.Point(x: 2, y: 7, z: 4)
        let result = transform * point
        XCTAssertEqual(result, transformed)
    }
    
    func testShearingZX() {
        //        Scenario: A shearing transformation moves z in proportion to x
        //        Given transform ← shearing(0, 0, 0, 0, 1, 0)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(2, 3, 6)
        
        let transform = Matrix4x4.shear(xy: 0, xz: 0, yx: 0, yz: 0, zx: 1, zy: 0)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = Tuple.Point(x: 2, y: 3, z: 6)
        let result = transform * point
        XCTAssertEqual(result, transformed)
    }
    
    func testShearingZY() {
        //        Scenario: A shearing transformation moves z in proportion to y
        //        Given transform ← shearing(0, 0, 0, 0, 0, 1)
        //        And p ← point(2, 3, 4)
        //        Then transform * p = point(2, 3, 7)
        
        let transform = Matrix4x4.shear(xy: 0, xz: 0, yx: 0, yz: 0, zx: 0, zy: 1)
        let point = Tuple.Point(x: 2, y: 3, z: 4)
        let transformed = Tuple.Point(x: 2, y: 3, z: 7)
        let result = transform * point
        XCTAssertEqual(result, transformed)
    }
    
    func testMultipleTransformsInSequence() {
        //        Scenario: Individual transformations are applied in sequence
        //        Given p ← point(1, 0, 1)
        let p = Tuple.Point(x: 1, y: 0, z: 1)
        //        And A ← rotation_x(π / 2)
        let A = Matrix4x4.rotateX(Double.pi / 2)
        //        And B ← scaling(5, 5, 5)
        let B = Matrix4x4.scale(x: 5, y: 5, z: 5)
        //        And C ← translation(10, 5, 7)
        let C = Matrix4x4.translate(x: 10, y: 5, z: 7)
        //        # apply rotation first
        //        When p2 ← A * p
        let p2 = A * p
        //        Then p2 = point(1, -1, 0)
        XCTAssertEqual(p2, Tuple.Point(x: 1, y: -1, z: 0))
        //        # then apply scaling
        //        When p3 ← B * p2
        let p3 = B * p2
        //        Then p3 = point(5, -5, 0)
        XCTAssertEqual(p3, Tuple.Point(x: 5, y: -5, z: 0))
        //        # then apply translation
        //        When p4 ← C * p3
        let p4 = C * p3
        //        Then p4 = point(15, 0, 7)
        XCTAssertEqual(p4, Tuple.Point(x: 15, y: 0, z: 7))
    }
    
    func testChainedTransforms() {
        //        Scenario: Chained transformations must be applied in reverse order
        //        Given p ← point(1, 0, 1)
        let p = Tuple.Point(x: 1, y: 0, z: 1)
        //        And A ← rotation_x(π / 2)
        let A = Matrix4x4.rotateX(Double.pi / 2)
        //        And B ← scaling(5, 5, 5)
        let B = Matrix4x4.scale(x: 5, y: 5, z: 5)
        //        And C ← translation(10, 5, 7)
        let C = Matrix4x4.translate(x: 10, y: 5, z: 7)
        //        When T ← C * B * A
        let T = C * B * A
        //        Then T * p = point(15, 0, 7)
        let p2 = T * p
        
        XCTAssertEqual(p2, Tuple.Point(x: 15, y: 0, z: 7))
        
        XCTAssertEqual(Matrix4x4.identity.rotateX(Double.pi / 2), A)
        XCTAssertEqual(Matrix4x4.identity.scale(x: 5, y: 5, z: 5), B)
        XCTAssertEqual(Matrix4x4.identity.translate(x: 10, y: 5, z: 7), C)
        
        let T2 = Matrix4x4.identity.rotateX(Double.pi / 2).scale(x: 5, y: 5, z: 5)
        XCTAssertEqual(T2, B * A)
        
        let transform = Matrix4x4.identity.rotateX(Double.pi / 2).scale(x: 5, y: 5, z: 5).translate(x: 10, y: 5, z: 7)
        XCTAssertEqual(T, transform)
    }
    
    func testDefaultOrientationTransform() {
        //        Scenario: The transformation matrix for the default orientation
        //        Given from ← point(0, 0, 0)
        //        And to ← point(0, 0, -1)
        //        And up ← vector(0, 1, 0)
        //        When t ← view_transform(from, to, up)
        //        Then t = identity_matrix

        let from = Tuple.Point(x: 0, y: 0, z: 0)
        let to = Tuple.Point(x: 0, y: 0, z: -1)
        let up = Tuple.Vector(x: 0, y: 1, z: 0)
        let t = Matrix4x4.viewTransform(from: from, to: to, up: up)
        XCTAssertEqual(t, Matrix4x4.identity)
    }
    
    func testTransformLookingPositiveZ() {
        //        Scenario: A view transformation matrix looking in positive z direction
        //        Given from ← point(0, 0, 0)
        //        And to ← point(0, 0, 1)
        //        And up ← vector(0, 1, 0)
        //        When t ← view_transform(from, to, up)
        //        Then t = scaling(-1, 1, -1)

        let from = Tuple.Point(x: 0, y: 0, z: 0)
        let to = Tuple.Point(x: 0, y: 0, z: 1)
        let up = Tuple.Vector(x: 0, y: 1, z: 0)
        let t = Matrix4x4.viewTransform(from: from, to: to, up: up)
        XCTAssertEqual(t, Matrix4x4.scale(x: -1, y: 1, z: -1))
    }
    
    func testViewTransformMovesWorld() {
        //        Scenario: The view transformation moves the world
        //        Given from ← point(0, 0, 8)
        //        And to ← point(0, 0, 0)
        //        And up ← vector(0, 1, 0)
        //        When t ← view_transform(from, to, up)
        //        Then t = translation(0, 0, -8)
        
        let from = Tuple.Point(x: 0, y: 0, z: 8)
        let to = Tuple.Point(x: 0, y: 0, z: 0)
        let up = Tuple.Vector(x: 0, y: 1, z: 0)
        let t = Matrix4x4.viewTransform(from: from, to: to, up: up)
        XCTAssertEqual(t, Matrix4x4.translate(x: 0, y: 0, z: -8))
    }
    
    func testArbitraryViewTransform() {
        //        Scenario: An arbitrary view transformation
        //        Given from ← point(1, 3, 2)
        //        And to ← point(4, -2, 8)
        //        And up ← vector(1, 1, 0)
        //        When t ← view_transform(from, to, up)
        //        Then t is the following 4x4 matrix:
        //        | -0.50709 | 0.50709 |  0.67612 | -2.36643 |
        //        |  0.76772 | 0.60609 |  0.12122 | -2.82843 |
        //        | -0.35857 | 0.59761 | -0.71714 |  0.00000 |
        //        |  0.00000 | 0.00000 |  0.00000 |  1.00000 |

        let from = Tuple.Point(x: 1, y: 3, z: 2)
        let to = Tuple.Point(x: 4, y: -2, z: 8)
        let up = Tuple.Vector(x: 1, y: 1, z: 0)
        let t = Matrix4x4.viewTransform(from: from, to: to, up: up)
        
        let result = Matrix4x4([-0.50709, 0.50709,  0.67612, -2.36643,
                                0.76772, 0.60609,  0.12122, -2.82843,
                                -0.35857, 0.59761, -0.71714,  0.00000,
                                0.00000, 0.00000,  0.00000,  1.00000])
        
        XCTAssertEqual(t, result)
        
    }
}
