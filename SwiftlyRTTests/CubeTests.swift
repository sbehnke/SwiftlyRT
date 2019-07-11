//
//  CubeTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class CubeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRayIntersectsWithCube() {
//    Scenario Outline: A ray intersects a cube
//    Given c ← cube()
//    And r ← ray(<origin>, <direction>)
//    When xs ← local_intersect(c, r)
//    Then xs.count = 2
//    And xs[0].t = <t1>
//    And xs[1].t = <t2>
//
//    Examples:
//    |        | origin            | direction        | t1 | t2 |
//    | +x     | point(5, 0.5, 0)  | vector(-1, 0, 0) |  4 |  6 |
//    | -x     | point(-5, 0.5, 0) | vector(1, 0, 0)  |  4 |  6 |
//    | +y     | point(0.5, 5, 0)  | vector(0, -1, 0) |  4 |  6 |
//    | -y     | point(0.5, -5, 0) | vector(0, 1, 0)  |  4 |  6 |
//    | +z     | point(0.5, 0, 5)  | vector(0, 0, -1) |  4 |  6 |
//    | -z     | point(0.5, 0, -5) | vector(0, 0, 1)  |  4 |  6 |
//    | inside | point(0, 0.5, 0)  | vector(0, 0, 1)  | -1 |  1 |

        let points: [Tuple] = [
            .Point(x:5,   y: 0.5, z:0),
            .Point(x:-5,  y: 0.5, z:0),
            .Point(x:0.5, y: 5,   z:0),
            .Point(x:0.5, y: -5,  z:0),
            .Point(x:0.5, y: 0,   z:5),
            .Point(x:0.5, y: 0,   z:-5),
            .Point(x:0,   y: 0.5, z:0)]
        
        let directions: [Tuple] = [
            .Vector(x: -1,y:  0,z:  0),
            .Vector(x: 1, y: 0, z: 0),
            .Vector(x: 0, y: -1,z:  0),
            .Vector(x: 0, y: 1, z: 0),
            .Vector(x: 0, y: 0, z: -1),
            .Vector(x: 0, y: 0, z: 1),
            .Vector(x: 0, y: 0, z: 1)]
        
        let t1: [Double] = [
            4,
            4,
            4,
            4,
            4,
            4,
            -1]
        
        let t2: [Double] = [
            6,
            6,
            6,
            6,
            6,
            6,
            1]
        
        let c = Cube()

        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index])
            let xs = c.localIntersects(ray: r)
            XCTAssertEqual(xs.count, 2)
            XCTAssertEqual(xs[0].t, t1[index])
            XCTAssertEqual(xs[1].t, t2[index])
        }
    }
    
    func testRayMissesCube() {
//    Scenario Outline: A ray misses a cube
//    Given c ← cube()
//    And r ← ray(<origin>, <direction>)
//    When xs ← local_intersect(c, r)
//    Then xs.count = 0
//
//    Examples:
//    | origin           | direction                      |
//    | point(-2, 0, 0)  | vector(0.2673, 0.5345, 0.8018) |
//    | point(0, -2, 0)  | vector(0.8018, 0.2673, 0.5345) |
//    | point(0, 0, -2)  | vector(0.5345, 0.8018, 0.2673) |
//    | point(2, 0, 2)   | vector(0, 0, -1)               |
//    | point(0, 2, 2)   | vector(0, -1, 0)               |
//    | point(2, 2, 0)   | vector(-1, 0, 0)               |

        let points: [Tuple] = [.Point(x: -2, y:  0, z: 0),
                               .Point(x: 0,  y: -2, z: 0),
                               .Point(x: 0,  y: 0,  z:-2),
                               .Point(x: 2,  y: 0,  z: 2),
                               .Point(x: 0,  y: 2,  z: 2),
                               .Point(x: 2,  y: 2,  z: 0)]
        
        let directions: [Tuple] = [.Vector(x: 0.2673, y: 0.5345, z: 0.8018),
                                   .Vector(x: 0.8018, y: 0.2673, z: 0.5345),
                                   .Vector(x: 0.5345, y: 0.8018, z: 0.2673),
                                   .Vector(x: 0,  y: 0,  z: -1),
                                   .Vector(x: 0,  y: -1, z:  0),
                                   .Vector(x: -1, y:  0, z:  0)]
        
        let c = Cube()
        
        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index])
            let xs = c.localIntersects(ray: r)
            XCTAssertEqual(xs.count, 0)
        }
    }
    
    func testNormalOnSurfaceOfCube() {
//    Scenario Outline: The normal on the surface of a cube
//    Given c ← cube()
//    And p ← <point>
//    When normal ← local_normal_at(c, p)
//    Then normal = <normal>
//
//    Examples:
//    | point                | normal           |
//    | point(1, 0.5, -0.8)  | vector(1, 0, 0)  |
//    | point(-1, -0.2, 0.9) | vector(-1, 0, 0) |
//    | point(-0.4, 1, -0.1) | vector(0, 1, 0)  |
//    | point(0.3, -1, -0.7) | vector(0, -1, 0) |
//    | point(-0.6, 0.3, 1)  | vector(0, 0, 1)  |
//    | point(0.4, 0.4, -1)  | vector(0, 0, -1) |
//    | point(1, 1, 1)       | vector(1, 0, 0)  |
//    | point(-1, -1, -1)    | vector(-1, 0, 0) |

        let c = Cube()
        
        let points: [Tuple] = [.Point(x: 1,    y: 0.5,  z: -0.8),
                               .Point(x: -1,   y: -0.2, z:  0.9),
                               .Point(x: -0.4, y: 1,    z: -0.1),
                               .Point(x: 0.3,  y: -1,   z: -0.7),
                               .Point(x: -0.6, y: 0.3,  z:  1),
                               .Point(x: 0.4,  y: 0.4,  z: -1),
                               .Point(x: 1,    y: 1,    z:  1),
                               .Point(x: -1,   y: -1,   z: -1)]
        
        let normals: [Tuple] = [.Vector(x: 1,  y: 0,  z: 0),
                                .Vector(x: -1, y: 0,  z: 0),
                                .Vector(x: 0,  y: 1,  z: 0),
                                .Vector(x: 0,  y: -1, z: 0),
                                .Vector(x: 0,  y: 0,  z: 1),
                                .Vector(x: 0,  y: 0,  z: -1),
                                .Vector(x: 1,  y: 0,  z: 0),
                                .Vector(x: -1, y: 0,  z: 0)]
        
        for index in 0..<points.count {
            let normal = c.localNormalAt(p: points[index], hit: Intersection())
            XCTAssertEqual(normal, normals[index])
        }
    }
    
    func testCubeBoundingBox() {
//        Scenario: A cube has a bounding box
//        Given shape ← cube()
//        When box ← bounds_of(shape)
//        Then box.min = point(-1, -1, -1)
//        And box.max = point(1, 1, 1)
        
        let c = Cube()
        let bounds = c.boundingBox()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -1, y: -1, z: -1))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: 1, y: 1, z: 1))
    }
}
