//
//  RayTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class RayTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateAndQueryRay() {
//    Scenario: Creating and querying a ray
//    Given origin ← point(1, 2, 3)
//    And direction ← vector(4, 5, 6)
//    When r ← ray(origin, direction)
//    Then r.origin = origin
//    And r.direction = direction
    
        let origin = Tuple.Point(x: 1, y: 2, z: 3)
        let direction = Tuple.Vector(x: 4, y: 5, z: 6)
        let r = Ray(origin: origin, direction: direction)
        XCTAssertEqual(origin, r.origin)
        XCTAssertEqual(direction, r.direction)
    }
    
    func testComputingPointFromADistance() {
//    Scenario: Computing a point from a distance
//    Given r ← ray(point(2, 3, 4), vector(1, 0, 0))
//    Then position(r, 0) = point(2, 3, 4)
//    And position(r, 1) = point(3, 3, 4)
//    And position(r, -1) = point(1, 3, 4)
//    And position(r, 2.5) = point(4.5, 3, 4)
        
        let r = Ray(origin: Tuple.Point(x: 2, y: 3, z: 4), direction: Tuple.Vector(x: 1, y: 0, z: 0))
        XCTAssertEqual(r.position(time: 0), Tuple.Point(x: 2, y: 3, z: 4))
        XCTAssertEqual(r.position(time: 1), Tuple.Point(x: 3, y: 3, z: 4))
        XCTAssertEqual(r.position(time: -1), Tuple.Point(x: 1, y: 3, z: 4))
        XCTAssertEqual(r.position(time: 2.5), Tuple.Point(x: 4.5, y: 3, z: 4))
    }
    
    func testTranslatingRay() {
//    Scenario: Translating a ray
//    Given r ← ray(point(1, 2, 3), vector(0, 1, 0))
//    And m ← translation(3, 4, 5)
//    When r2 ← transform(r, m)
//    Then r2.origin = point(4, 6, 8)
//    And r2.direction = vector(0, 1, 0)
        
        let r = Ray(origin: Tuple.Point(x: 1, y: 2, z: 3), direction: Tuple.Vector(x: 0, y: 1, z: 0))
        let m = Tuple.Vector(x: 3, y: 4, z: 5)
        let r2 = r.translate(vector: m)
        XCTAssertEqual(r2.origin, Tuple.Point(x: 4, y: 6, z: 8))
        XCTAssertEqual(r2.direction, Tuple.Vector(x: 0, y: 1, z: 0))
    }

    func testScalingRay() {
//    Scenario: Scaling a ray
//    Given r ← ray(point(1, 2, 3), vector(0, 1, 0))
//    And m ← scaling(2, 3, 4)
//    When r2 ← transform(r, m)
//    Then r2.origin = point(2, 6, 12)
//    And r2.direction = vector(0, 3, 0)
        
        let r = Ray(origin: Tuple.Point(x: 1, y: 2, z: 3), direction: Tuple.Vector(x: 0, y: 1, z: 0))
        let m = Tuple.Vector(x: 2, y: 3, z: 4)
        let r2 = r.scale(vector: m)
        XCTAssertEqual(r2.origin, Tuple.Point(x: 2, y: 6, z: 12))
        XCTAssertEqual(r2.direction, Tuple.Vector(x: 0, y: 3, z: 0))
    }
}
