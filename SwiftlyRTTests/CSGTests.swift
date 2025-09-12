//
//  CSGTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class CSGTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCSGCreatedWithTwoShapes() {
//    Scenario: CSG is created with an operation and two shapes
//    Given s1 ← sphere()
//    And s2 ← cube()
//    When c ← csg("union", s1, s2)
//    Then c.operation = "union"
//    And c.left = s1
//    And c.right = s2
//    And s1.parent = c
//    And s2.parent = c

        let s1 = Sphere()
        let s2 = Cube()
        let c = CSG.union(left: s1, right: s2)
        XCTAssertEqual(c.oper, GeometryOperation.union)
        XCTAssertEqual(c.left, s1)
        XCTAssertEqual(c.right, s2)
        XCTAssertEqual(s1.parent, c)
        XCTAssertEqual(s2.parent, c)
    }
    
    func testEvaluatingRuleForCSGOperation() {
//    Scenario Outline: Evaluating the rule for a CSG operation
//    When result ← intersection_allowed("<op>", <lhit>, <inl>, <inr>)
//    Then result = <result>
//
//    Examples:
//    | op           | lhit  | inl   | inr   | result |
//    | union        | true  | true  | true  | false  |
//    | union        | true  | true  | false | true   |
//    | union        | true  | false | true  | false  |
//    | union        | true  | false | false | true   |
//    | union        | false | true  | true  | false  |
//    | union        | false | true  | false | false  |
//    | union        | false | false | true  | true   |
//    | union        | false | false | false | true   |
//    # append after the union examples...
//    | intersection | true  | true  | true  | true   |
//    | intersection | true  | true  | false | false  |
//    | intersection | true  | false | true  | true   |
//    | intersection | true  | false | false | false  |
//    | intersection | false | true  | true  | true   |
//    | intersection | false | true  | false | true   |
//    | intersection | false | false | true  | false  |
//    | intersection | false | false | false | false  |
//    # append after the intersection examples...
//    | difference   | true  | true  | true  | false  |
//    | difference   | true  | true  | false | true   |
//    | difference   | true  | false | true  | false  |
//    | difference   | true  | false | false | true   |
//    | difference   | false | true  | true  | true   |
//    | difference   | false | true  | false | true   |
//    | difference   | false | false | true  | false  |
//    | difference   | false | false | false | false  |
        
        
        var ops: [GeometryOperation] = []
        var lhit: [Bool] = []
        var inl: [Bool] = []
        var inr: [Bool] = []
        var result: [Bool] = []
        
        // union examples
        ops = [ .union, .union, .union, .union, .union, .union, .union, .union, .intersection, .intersection, .intersection, .intersection, .intersection, .intersection, .intersection, .intersection, .difference, .difference, .difference, .difference, .difference, .difference, .difference, .difference, ]

        lhit = [ true, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false ]
        
        inl = [ true, true, false, false, true, true, false, false, true, true, false, false, true, true, false, false, true, true, false, false, true, true, false, false, ]
        
        inr = [ true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, ]

        result = [ false, true, false, true, false, false, true, true, true, false, true, false, true, true, false, false, false, true, false, true, true, true, false, false, ]
        
        XCTAssertEqual(ops.count, lhit.count)
        XCTAssertEqual(ops.count, inl.count)
        XCTAssertEqual(ops.count, inr.count)
        XCTAssertEqual(ops.count, result.count)
        
        for index in 0..<ops.count {
            XCTAssertEqual(CSG.intersectionAllowed(op: ops[index], lhit: lhit[index], inl: inl[index], inr: inr[index]), result[index],
                            "Index \(index) does not match the expected result.")
        }
    }
    
    func testFilteringListOfIntersections() {
//    Scenario Outline: Filtering a list of intersections
//    Given s1 ← sphere()
//    And s2 ← cube()
//    And c ← csg("<operation>", s1, s2)
//    And xs ← intersections(1:s1, 2:s2, 3:s1, 4:s2)
//    When result ← filter_intersections(c, xs)
//    Then result.count = 2
//    And result[0] = xs[<x0>]
//    And result[1] = xs[<x1>]
//
//    Examples:
//    | operation    | x0 | x1 |
//    | union        | 0  | 3  |
//    | intersection | 1  | 2  |
//    | difference   | 0  | 1  |

        let s1 = Sphere()
        s1.name = "s1"
        let s2 = Cube()
        s2.name = "s2"
        
        let xs = [Intersection(t: 1, object: s1), Intersection(t: 2, object: s2), Intersection(t: 3, object: s1), Intersection(t: 4, object: s2)]
        
        let cUnion = CSG(oper: .union, left: s1, right: s2)
        let cIntersection = CSG(oper: .intersection, left: s1, right: s2)
        let cDifference = CSG(oper: .difference, left: s1, right: s2)
        
        let unionResult = cUnion.filterIntersections(xs)
        let intersectionResult = cIntersection.filterIntersections(xs)
        let differenceResult = cDifference.filterIntersections(xs)
        
        XCTAssertEqual(unionResult[0], xs[0])
        XCTAssertEqual(unionResult[1], xs[3])
        XCTAssertEqual(intersectionResult[0], xs[1])
        XCTAssertEqual(intersectionResult[1], xs[2])
        XCTAssertEqual(differenceResult[0], xs[0])
        XCTAssertEqual(differenceResult[1], xs[1])
    }
    
    func testRayMissesCSGObject() {
//    Scenario: A ray misses a CSG object
//    Given c ← csg("union", sphere(), cube())
//    And r ← ray(point(0, 2, -5), vector(0, 0, 1))
//    When xs ← local_intersect(c, r)
//    Then xs is empty

        let c = CSG(oper: .union, left: Sphere(), right: Cube())
        let r = Ray(origin: .Point(x: 0, y: 2, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = c.localIntersects(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    func testRayHittingCSGObject() {
//    Scenario: A ray hits a CSG object
//    Given s1 ← sphere()
//    And s2 ← sphere()
//    And set_transform(s2, translation(0, 0, 0.5))
//    And c ← csg("union", s1, s2)
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    When xs ← local_intersect(c, r)
//    Then xs.count = 2
//    And xs[0].t = 4
//    And xs[0].object = s1
//    And xs[1].t = 6.5
//    And xs[1].object = s2

        let s1 = Sphere()
        s1.name = "s1"
        let s2 = Sphere()
        s2.name = "s2"
        s2.transform = .translated(x: 0, y: 0, z: 0.5)
        let c = CSG.union(left: s1, right: s2)
        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = c.localIntersects(ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].t, 4)
        XCTAssertEqual(xs[0].object, s1)
        XCTAssertEqual(xs[1].t, 6.5)
        XCTAssertEqual(xs[1].object, s2)
    }
    
    func testCSGBoundingBox() {
//        Scenario: Querying a shape's bounding box in its parent's space
//        Given shape ← sphere()
//        And set_transform(shape, translation(1, -3, 5) * scaling(0.5, 2, 4))
//        When box ← parent_space_bounds_of(shape)
//        Then box.min = point(0.5, -5, 1)
//        And box.max = point(1.5, -1, 9)
        let shape = Sphere()
        shape.transform = .translated(x: 1, y: -3, z: 5) * Matrix4x4.scaled(x: 0.5, y: 2, z: 4)
        let box = shape.parentSpaceBounds()
        XCTAssertEqual(box.minimum, Tuple.Point(x: 0.5, y: -5, z: 1))
        XCTAssertEqual(box.maximum, Tuple.Point(x: 1.5, y: -1, z: 9))
    }
    
    func testCSGContainingChildrenBoundingBox() {
//        Scenario: A CSG shape has a bounding box that contains its children
//        Given left ← sphere()
//        And right ← sphere() with:
//        | transform | translation(2, 3, 4) |
//        And shape ← csg("difference", left, right)
//        When box ← bounds_of(shape)
//        Then box.min = point(-1, -1, -1)
//        And box.max = point(3, 4, 5)
        
        let left = Sphere()
        let right = Sphere()
        right.transform = .translated(x: 2, y: 3, z: 4)
        let shape = CSG.difference(left: left, right: right)
        let box = shape.boundingBox()
        XCTAssertEqual(box.minimum, Tuple.Point(x: -1, y: -1, z: -1))
        XCTAssertEqual(box.maximum, Tuple.Point(x: 3, y: 4, z: 5))
    }

    func testInterestMissingBoundingBox() {
//    Scenario: Intersecting ray+csg doesn't test children if box is missed
//    Given left ← test_shape()
//    And right ← test_shape()
//    And shape ← csg("difference", left, right)
//    And r ← ray(point(0, 0, -5), vector(0, 1, 0))
//    When xs ← intersect(shape, r)
//    Then left.saved_ray is unset
//    And right.saved_ray is unset

        let left = TestShape()
        let right = TestShape()
        let shape = CSG.difference(left: left, right: right)
        let r = Ray(origin: .Point(x: 0, y: 0, z: -4), direction: .Vector(x: 0, y: 1, z: 0))
        let _ = shape.intersects(ray: r)
        XCTAssertNil(left.savedRay)
        XCTAssertNil(right.savedRay)
    }
    
    func testIntersectHittingBoundingBox() {
//    Scenario: Intersecting ray+csg tests children if box is hit
//    Given left ← test_shape()
//    And right ← test_shape()
//    And shape ← csg("difference", left, right)
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    When xs ← intersect(shape, r)
//    Then left.saved_ray is set
//    And right.saved_ray is set

        let left = TestShape()
        let right = TestShape()
        let shape = CSG.difference(left: left, right: right)
        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let _ = shape.intersects(ray: r)
        XCTAssertNotNil(left.savedRay)
        XCTAssertNotNil(right.savedRay)
    }
    
    func testSubdividingCSGShape() {
//        Scenario: Subdividing a CSG shape subdivides its children
//        Given s1 ← sphere() with:
//        | transform | translation(-1.5, 0, 0) |
//        And s2 ← sphere() with:
//        | transform | translation(1.5, 0, 0) |
//        And left ← group() of [s1, s2]
//        And s3 ← sphere() with:
//        | transform | translation(0, 0, -1.5) |
//        And s4 ← sphere() with:
//        | transform | translation(0, 0, 1.5) |
//        And right ← group() of [s3, s4]
//        And shape ← csg("difference", left, right)
//        When divide(shape, 1)
//        Then left[0] is a group of [s1]
//        And left[1] is a group of [s2]
//        And right[0] is a group of [s3]
//        And right[1] is a group of [s4]

        let s1 = Sphere()
        s1.transform = .translated(x: -1.5, y: 0, z: 0)
        
        let s2 = Sphere()
        s2.transform = .translated(x: 1.5, y: 0, z: 0)
        
        let left = Group()
        left.addChildren([s1, s2])
        
        let s3 = Sphere()
        s3.transform = .translated(x: 0, y: 0, z: -1.5)
        
        let s4 = Sphere()
        s4.transform = .translated(x: 0, y: 0, z: 1.5)
        
        let right = Group()
        right.addChildren([s3, s4])
        
        let shape = CSG.difference(left: left, right: right)
        shape.divide(threshold: 1)
        
        let lg1 = left.children[0]
        XCTAssertEqual(lg1.children[0], s1)

        let lg2 = left.children[1]
        XCTAssertEqual(lg2.children[0], s2)

        let rg1 = right.children[0]
        XCTAssertEqual(rg1.children[0], s3)

        let rg2 = right.children[1]
        XCTAssertEqual(rg2.children[0], s4)
    }
}
