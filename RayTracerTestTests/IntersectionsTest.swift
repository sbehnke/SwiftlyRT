//
//  IntersectionsTest.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class IntersectionsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntersectionEncapsulatesTandObject() {
//    Scenario: An intersection encapsulates t and object
//    Given s ← sphere()
//    When i ← intersection(3.5, s)
//    Then i.t = 3.5
//    And i.object = s
        
        let s = Sphere()
        let i = Intersection(t: 3.5, object: s)
        XCTAssertEqual(i.t, 3.5)
        XCTAssertEqual(i.object, s)
    }
    
    func testPrecomputingStateOfIntersection() {
//    Scenario: Precomputing the state of an intersection
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And shape ← sphere()
//    And i ← intersection(4, shape)
//    When comps ← prepare_computations(i, r)
//    Then comps.t = i.t
//    And comps.object = i.object
//    And comps.point = point(0, 0, -1)
//    And comps.eyev = vector(0, 0, -1)
//    And comps.normalv = vector(0, 0, -1)

        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = shape.intersects(ray: r)
        let comps = i[0].prepareCopmutation(ray: r)
        XCTAssertEqual(comps.t, i[0].t)
        XCTAssertEqual(comps.object, i[0].object)
        XCTAssertEqual(comps.point, Tuple.Point(x: 0, y: 0, z: -1))
        XCTAssertEqual(comps.eyeVector, Tuple.Vector(x: 0, y: 0, z: -1))
        XCTAssertEqual(comps.normalVector, Tuple.Vector(x: 0, y: 0, z: -1))
    }
    
    func testPrecomputingReflectionVector() {
//    Scenario: Precomputing the reflection vector
//    Given shape ← plane()
//    And r ← ray(point(0, 1, -1), vector(0, -√2/2, √2/2))
//    And i ← intersection(√2, shape)
//    When comps ← prepare_computations(i, r)
//    Then comps.reflectv = vector(0, √2/2, √2/2)
        
        XCTFail()
    }
    
    func testHitWhenIntersectionOccursOnOutside() {
//    Scenario: The hit, when an intersection occurs on the outside
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And shape ← sphere()
//    And i ← intersection(4, shape)
//    When comps ← prepare_computations(i, r)
//    Then comps.inside = false
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = shape.intersects(ray: r)
        let hit = Intersection.hit(i)
        let comps = hit!.prepareCopmutation(ray: r)
        XCTAssertFalse(comps.inside)
    }
    
    func testIntersectionOnInside() {
//    Scenario: The hit, when an intersection occurs on the inside
//    Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
//    And shape ← sphere()
//    And i ← intersection(1, shape)
//    When comps ← prepare_computations(i, r)
//    Then comps.point = point(0, 0, 1)
//    And comps.eyev = vector(0, 0, -1)
//    And comps.inside = true
//    # normal would have been (0, 0, 1), but is inverted!
//    And comps.normalv = vector(0, 0, -1)
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: 0), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = shape.intersects(ray: r)
        let hit = Intersection.hit(i)
        let comps = hit!.prepareCopmutation(ray: r)
        XCTAssertEqual(comps.point, Tuple.Point(x: 0, y: 0, z: 1))
        XCTAssertEqual(comps.eyeVector, Tuple.Vector(x: 0, y: 0, z: -1))
        XCTAssertTrue(comps.inside)
        XCTAssertEqual(comps.normalVector, Tuple.Vector(x: 0, y: 0, z: -1))
    }
    
    func testHitShouldOffsetThePoint() {
//    Scenario: The hit should offset the point
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And shape ← sphere() with:
//    | transform | translation(0, 0, 1) |
//    And i ← intersection(5, shape)
//    When comps ← prepare_computations(i, r)
//    Then comps.over_point.z < -EPSILON/2
//    And comps.point.z > comps.over_point.z
        
        XCTFail()
    }
    
    func testUnderPointOffsetBelowSurface() {
//    Scenario: The under point is offset below the surface
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And shape ← glass_sphere() with:
//    | transform | translation(0, 0, 1) |
//    And i ← intersection(5, shape)
//    And xs ← intersections(i)
//    When comps ← prepare_computations(i, r, xs)
//    Then comps.under_point.z > EPSILON/2
//    And comps.point.z < comps.under_point.z
        
        XCTFail()
    }
    
    func testAggragatingIntersections() {
//    Scenario: Aggregating intersections
//    Given s ← sphere()
//    And i1 ← intersection(1, s)
//    And i2 ← intersection(2, s)
//    When xs ← intersections(i1, i2)
//    Then xs.count = 2
//    And xs[0].t = 1
//    And xs[1].t = 2
        
        XCTFail()
    }
    
    func testHitWhenAllIntersectionsHavePositiveT() {
//    Scenario: The hit, when all intersections have positive t
//    Given s ← sphere()
//    And i1 ← intersection(1, s)
//    And i2 ← intersection(2, s)
//    And xs ← intersections(i2, i1)
//    When i ← hit(xs)
//    Then i = i1
        
        let s = Sphere()
        let i1 = Intersection(t: 1, object: s)
        let i2 = Intersection(t: 2, object: s)
        let xs = [i1, i2]
        let i = Intersection.hit(xs)
        XCTAssertEqual(i, i1)
    }
    
    func testHitWhenSomeIntersectionsHaveNegativeT() {
//    Scenario: The hit, when some intersections have negative t
//    Given s ← sphere()
//    And i1 ← intersection(-1, s)
//    And i2 ← intersection(1, s)
//    And xs ← intersections(i2, i1)
//    When i ← hit(xs)
//    Then i = i2
        
        let s = Sphere()
        let i1 = Intersection(t: -1, object: s)
        let i2 = Intersection(t: 1, object: s)
        let xs = [i1, i2]
        let i = Intersection.hit(xs)
        XCTAssertEqual(i, i2)
    }
    
    func testHitWhenAllIntersectionsHaveNegativeT() {
//    Scenario: The hit, when all intersections have negative t
//    Given s ← sphere()
//    And i1 ← intersection(-2, s)
//    And i2 ← intersection(-1, s)
//    And xs ← intersections(i2, i1)
//    When i ← hit(xs)
//    Then i is nothing
        
        let s = Sphere()
        let i1 = Intersection(t: -2, object: s)
        let i2 = Intersection(t: -1, object: s)
        let xs = [i1, i2]
        let i = Intersection.hit(xs)
        XCTAssertNil(i)
    }
    
    func testHitIsAlwaysTheLowestNonNegativeIntersection() {
//    Scenario: The hit is always the lowest nonnegative intersection
//    Given s ← sphere()
//    And i1 ← intersection(5, s)
//    And i2 ← intersection(7, s)
//    And i3 ← intersection(-3, s)
//    And i4 ← intersection(2, s)
//    And xs ← intersections(i1, i2, i3, i4)
//    When i ← hit(xs)
//    Then i = i4
        
        let s = Sphere()
        let i1 = Intersection(t: 5, object: s)
        let i2 = Intersection(t: 7, object: s)
        let i3 = Intersection(t: -3, object: s)
        let i4 = Intersection(t: 2, object: s)
        
        let xs = [i1, i2, i3, i4]
        let i = Intersection.hit(xs)
        XCTAssertEqual(i, i4)
    }
    
    func testFindingN1andN2AtVariousIntersections() {
//    Scenario Outline: Finding n1 and n2 at various intersections
//    Given A ← glass_sphere() with:
//    | transform                 | scaling(2, 2, 2) |
//    | material.refractive_index | 1.5              |
//    And B ← glass_sphere() with:
//    | transform                 | translation(0, 0, -0.25) |
//    | material.refractive_index | 2.0                      |
//    And C ← glass_sphere() with:
//    | transform                 | translation(0, 0, 0.25) |
//    | material.refractive_index | 2.5                     |
//    And r ← ray(point(0, 0, -4), vector(0, 0, 1))
//    And xs ← intersections(2:A, 2.75:B, 3.25:C, 4.75:B, 5.25:C, 6:A)
//    When comps ← prepare_computations(xs[<index>], r, xs)
//    Then comps.n1 = <n1>
//    And comps.n2 = <n2>
//
//    Examples:
//    | index | n1  | n2  |
//    | 0     | 1.0 | 1.5 |
//    | 1     | 1.5 | 2.0 |
//    | 2     | 2.0 | 2.5 |
//    | 3     | 2.5 | 2.5 |
//    | 4     | 2.5 | 1.5 |
//    | 5     | 1.5 | 1.0 |
        
        XCTFail()
    }
    
    func testSchlickApproximation() {
//    Scenario: The Schlick approximation under total internal reflection
//    Given shape ← glass_sphere()
//    And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
//    And xs ← intersections(-√2/2:shape, √2/2:shape)
//    When comps ← prepare_computations(xs[1], r, xs)
//    And reflectance ← schlick(comps)
//    Then reflectance = 1.0
        
        XCTFail()
    }
    
    func testSchlickApproximationWithPerpendicularViewingAngle() {
//    Scenario: The Schlick approximation with a perpendicular viewing angle
//    Given shape ← glass_sphere()
//    And r ← ray(point(0, 0, 0), vector(0, 1, 0))
//    And xs ← intersections(-1:shape, 1:shape)
//    When comps ← prepare_computations(xs[1], r, xs)
//    And reflectance ← schlick(comps)
//    Then reflectance = 0.04
        
        XCTFail()
    }
    
    func testSchlickApproximationWithSmallAngle() {
//    Scenario: The Schlick approximation with small angle and n2 > n1
//    Given shape ← glass_sphere()
//    And r ← ray(point(0, 0.99, -2), vector(0, 0, 1))
//    And xs ← intersections(1.8589:shape)
//    When comps ← prepare_computations(xs[0], r, xs)
//    And reflectance ← schlick(comps)
//    Then reflectance = 0.48873
        
        XCTFail()
    }
    
    func testIntersectionCanEncapsulateUandV() {
//    Scenario: An intersection can encapsulate `u` and `v`
//    Given s ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
//    When i ← intersection_with_uv(3.5, s, 0.2, 0.4)
//    Then i.u = 0.2
//    And i.v = 0.4
        
        XCTFail()
    }
}
