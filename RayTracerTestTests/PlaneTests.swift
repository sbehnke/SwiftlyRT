//
//  PlaneTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

class PlaneTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNormalOfPlaneIsConsistant() {
//    Scenario: The normal of a plane is constant everywhere
//    Given p ← plane()
//    When n1 ← local_normal_at(p, point(0, 0, 0))
//    And n2 ← local_normal_at(p, point(10, 0, -10))
//    And n3 ← local_normal_at(p, point(-5, 0, 150))
//    Then n1 = vector(0, 1, 0)
//    And n2 = vector(0, 1, 0)
//    And n3 = vector(0, 1, 0)
    

        let p = Plane()
        let n1 = p.localNormalAt(p: .Point(x: 0, y: 0, z: 0))
        let n2 = p.localNormalAt(p: .Point(x: 10, y: 0, z: -10))
        let n3 = p.localNormalAt(p: .Point(x: -5, y: 0, z: 150))
        XCTAssertEqual(n1, Tuple.Vector(x: 0, y: 1, z: 0))
        XCTAssertEqual(n2, Tuple.Vector(x: 0, y: 1, z: 0))
        XCTAssertEqual(n3, Tuple.Vector(x: 0, y: 1, z: 0))
    }
    
    func testIntersectRayParallelToPlane() {
//    Scenario: Intersect with a ray parallel to the plane
//    Given p ← plane()
//    And r ← ray(point(0, 10, 0), vector(0, 0, 1))
//    When xs ← local_intersect(p, r)
//    Then xs is empty
     
        let p = Plane()
        let r = Ray(origin: .Point(x: 0, y: 10, z: 0), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = p.localIntersects(ray: r)
        XCTAssertTrue(xs.isEmpty)
    }
    
    func testIntersectWithCoplanarRay() {
//    Scenario: Intersect with a coplanar ray
//    Given p ← plane()
//    And r ← ray(point(0, 0, 0), vector(0, 0, 1))
//    When xs ← local_intersect(p, r)
//    Then xs is empty
        
        let p = Plane()
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = p.localIntersects(ray: r)
        XCTAssertTrue(xs.isEmpty)
    }
    
    func testRayIntersectingPlaneFromAbove() {
//    Scenario: A ray intersecting a plane from above
//    Given p ← plane()
//    And r ← ray(point(0, 1, 0), vector(0, -1, 0))
//    When xs ← local_intersect(p, r)
//    Then xs.count = 1
//    And xs[0].t = 1
//    And xs[0].object = p
     
        let p = Plane()
        let r = Ray(origin: .Point(x: 0, y: 1, z: 0), direction: .Vector(x: 0, y: -1, z: 0))
        let xs = p.localIntersects(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs[0].t, 1)
        XCTAssertEqual(xs[0].object, p)
    }
    
    func testRayIntersectingPlaneFromBelow() {
//    Scenario: A ray intersecting a plane from below
//    Given p ← plane()
//    And r ← ray(point(0, -1, 0), vector(0, 1, 0))
//    When xs ← local_intersect(p, r)
//    Then xs.count = 1
//    And xs[0].t = 1
//    And xs[0].object = p
     
        let p = Plane()
        let r = Ray(origin: .Point(x: 0, y: -1, z: 0), direction: .Vector(x: 0, y: 1, z: 0))
        let xs = p.localIntersects(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs[0].t, 1)
        XCTAssertEqual(xs[0].object, p)
        
    }
    
    func testBounds() {
        let p = Plane()
        let bounds = p.bounds()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -.infinity, y: 0, z: -.infinity))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: .infinity, y: 0, z: .infinity))
    }
}
