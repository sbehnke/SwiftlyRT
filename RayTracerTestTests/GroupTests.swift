//
//  GroupTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

class GroupTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreatingGroup() {
//    Scenario: Creating a new group
//    Given g ← group()
//    Then g.transform = identity_matrix
//    And g is empty
        
        let g = Group()
        XCTAssertEqual(g.transform, Matrix4x4.identity)
        XCTAssertTrue(g.empty)
    }
    
    func testAddingChild() {
//    Scenario: Adding a child to a group
//    Given g ← group()
//    And s ← test_shape()
//    When add_child(g, s)
//    Then g is not empty
//    And g includes s
//    And s.parent = g
    
        let g = Group()
        let s = TestShape()
        
        g.addChild(s)
        XCTAssertFalse(g.empty)
        XCTAssertTrue(g.children.contains(s))
        XCTAssertEqual(s.parent, g)
    }
    
    
    func testIntersectingRayWithEmptyGroup() {
//    Scenario: Intersecting a ray with an empty group
//    Given g ← group()
//    And r ← ray(point(0, 0, 0), vector(0, 0, 1))
//    When xs ← local_intersect(g, r)
//    Then xs is empty
     
        let g = Group()
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = g.localIntersects(ray: r)
        XCTAssertEqual(0, xs.count)
    }
    
    func testIntersectingRayWithNonEmptyGroup() {
//    Scenario: Intersecting a ray with a nonempty group
//    Given g ← group()
//    And s1 ← sphere()
//    And s2 ← sphere()
//    And set_transform(s2, translation(0, 0, -3))
//    And s3 ← sphere()
//    And set_transform(s3, translation(5, 0, 0))
//    And add_child(g, s1)
//    And add_child(g, s2)
//    And add_child(g, s3)
//    When r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And xs ← local_intersect(g, r)
//    Then xs.count = 4
//    And xs[0].object = s2
//    And xs[1].object = s2
//    And xs[2].object = s1
//    And xs[3].object = s1

        let g = Group()
        let s1 = Sphere()
        let s2 = Sphere()
        s2.transform = .translated(x: 0, y: 0, z: -3)
        let s3 = Sphere()
        s3.transform = .translated(x: 5, y: 0, z: 0)
        g.addChildren([s1, s2, s3])
        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = g.localIntersects(ray: r)
        XCTAssertEqual(4, xs.count)
        XCTAssertEqual(xs[0].object, s2)
        XCTAssertEqual(xs[1].object, s2)
        XCTAssertEqual(xs[2].object, s1)
        XCTAssertEqual(xs[3].object, s1)
    }
    
    func testInteresctingTranformedGroup() {
//    Scenario: Intersecting a transformed group
//    Given g ← group()
//    And set_transform(g, scaling(2, 2, 2))
//    And s ← sphere()
//    And set_transform(s, translation(5, 0, 0))
//    And add_child(g, s)
//    When r ← ray(point(10, 0, -10), vector(0, 0, 1))
//    And xs ← intersect(g, r)
//    Then xs.count = 2

        let g = Group()
        g.transform = .scaled(x: 2, y: 2, z: 2)
        let s = Sphere()
        s.transform = .translated(x: 5, y: 0, z: 0)
        let r = Ray(origin: .Point(x: 10, y: 0, z: -10), direction: .Vector(x: 0, y: 0, z: 1))
        g.addChild(s)
        let xs = g.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
    }
    
    func testGroupBoundsContainsItsChildren() {
        let s = Sphere()
        s.transform = .translated(x: 2, y: 5, z: -3) * Matrix4x4.scaled(x: 2, y: 2, z: 2)
        
        let c = Cylinder()
        c.minimum = -2
        c.maximum = 2
        c.transform = .translated(x: -4, y: -1, z: 4) * Matrix4x4.scaled(x: 0.5, y: 1, z: 0.5)
        
        let g = Group()
        g.addChildren([s, c])
        
        let bounds = g.bounds()
        XCTAssertEqual(bounds.minimum, Tuple.Point(x: -4.5, y: -3, z: -5))
        XCTAssertEqual(bounds.maximum, Tuple.Point(x: 4, y: 7, z: 4.5))
    }
}
