//
//  CSGTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

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
    
        XCTFail()
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
    
        XCTFail()
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
        
        XCTFail()
    }
    
    func testRayMissesCSGObject() {
//    Scenario: A ray misses a CSG object
//    Given c ← csg("union", sphere(), cube())
//    And r ← ray(point(0, 2, -5), vector(0, 0, 1))
//    When xs ← local_intersect(c, r)
//    Then xs is empty
        
        XCTFail()
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

        XCTFail()
    }
    
    func testCSGBoundingBox() {
//        Scenario: Querying a shape's bounding box in its parent's space
//        Given shape ← sphere()
//        And set_transform(shape, translation(1, -3, 5) * scaling(0.5, 2, 4))
//        When box ← parent_space_bounds_of(shape)
//        Then box.min = point(0.5, -5, 1)
//        And box.max = point(1.5, -1, 9)
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
        
    }
}
