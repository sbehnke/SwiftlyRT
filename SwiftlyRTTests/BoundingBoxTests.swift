//
//  BoundingBoxTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import XCTest
@testable import SwiftlyRT

class BoundingBoxTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyBoundingBox() {
//        Scenario: Creating an empty bounding box
//        Given box ← bounding_box(empty)
//        Then box.min = point(infinity, infinity, infinity)
//        And box.max = point(-infinity, -infinity, -infinity)

        let box = BoundingBox()
        XCTAssertEqual(box.minimum, Tuple.Point(x: .infinity, y: .infinity, z: .infinity))
        XCTAssertEqual(box.maximum, Tuple.Point(x: -.infinity, y: -.infinity, z: -.infinity))
    }
    
  
    func testBoundingBoxWithVolume() {
//        Scenario: Creating a bounding box with volume
//        Given box ← bounding_box(min=point(-1, -2, -3) max=point(3, 2, 1))
//        Then box.min = point(-1, -2, -3)
//        And box.max = point(3, 2, 1)
        
        let box = BoundingBox(minimum: .Point(x: -1, y: -2, z: -3), maximum: .Point(x: 3, y: 2, z: 1))

        XCTAssertEqual(box.minimum, Tuple.Point(x: -1, y: -2, z: -3))
        XCTAssertEqual(box.maximum, Tuple.Point(x: 3, y: 2, z: 1))
    }

    func testAddingPointsToAnEmptyBoundingBox() {
//        Scenario: Adding points to an empty bounding box
//        Given box ← bounding_box(empty)
//        And p1 ← point(-5, 2, 0)
//        And p2 ← point(7, 0, -3)
//        When p1 is added to box
//        And p2 is added to box
//        Then box.min = point(-5, 0, -3)
//        And box.max = point(7, 2, 0)

        var box = BoundingBox()
        let p1 = Tuple.Point(x: -5, y: 2, z: 0)
        let p2 = Tuple.Point(x: 7, y: 0, z: -3)
        box.addPoint(point: p1)
        box.addPoint(point: p2)
        XCTAssertEqual(box.minimum, Tuple.Point(x: -5, y: 0, z: -3))
        XCTAssertEqual(box.maximum, Tuple.Point(x: 7, y: 2, z: 0))
    }
    
    func testAddingOneBoxToAnother() {
//        Scenario: Adding one bounding box to another
//        Given box1 ← bounding_box(min=point(-5, -2, 0) max=point(7, 4, 4))
//        And box2 ← bounding_box(min=point(8, -7, -2) max=point(14, 2, 8))
//        When box2 is added to box1
//        Then box1.min = point(-5, -7, -2)
//        And box1.max = point(14, 4, 8)
        
        var box1 = BoundingBox(minimum: .Point(x: -5, y: -2, z: 0), maximum: .Point(x: 7, y: 4, z: 4))
        let box2 = BoundingBox(minimum: .Point(x: 8, y: -7, z: -2), maximum: .Point(x: 14, y: 2, z: 8))
        box1.addBox(box: box2)
        
        XCTAssertEqual(box1.minimum, Tuple.Point(x: -5, y: -7, z: -2))
        XCTAssertEqual(box1.maximum, Tuple.Point(x: 14, y: 4, z: 8))
    }
    
    func testIfBoxContainsPoint() {
//        Scenario Outline: Checking to see if a box contains a given point
//        Given box ← bounding_box(min=point(5, -2, 0) max=point(11, 4, 7))
//        And p ← <point>
//        Then box_contains_point(box, p) is <result>
//
//        Examples:
//        | point           | result |
//        | point(5, -2, 0) | true   |
//        | point(11, 4, 7) | true   |
//        | point(8, 1, 3)  | true   |
//        | point(3, 0, 3)  | false  |
//        | point(8, -4, 3) | false  |
//        | point(8, 1, -1) | false  |
//        | point(13, 1, 3) | false  |
//        | point(8, 5, 3)  | false  |
//        | point(8, 1, 8)  | false  |
        
        let box = BoundingBox(minimum: .Point(x: 5, y: -2, z: 0), maximum: .Point(x: 11, y: 4, z: 7))
        
        let points: [Tuple] = [.Point(x: 5,  y: -2, z: 0),
                               .Point(x: 11, y:  4, z: 7),
                               .Point(x: 8,  y: 1,  z: 3),
                               .Point(x: 3,  y: 0,  z: 3),
                               .Point(x: 8,  y: -4, z: 3),
                               .Point(x: 8,  y: 1,  z: -1),
                               .Point(x: 13, y:  1, z: 3),
                               .Point(x: 8,  y: 5,  z: 3),
                               .Point(x: 8,  y: 1,  z: 8),]

        let results: [Bool] = [true, true, true, false, false, false, false, false, false]
        
        for index in 0..<results.count {
            XCTAssertEqual(box.containsPoint(point: points[index]), results[index])
        }
    }
    
    func testBoxContainsBox() {
//        Scenario Outline: Checking to see if a box contains a given box
//        Given box ← bounding_box(min=point(5, -2, 0) max=point(11, 4, 7))
//        And box2 ← bounding_box(min=<min> max=<max>)
//        Then box_contains_box(box, box2) is <result>
//
//        Examples:
//        | min              | max             | result |
//        | point(5, -2, 0)  | point(11, 4, 7) | true   |
//        | point(6, -1, 1)  | point(10, 3, 6) | true   |
//        | point(4, -3, -1) | point(10, 3, 6) | false  |
//        | point(6, -1, 1)  | point(12, 5, 8) | false  |
        
        let box = BoundingBox(minimum: .Point(x: 5, y: -2, z: 0), maximum: .Point(x: 11, y: 4, z: 7))

        let mins: [Tuple] = [.Point(x: 5, y: -2, z: 0),
                             .Point(x: 6, y: -1, z: 1),
                             .Point(x: 4, y: -3, z: -1),
                             .Point(x: 6, y: -1, z: 1),]
        
        let maxs: [Tuple] = [.Point(x: 11, y: 4, z: 7),
                             .Point(x: 10, y: 3, z: 6),
                             .Point(x: 10, y: 3, z: 6),
                             .Point(x: 12, y: 5, z: 8),]
        
        let results: [Bool] = [true, true, false, false]
        
        for index in 0..<results.count {
            let box2 = BoundingBox(minimum: mins[index], maximum: maxs[index])
            XCTAssertEqual(box.containsBox(box: box2), results[index])
        }
    }
    
    func testTransformations() {
//        Scenario: Transforming a bounding box
//        Given box ← bounding_box(min=point(-1, -1, -1) max=point(1, 1, 1))
//        And matrix ← rotation_x(π / 4) * rotation_y(π / 4)
//        When box2 ← transform(box, matrix)
//        Then box2.min = point(-1.4142, -1.7071, -1.7071)
//        And box2.max = point(1.4142, 1.7071, 1.7071)
        
        let box = BoundingBox(minimum: .Point(x: -1, y: -1, z: -1), maximum: .Point(x: 1, y: 1, z: 1))
        let matrix = Matrix4x4.rotatedX(.pi / 4) * Matrix4x4.rotatedY(.pi / 4)
        let box2 = box.transformed(transform: matrix)

        XCTAssertEqual(box2.minimum, Tuple.Point(x: -1.414213562373095, y: -1.7071067811865475, z: -1.7071067811865475))
        XCTAssertEqual(box2.maximum, Tuple.Point(x: 1.414213562373095, y: 1.7071067811865475, z: 1.7071067811865475))
    }
    
    func testSplittingPerfectCube() {
//        Scenario: Splitting a perfect cube
//        Given box ← bounding_box(min=point(-1, -4, -5) max=point(9, 6, 5))
//        When (left, right) ← split_bounds(box)
//        Then left.min = point(-1, -4, -5)
//        And left.max = point(4, 6, 5)
//        And right.min = point(4, -4, -5)
//        And right.max = point(9, 6, 5)
        
        let box = BoundingBox(minimum: .Point(x: -1, y: -4, z: -5), maximum: .Point(x: 9, y: 6, z: 5))
        let (left, right) = box.splitBoundingBox()
        XCTAssertEqual(left.minimum, Tuple.Point(x: -1, y: -4, z: -5))
        XCTAssertEqual(left.maximum, Tuple.Point(x: 4, y: 6, z: 5))
        XCTAssertEqual(right.minimum, Tuple.Point(x: 4, y: -4, z: -5))
        XCTAssertEqual(right.maximum, Tuple.Point(x: 9, y: 6, z: 5))
    }
    
    func testSplittingXWideBox() {
//    Scenario: Splitting an x-wide box
//    Given box ← bounding_box(min=point(-1, -2, -3) max=point(9, 5.5, 3))
//    When (left, right) ← split_bounds(box)
//    Then left.min = point(-1, -2, -3)
//    And left.max = point(4, 5.5, 3)
//    And right.min = point(4, -2, -3)
//    And right.max = point(9, 5.5, 3)
        
        let box = BoundingBox(minimum: .Point(x: -1, y: -2, z: -3), maximum: .Point(x: 9, y: 5.5, z: 3))
        let (left, right) = box.splitBoundingBox()
        XCTAssertEqual(left.minimum, Tuple.Point(x: -1, y: -2, z: -3))
        XCTAssertEqual(left.maximum, Tuple.Point(x: 4, y: 5.5, z: 3))
        XCTAssertEqual(right.minimum, Tuple.Point(x: 4, y: -2, z: -3))
        XCTAssertEqual(right.maximum, Tuple.Point(x: 9, y: 5.5, z: 3))
    }
    
    func testSplittingYWideBox() {
//    Scenario: Splitting a y-wide box
//    Given box ← bounding_box(min=point(-1, -2, -3) max=point(5, 8, 3))
//    When (left, right) ← split_bounds(box)
//    Then left.min = point(-1, -2, -3)
//    And left.max = point(5, 3, 3)
//    And right.min = point(-1, 3, -3)
//    And right.max = point(5, 8, 3)
        
        let box = BoundingBox(minimum: .Point(x: -1, y: -2, z: -3), maximum: .Point(x: 5, y: 8, z: 3))
        let (left, right) = box.splitBoundingBox()
        XCTAssertEqual(left.minimum, Tuple.Point(x: -1, y: -2, z: -3))
        XCTAssertEqual(left.maximum, Tuple.Point(x: 5, y: 3, z: 3))
        XCTAssertEqual(right.minimum, Tuple.Point(x: -1, y: 3, z: -3))
        XCTAssertEqual(right.maximum, Tuple.Point(x: 5, y: 8, z: 3))
    }
    
    func testSplittingZWideBox() {
//    Scenario: Splitting a z-wide box
//    Given box ← bounding_box(min=point(-1, -2, -3) max=point(5, 3, 7))
//    When (left, right) ← split_bounds(box)
//    Then left.min = point(-1, -2, -3)
//    And left.max = point(5, 3, 2)
//    And right.min = point(-1, -2, 2)
//    And right.max = point(5, 3, 7)
        
        let box = BoundingBox(minimum: .Point(x: -1, y: -2, z: -3), maximum: .Point(x: 5, y: 3, z: 7))
        let (left, right) = box.splitBoundingBox()
        XCTAssertEqual(left.minimum, Tuple.Point(x: -1, y: -2, z: -3))
        XCTAssertEqual(left.maximum, Tuple.Point(x: 5, y: 3, z: 2))
        XCTAssertEqual(right.minimum, Tuple.Point(x: -1, y: -2, z: 2))
        XCTAssertEqual(right.maximum, Tuple.Point(x: 5, y: 3, z: 7))
    }
}
