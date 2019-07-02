//
//  ConeTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

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
    
        XCTFail()
    }
    
    func testIntersectingConeWithRayParallel() {
//    Scenario: Intersecting a cone with a ray parallel to one of its halves
//    Given shape ← cone()
//    And direction ← normalize(vector(0, 1, 1))
//    And r ← ray(point(0, 0, -1), direction)
//    When xs ← local_intersect(shape, r)
//    Then xs.count = 1
//    And xs[0].t = 0.35355
    
        XCTFail()
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
    
        XCTFail()
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
        
        XCTFail()
    }
}
