//
//  SmoothTriangleTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class SmoothTriangleTests : XCTestCase {
    //    Background:
    //    Given p1 ← point(0, 1, 0)
    //    And p2 ← point(-1, 0, 0)
    //    And p3 ← point(1, 0, 0)
    //    And n1 ← vector(0, 1, 0)
    //    And n2 ← vector(-1, 0, 0)
    //    And n3 ← vector(1, 0, 0)
    //    When tri ← smooth_triangle(p1, p2, p3, n1, n2, n3)
    
    let p1 = Tuple.Point(x: 0, y: 1, z: 0)
    let p2 = Tuple.Point(x: -1, y: 0, z: 0)
    let p3 = Tuple.Point(x: 1, y: 0, z: 0)
    
    let n1 = Tuple.Vector(x: 0, y: 1, z: 0)
    let n2 = Tuple.Vector(x: -1, y: 0, z: 0)
    let n3 = Tuple.Vector(x: 1, y: 0, z: 0)
    
    var tri = SmoothTriangle()

    override func setUp() {
        tri = SmoothTriangle(point1: p1, point2: p2, point3: p3, normal1: n1, normal2: n2, normal3: n3)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSmoothTriangleConstructor() {
//    Scenario: Constructing a smooth triangle
//    Then tri.p1 = p1
//    And tri.p2 = p2
//    And tri.p3 = p3
//    And tri.n1 = n1
//    And tri.n2 = n2
//    And tri.n3 = n3

        XCTAssertEqual(tri.p1, p1)
        XCTAssertEqual(tri.p2, p2)
        XCTAssertEqual(tri.p3, p3)
        XCTAssertEqual(tri.n1, n1)
        XCTAssertEqual(tri.n2, n2)
        XCTAssertEqual(tri.n3, n3)
    }

    func testAnIntersectionWithASmoothTriangleStoresUV() {
//    Scenario: An intersection with a smooth triangle stores u/v
//    When r ← ray(point(-0.2, 0.3, -2), vector(0, 0, 1))
//    And xs ← local_intersect(tri, r)
//    Then xs[0].u = 0.45
//    And xs[0].v = 0.25

        let r = Ray(origin: .Point(x: -0.2, y: 0.3, z: -2), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = tri.localIntersects(ray: r)
        XCTAssertEqual(xs[0].u, 0.45, accuracy: Tuple.epsilon)
        XCTAssertEqual(xs[0].v, 0.25, accuracy: Tuple.epsilon)
    }

    func testSmoothTrianlgeUsedUVToInterpolateTheNormal() {
//    Scenario: A smooth triangle uses u/v to interpolate the normal
//    When i ← intersection_with_uv(1, tri, 0.45, 0.25)
//    And n ← normal_at(tri, point(0, 0, 0), i)
//    Then n = vector(-0.5547, 0.83205, 0)
        let i = Intersection(t: 1, object: tri, u: 0.45, v: 0.25)
        let n = tri.normalAt(p: .Point(x: 0, y: 0, z: 0), hit: i)
        XCTAssertEqual(n, Tuple.Vector(x: -0.5547, y: 0.83205, z: 0))
    }

    func testPreparingTheNormalOnASmoothTriangle() {
//    Scenario: Preparing the normal on a smooth triangle
//    When i ← intersection_with_uv(1, tri, 0.45, 0.25)
//    And r ← ray(point(-0.2, 0.3, -2), vector(0, 0, 1))
//    And xs ← intersections(i)
//    And comps ← prepare_computations(i, r, xs)
//    Then comps.normalv = vector(-0.5547001962252291, 0.8320502943378437, 0)

        let i = Intersection(t: 1, object: tri, u: 0.45, v: 0.25)
        let r = Ray(origin: .Point(x: -0.2, y: 0.3, z: -2), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = [i]
        let comps = i.prepareComputation(ray: r, xs: xs)
        XCTAssertEqual(comps.normalVector, Tuple.Vector(x: -0.5547001962252291, y: 0.8320502943378437, z: 0))
    }
}
