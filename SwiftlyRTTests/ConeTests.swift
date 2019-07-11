//
//  ConeTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class ConeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIntersectingConeWithRay() {
    
//    Scenario Outline: Intersecting a cone with a ray
//    Given shape ← cone()
//    And direction ← normalize(<direction>)
//    And r ← ray(<origin>, direction)
//    When xs ← local_intersect(shape, r)
//    Then xs.count = 2
//    And xs[0].t = <t0>
//    And xs[1].t = <t1>
//
//    Examples:
//    | origin          | direction           | t0      | t1       |
//    | point(0, 0, -5) | vector(0, 0, 1)     | 5       |  5       |
//    | point(0, 0, -5) | vector(1, 1, 1)     | 8.66025 |  8.66025 |
//    | point(1, 1, -5) | vector(-0.5, -1, 1) | 4.55006 | 49.44994 |

        let shape = Cone()
        
        let points: [Tuple] = [.Point(x: 0, y: 0, z: -5),
                               .Point(x: 0, y: 0, z: -5),
                               .Point(x: 1, y: 1, z: -5),]

        let directions: [Tuple] = [.Vector(x: 0,    y:  0, z: 1),
                                   .Vector(x: 1,    y:  1, z: 1),
                                   .Vector(x: -0.5, y: -1, z: 1),]

        let t0: [Double] = [5, 8.66025, 4.55006]
        let t1: [Double] = [5, 8.66025, 49.44994]
        
        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index].normalized())
            let xs = shape.localIntersects(ray: r)
            XCTAssertEqual(xs.count, 2)
            XCTAssertEqual(xs[0].t, t0[index], accuracy: Tuple.epsilon)
            XCTAssertEqual(xs[1].t, t1[index], accuracy: Tuple.epsilon)
        }
    }
    
    func testIntersectingConeWithRayParallel() {
//    Scenario: Intersecting a cone with a ray parallel to one of its halves
//    Given shape ← cone()
//    And direction ← normalize(vector(0, 1, 1))
//    And r ← ray(point(0, 0, -1), direction)
//    When xs ← local_intersect(shape, r)
//    Then xs.count = 1
//    And xs[0].t = 0.35355
    
        let shape = Cone()
        let direction = Tuple.Vector(x: 0, y: 1, z: 1).normalized()
        let r = Ray(origin: .Point(x: 0, y: 0, z: -1), direction: direction)
        let xs = shape.localIntersects(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs[0].t, 0.35355, accuracy: Tuple.epsilon)
    }
    
    func testingConeIntersectingEndCaps() {
//    Scenario Outline: Intersecting a cone's end caps
//    Given shape ← cone()
//    And shape.minimum ← -0.5
//    And shape.maximum ← 0.5
//    And shape.closed ← true
//    And direction ← normalize(<direction>)
//    And r ← ray(<origin>, direction)
//    When xs ← local_intersect(shape, r)
//    Then xs.count = <count>
//
//    Examples:
//    | origin             | direction       | count |
//    | point(0, 0, -5)    | vector(0, 1, 0) | 0     |
//    | point(0, 0, -0.25) | vector(0, 1, 1) | 2     |
//    | point(0, 0, -0.25) | vector(0, 1, 0) | 4     |
    
        let shape = Cone()
        shape.minimum = -0.5
        shape.maximum = 0.5
        shape.closed = true
        
        let points: [Tuple] = [.Point(x: 0, y: 0, z: -5),
                               .Point(x: 0, y: 0, z: -0.25),
                               .Point(x: 0, y: 0, z: -0.25),]
        
        let directions: [Tuple] = [.Vector(x:0, y: 1, z: 0),
                                   .Vector(x:0, y: 1, z: 1),
                                   .Vector(x:0, y: 1, z: 0),]
        
        let counts = [0, 2, 4]
        
        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index].normalized())
            let xs = shape.localIntersects(ray: r)
            XCTAssertEqual(counts[index], xs.count)
        }
    }
    
    func testComputingNormal() {
//    Scenario Outline: Computing the normal vector on a cone
//    Given shape ← cone()
//    When n ← local_normal_at(shape, <point>)
//    Then n = <normal>
//
//    Examples:
//    | point             | normal                 |
//    | point(0, 0, 0)    | vector(0, 0, 0)        |
//    | point(1, 1, 1)    | vector(1, -√2, 1)      |
//    | point(-1, -1, 0)  | vector(-1, 1, 0)       |

        let points: [Tuple] = [.Point(x: 0,  y:  0, z: 0),
                               .Point(x: 1,  y:  1, z: 1),
                               .Point(x: -1, y: -1, z: 0),]
        
        let normals: [Tuple] = [.Vector(x: 0,  y: 0,   z:0),
                                .Vector(x: 1,  y: -sqrt(2), z:1),
                                .Vector(x: -1, y:  1,  z:0),]
        
        let shape = Cone()
        
        for index in 0..<points.count {
            let n = shape.localNormalAt(p: points[index], hit: Intersection())
            XCTAssertEqual(n, normals[index])
        }
    }
    
    func testUnboundedCylinderBoundingBox() {
//        Scenario: An unbounded cone has a bounding box
//        Given shape ← cone()
//        When box ← bounds_of(shape)
//        Then box.min = point(-infinity, -infinity, -infinity)
//        And box.max = point(infinity, infinity, infinity)

        let c = Cone()
        let bounds = c.boundingBox()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -.infinity, y: -.infinity, z: -.infinity))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: .infinity, y: .infinity, z: .infinity))
    }
    
    func testBoundedConeBoundingBox() {
//        Scenario: A bounded cone has a bounding box
//        Given shape ← cone()
//        And shape.minimum ← -5
//        And shape.maximum ← 3
//        When box ← bounds_of(shape)
//        Then box.min = point(-5, -5, -5)
//        And box.max = point(5, 3, 5)
        
        let c = Cone()
        c.minimum = -5
        c.maximum = 3
        
        let bounds = c.boundingBox()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -5, y: -5, z: -5))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: 5, y: 3, z: 5))
    }
}
