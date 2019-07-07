//
//  CylinderTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

class CylinderTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRayMissesCylinder() {
    
//    Scenario Outline: A ray misses a cylinder
//    Given cyl ← cylinder()
//    And direction ← normalize(<direction>)
//    And r ← ray(<origin>, direction)
//    When xs ← local_intersect(cyl, r)
//    Then xs.count = 0
//
//    Examples:
//    | origin          | direction       |
//    | point(1, 0, 0)  | vector(0, 1, 0) |
//    | point(0, 0, 0)  | vector(0, 1, 0) |
//    | point(0, 0, -5) | vector(1, 1, 1) |
    
        let points: [Tuple] = [.Point(x: 1, y: 0, z: 0),
                               .Point(x: 0, y: 0, z: 0),
                               .Point(x: 0, y: 0, z: -5)]
        
        let directions: [Tuple] = [.Vector(x: 0, y: 1, z: 0),
                                   .Vector(x: 0, y: 1, z: 0),
                                   .Vector(x: 1, y: 1, z: 1)]

        let cyl = Cylinder()
        
        for index in 0..<points.count {
            let direction = directions[index].normalized()
            let ray = Ray(origin: points[index], direction: direction)
            let xs = cyl.localIntersects(ray: ray)
            XCTAssertEqual(xs.count, 0)
        }
    }
    
    func testRayStrikesCylinder() {
//    Scenario Outline: A ray strikes a cylinder
//    Given cyl ← cylinder()
//    And direction ← normalize(<direction>)
//    And r ← ray(<origin>, direction)
//    When xs ← local_intersect(cyl, r)
//    Then xs.count = 2
//    And xs[0].t = <t0>
//    And xs[1].t = <t1>
//
//    Examples:
//    | origin            | direction         | t0      | t1      |
//    | point(1, 0, -5)   | vector(0, 0, 1)   | 5       | 5       |
//    | point(0, 0, -5)   | vector(0, 0, 1)   | 4       | 6       |
//    | point(0.5, 0, -5) | vector(0.1, 1, 1) | 6.80798 | 7.08872 |
    
        let points: [Tuple] = [.Point(x: 1,   y: 0, z: -5),
                               .Point(x: 0,   y: 0, z: -5),
                               .Point(x: 0.5, y: 0, z: -5)]
        
        let directions: [Tuple] = [.Vector(x: 0,   y: 0, z: 1),
                                   .Vector(x: 0,   y: 0, z: 1),
                                   .Vector(x: 0.1, y: 1, z: 1)]
        
        let t0: [Double] = [5, 4, 6.80798]
        let t1: [Double] = [5, 6, 7.08872]
        
        let cyl = Cylinder()
        
        for index in 0..<points.count {
            let direction = directions[index].normalized()
            let ray = Ray(origin: points[index], direction: direction)
            let xs = cyl.localIntersects(ray: ray)
            XCTAssertEqual(xs.count, 2)
            XCTAssertEqual(xs[0].t, t0[index], accuracy: Tuple.epsilon)
            XCTAssertEqual(xs[1].t, t1[index], accuracy: Tuple.epsilon)
        }
    }
        
    func testNormalVectorOnCylinder() {
//    Scenario Outline: Normal vector on a cylinder
//    Given cyl ← cylinder()
//    When n ← local_normal_at(cyl, <point>)
//    Then n = <normal>
//
//    Examples:
//    | point           | normal           |
//    | point(1, 0, 0)  | vector(1, 0, 0)  |
//    | point(0, 5, -1) | vector(0, 0, -1) |
//    | point(0, -2, 1) | vector(0, 0, 1)  |
//    | point(-1, 1, 0) | vector(-1, 0, 0) |
    
        let cyl = Cylinder()
        
        let points: [Tuple] = [.Point(x: 1,  y: 0,  z:  0),
                               .Point(x: 0,  y: 5,  z: -1),
                               .Point(x: 0,  y: -2, z:  1),
                               .Point(x: -1, y:  1, z:  0),]

        let normals: [Tuple] = [.Vector(x: 1,  y: 0,  z: 0) ,
                                .Vector(x: 0,  y: 0,  z: -1),
                                .Vector(x: 0,  y: 0,  z: 1) ,
                                .Vector(x: -1, y:  0, z:  0),]

        for index in 0..<points.count {
            let n = cyl.localNormalAt(p: points[index])
            XCTAssertEqual(n, normals[index])
        }
    }
        
    func testMinimumAndMaximumForCylinder() {
//    Scenario: The default minimum and maximum for a cylinder
//    Given cyl ← cylinder()
//    Then cyl.minimum = -infinity
//    And cyl.maximum = infinity
        
        let cyl = Cylinder()
        XCTAssertEqual(cyl.minimum, -Double.infinity)
        XCTAssertEqual(cyl.maximum, Double.infinity)
    }
    
    func testIntersectingConstrainedCylinder() {
//    Scenario Outline: Intersecting a constrained cylinder
//    Given cyl ← cylinder()
//    And cyl.minimum ← 1
//    And cyl.maximum ← 2
//    And direction ← normalize(<direction>)
//    And r ← ray(<point>, direction)
//    When xs ← local_intersect(cyl, r)
//    Then xs.count = <count>
//
//    Examples:
//    |   | point             | direction         | count |
//    | 1 | point(0, 1.5, 0)  | vector(0.1, 1, 0) | 0     |
//    | 2 | point(0, 3, -5)   | vector(0, 0, 1)   | 0     |
//    | 3 | point(0, 0, -5)   | vector(0, 0, 1)   | 0     |
//    | 4 | point(0, 2, -5)   | vector(0, 0, 1)   | 0     |
//    | 5 | point(0, 1, -5)   | vector(0, 0, 1)   | 0     |
//    | 6 | point(0, 1.5, -2) | vector(0, 0, 1)   | 2     |
        
        let cyl = Cylinder()
        cyl.minimum = 1
        cyl.maximum = 2
        
        let points: [Tuple] = [.Point(x: 0, y: 1.5, z:  0),
                               .Point(x: 0, y: 3,   z: -5),
                               .Point(x: 0, y: 0,   z: -5),
                               .Point(x: 0, y: 2,   z: -5),
                               .Point(x: 0, y: 1,   z: -5),
                               .Point(x: 0, y: 1.5, z: -2),]
        
        let directions: [Tuple] = [.Vector(x: 0.1, y: 1, z: 0),
                                   .Vector(x: 0,   y: 0, z: 1),
                                   .Vector(x: 0,   y: 0, z: 1),
                                   .Vector(x: 0,   y: 0, z: 1),
                                   .Vector(x: 0,   y: 0, z: 1),
                                   .Vector(x: 0,   y: 0, z: 1),]
        
        let counts = [0, 0, 0, 0, 0, 2]
        
        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index].normalized())
            let xs = cyl.localIntersects(ray: r)
            XCTAssertEqual(counts[index], xs.count)
        }
    }
    
    func testDefaultClosedValueForCylinder() {
//    Scenario: The default closed value for a cylinder
//    Given cyl ← cylinder()
//    Then cyl.closed = false
        let cyl = Cylinder()
        XCTAssertFalse(cyl.closed)
    }

    func testIntersectingCapsOfClosedCylinder() {
//    Scenario Outline: Intersecting the caps of a closed cylinder
//    Given cyl ← cylinder()
//    And cyl.minimum ← 1
//    And cyl.maximum ← 2
//    And cyl.closed ← true
//    And direction ← normalize(<direction>)
//    And r ← ray(<point>, direction)
//    When xs ← local_intersect(cyl, r)
//    Then xs.count = <count>
//
//    Examples:
//    |   | point            | direction        | count |
//    | 1 | point(0, 3, 0)   | vector(0, -1, 0) | 2     |
//    | 2 | point(0, 3, -2)  | vector(0, -1, 2) | 2     |
//    | 3 | point(0, 4, -2)  | vector(0, -1, 1) | 2     | # corner case
//    | 4 | point(0, 0, -2)  | vector(0, 1, 2)  | 2     |
//    | 5 | point(0, -1, -2) | vector(0, 1, 1)  | 2     | # corner case
    
        let cyl = Cylinder()
        cyl.minimum = 1
        cyl.maximum = 2
        cyl.closed = true
        
        let points: [Tuple] = [.Point(x: 0, y:  3, z:  0),
                               .Point(x: 0, y:  3, z: -2),
                               .Point(x: 0, y:  4, z: -2),
                               .Point(x: 0, y:  0, z: -2),
                               .Point(x: 0, y: -1, z: -2),]
        
        let directions: [Tuple] = [.Vector(x: 0, y: -1, z: 0),
                                   .Vector(x: 0, y: -1, z: 2),
                                   .Vector(x: 0, y: -1, z: 1),
                                   .Vector(x: 0, y:  1, z: 2),
                                   .Vector(x: 0, y:  1, z: 1),]

        let counts = [2, 2, 2, 2, 2]
        
        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index].normalized())
            let xs = cyl.localIntersects(ray: r)
            XCTAssertEqual(counts[index], xs.count)
        }
    }
        
    func testNormalOnCylinderCaps() {
//    Scenario Outline: The normal vector on a cylinder's end caps
//    Given cyl ← cylinder()
//    And cyl.minimum ← 1
//    And cyl.maximum ← 2
//    And cyl.closed ← true
//    When n ← local_normal_at(cyl, <point>)
//    Then n = <normal>
//
//    Examples:
//    | point            | normal           |
//    | point(0, 1, 0)   | vector(0, -1, 0) |
//    | point(0.5, 1, 0) | vector(0, -1, 0) |
//    | point(0, 1, 0.5) | vector(0, -1, 0) |
//    | point(0, 2, 0)   | vector(0, 1, 0)  |
//    | point(0.5, 2, 0) | vector(0, 1, 0)  |
//    | point(0, 2, 0.5) | vector(0, 1, 0)  |
    
        let cyl = Cylinder()
        cyl.minimum = 1
        cyl.maximum = 2
        cyl.closed = true
        
        let points: [Tuple] = [.Point(x: 0,   y: 1, z: 0),
                               .Point(x: 0.5, y: 1, z: 0),
                               .Point(x: 0,   y: 1, z: 0.5),
                               .Point(x: 0,   y: 2, z: 0),
                               .Point(x: 0.5, y: 2, z: 0),
                               .Point(x: 0,   y: 2, z: 0.5),]
        
        let normals: [Tuple] = [.Vector(x: 0, y: -1, z: 0),
                                .Vector(x: 0, y: -1, z: 0),
                                .Vector(x: 0, y: -1, z: 0),
                                .Vector(x: 0, y:  1, z: 0),
                                .Vector(x: 0, y:  1, z: 0),
                                .Vector(x: 0, y:  1, z: 0),]
        
        for index in 0..<points.count {
            let n = cyl.localNormalAt(p: points[index])
            XCTAssertEqual(n, normals[index])
        }
    }
    
    func testUnboundedCylinderbBoundingBox() {
//        Scenario: An unbounded cylinder has a bounding box
//        Given shape ← cylinder()
//        When box ← bounds_of(shape)
//        Then box.min = point(-1, -infinity, -1)
//        And box.max = point(1, infinity, 1)
        
        let c = Cylinder()
        let bounds = c.boundingBox()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -1, y: -.infinity, z: -1))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: 1, y: .infinity, z: 1))
    }
    
    func testBoundedCylinderBoundingBox() {
//        Scenario: A bounded cylinder has a bounding box
//        Given shape ← cylinder()
//        And shape.minimum ← -5
//        And shape.maximum ← 3
//        When box ← bounds_of(shape)
//        Then box.min = point(-1, -5, -1)
//        And box.max = point(1, 3, 1)

        let c = Cylinder()
        c.minimum = -5
        c.maximum = 3
        let bounds = c.boundingBox()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -1, y: -5, z: -1))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: 1, y: 3, z: 1))
    }
}
