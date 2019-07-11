//
//  IntersectionsTest.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import SwiftlyRT

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
        let comps = i[0].prepareComputation(ray: r)
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

        let shape = Plane()
        let r = Ray(origin: .Point(x: 0, y: 1, z: -1), direction: .Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2), object: shape)
        let comps = i.prepareComputation(ray: r)
        XCTAssertEqual(comps.reflectVector, Tuple.Vector(x: 0, y: sqrt(2)/2, z: sqrt(2)/2))
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
        let comps = hit!.prepareComputation(ray: r)
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
        let comps = hit!.prepareComputation(ray: r)
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
        
        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        shape.transform = Matrix4x4.translated(x: 0, y: 0, z: 1)
        let i = Intersection(t: 5, object: shape)
        let comps = i.prepareComputation(ray: r)
        XCTAssertTrue(comps.overPoint.z < -Tuple.epsilon / 2)
        XCTAssertTrue(comps.point.z > comps.overPoint.z)
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

        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let shape = Sphere.GlassSphere()
        shape.transform = .translated(x: 0, y: 0, z: 1)
        let i = Intersection(t: 5, object: shape)
        let xs = [i]
        let comps = i.prepareComputation(ray: r, xs: xs)
        XCTAssertTrue(comps.underPoint.z > Tuple.epsilon / 2.0)
        XCTAssertTrue(comps.point.z < comps.underPoint.z)
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
        let s = Sphere()
        let i1 = Intersection(t: 1, object: s)
        let i2 = Intersection(t: 2, object: s)
        let xs = [i1, i2]
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(xs[0].t, 1.0)
        XCTAssertEqual(xs[1].t, 2.0)
        
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

        let A = Sphere.GlassSphere()
        A.transform = .scaled(x: 2, y: 2, z: 2)
        A.material.refractiveIndex = 1.5
        
        let B = Sphere.GlassSphere()
        B.transform = .translated(x: 0, y: 0, z: -0.25)
        B.material.refractiveIndex = 2.0
        
        let C = Sphere.GlassSphere()
        C.transform = .translated(x: 0, y: 0, z: 0.25)
        C.material.refractiveIndex = 2.5
        
        let r = Ray(origin: .Point(x: 0, y: 0, z: -4), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = [Intersection(t: 2, object: A),
                  Intersection(t: 2.75, object: B),
                  Intersection(t: 3.25, object: C),
                  Intersection(t: 4.75, object: B),
                  Intersection(t: 5.25, object: C),
                  Intersection(t: 5.25, object: A)]
        
        let n1 = [1.0, 1.5, 2.0, 2.5, 2.5, 1.5]
        let n2 = [1.5, 2.0, 2.5, 2.5, 1.5, 1.0]
        
        for index in 0..<xs.count {
            let comps = xs[index].prepareComputation(ray: r, xs: xs)
            XCTAssertEqual(comps.n1, n1[index])
            XCTAssertEqual(comps.n2, n2[index])
        }
    }
    
    func testSchlickApproximation() {
//    Scenario: The Schlick approximation under total internal reflection
//    Given shape ← glass_sphere()
//    And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
//    And xs ← intersections(-√2/2:shape, √2/2:shape)
//    When comps ← prepare_computations(xs[1], r, xs)
//    And reflectance ← schlick(comps)
//    Then reflectance = 1.0
        
        let shape = Sphere.GlassSphere()
        let r = Ray(origin: .Point(x: 0, y: 0, z: sqrt(2)/2) , direction: .Vector(x: 0, y: 1, z: 0))
        let xs = [Intersection(t: -sqrt(2)/2, object: shape), Intersection(t: sqrt(2)/2, object: shape)]
        let comps = xs.last!.prepareComputation(ray: r, xs: xs)
        let reflectance = comps.schlick()
        XCTAssertEqual(reflectance, 1.0, accuracy: Tuple.epsilon)
    }
    
    func testSchlickApproximationWithPerpendicularViewingAngle() {
//    Scenario: The Schlick approximation with a perpendicular viewing angle
//    Given shape ← glass_sphere()
//    And r ← ray(point(0, 0, 0), vector(0, 1, 0))
//    And xs ← intersections(-1:shape, 1:shape)
//    When comps ← prepare_computations(xs[1], r, xs)
//    And reflectance ← schlick(comps)
//    Then reflectance = 0.04

        let shape = Sphere.GlassSphere()
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0), direction: .Vector(x: 0, y: 1, z: 0))
        let xs = [Intersection(t: -1, object: shape), Intersection(t: 1, object: shape)]
        let comps = xs[1].prepareComputation(ray: r, xs: xs)
        let reflectance = comps.schlick()
        XCTAssertEqual(0.04, reflectance, accuracy: Tuple.epsilon)
    }
    
    func testSchlickApproximationWithSmallAngle() {
//    Scenario: The Schlick approximation with small angle and n2 > n1
//    Given shape ← glass_sphere()
//    And r ← ray(point(0, 0.99, -2), vector(0, 0, 1))
//    And xs ← intersections(1.8589:shape)
//    When comps ← prepare_computations(xs[0], r, xs)
//    And reflectance ← schlick(comps)
//    Then reflectance = 0.48873
        
        let shape = Sphere.GlassSphere()
        let r = Ray(origin: .Point(x: 0, y: 0.99, z: -2), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = [Intersection(t: 1.8589, object: shape)]
        let comps = xs[0].prepareComputation(ray: r, xs: xs)
        let reflectance = comps.schlick()
        XCTAssertEqual(0.48873, reflectance, accuracy: Tuple.epsilon)
    }
    
    func testIntersectionCanEncapsulateUandV() {
//    Scenario: An intersection can encapsulate `u` and `v`
//    Given s ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
//    When i ← intersection_with_uv(3.5, s, 0.2, 0.4)
//    Then i.u = 0.2
//    And i.v = 0.4

        let s = Triangle(point1: .Point(x: 0, y: 1, z: 0), point2: .Point(x: -1, y: 0, z: 0), point3: .Point(x: 1, y: 0, z: 0))
        let i = Intersection(t: 3.5, object: s, u: 0.2, v: 0.4)
        XCTAssertEqual(i.u, 0.2)
        XCTAssertEqual(i.v, 0.4)
    }
    
    func testBoundingBoxIntersections() {
//        Scenario Outline: Intersecting a ray with a bounding box at the origin
//        Given box ← bounding_box(min=point(-1, -1, -1) max=point(1, 1, 1))
//        And direction ← normalize(<direction>)
//        And r ← ray(<origin>, direction)
//        Then intersects(box, r) is <result>
//
//        Examples:
//        | origin            | direction        | result |
//        | point(5, 0.5, 0)  | vector(-1, 0, 0) | true   |
//        | point(-5, 0.5, 0) | vector(1, 0, 0)  | true   |
//        | point(0.5, 5, 0)  | vector(0, -1, 0) | true   |
//        | point(0.5, -5, 0) | vector(0, 1, 0)  | true   |
//        | point(0.5, 0, 5)  | vector(0, 0, -1) | true   |
//        | point(0.5, 0, -5) | vector(0, 0, 1)  | true   |
//        | point(0, 0.5, 0)  | vector(0, 0, 1)  | true   |
//        | point(-2, 0, 0)   | vector(2, 4, 6)  | false  |
//        | point(0, -2, 0)   | vector(6, 2, 4)  | false  |
//        | point(0, 0, -2)   | vector(4, 6, 2)  | false  |
//        | point(2, 0, 2)    | vector(0, 0, -1) | false  |
//        | point(0, 2, 2)    | vector(0, -1, 0) | false  |
//        | point(2, 2, 0)    | vector(-1, 0, 0) | false  |

        let box = BoundingBox(minimum: .Point(x: -1, y: -1, z: -1), maximum: .Point(x: 1, y: 1, z: 1))
        
        let points: [Tuple] = [.Point(x: 5,   y: 0.5, z: 0),
                               .Point(x: -5,  y: 0.5, z: 0),
                               .Point(x: 0.5, y: 5,   z: 0),
                               .Point(x: 0.5, y: -5,  z: 0),
                               .Point(x: 0.5, y: 0,   z: 5),
                               .Point(x: 0.5, y: 0,   z:-5),
                               .Point(x: 0,   y: 0.5, z: 0),
                               .Point(x: -2,  y: 0,   z: 0),
                               .Point(x: 0,   y: -2,  z: 0),
                               .Point(x: 0,   y: 0,   z:-2),
                               .Point(x: 2,   y: 0,   z: 2),
                               .Point(x: 0,   y: 2,   z: 2),
                               .Point(x: 2,   y: 2,   z: 0),]

        
        let directions: [Tuple] = [.Vector(x: -1, y:  0, z:  0),
                                   .Vector(x: 1,  y: 0,  z: 0),
                                   .Vector(x: 0,  y: -1, z:  0),
                                   .Vector(x: 0,  y: 1,  z: 0),
                                   .Vector(x: 0,  y: 0,  z: -1),
                                   .Vector(x: 0,  y: 0,  z: 1),
                                   .Vector(x: 0,  y: 0,  z: 1),
                                   .Vector(x: 2,  y: 4,  z: 6),
                                   .Vector(x: 6,  y: 2,  z: 4),
                                   .Vector(x: 4,  y: 6,  z: 2),
                                   .Vector(x: 0,  y: 0,  z: -1),
                                   .Vector(x: 0,  y: -1, z:  0),
                                   .Vector(x: -1, y:  0, z:  0),]
        
        let results: [Bool] = [true, true, true, true, true, true, true, false, false, false, false, false, false,]

        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index].normalized())
            XCTAssertEqual(results[index], box.intersects(ray: r), "Index \(index) does not match.")
        }
    }
    
    func testIntersectingRayWithNonCubicBoundingBox() {
//        Scenario Outline: Intersecting a ray with a non-cubic bounding box
//        Given box ← bounding_box(min=point(5, -2, 0) max=point(11, 4, 7))
//        And direction ← normalize(<direction>)
//        And r ← ray(<origin>, direction)
//        Then intersects(box, r) is <result>
//
//        Examples:
//        | origin           | direction        | result |
//        | point(15, 1, 2)  | vector(-1, 0, 0) | true   |
//        | point(-5, -1, 4) | vector(1, 0, 0)  | true   |
//        | point(7, 6, 5)   | vector(0, -1, 0) | true   |
//        | point(9, -5, 6)  | vector(0, 1, 0)  | true   |
//        | point(8, 2, 12)  | vector(0, 0, -1) | true   |
//        | point(6, 0, -5)  | vector(0, 0, 1)  | true   |
//        | point(8, 1, 3.5) | vector(0, 0, 1)  | true   |
//        | point(9, -1, -8) | vector(2, 4, 6)  | false  |
//        | point(8, 3, -4)  | vector(6, 2, 4)  | false  |
//        | point(9, -1, -2) | vector(4, 6, 2)  | false  |
//        | point(4, 0, 9)   | vector(0, 0, -1) | false  |
//        | point(8, 6, -1)  | vector(0, -1, 0) | false  |
//        | point(12, 5, 4)  | vector(-1, 0, 0) | false  |
        
        let box = BoundingBox(minimum: .Point(x: 5, y: -2, z: 0), maximum: .Point(x: 11, y: 4, z: 7))
        
        let points: [Tuple] = [.Point(x: 15, y:  1, z: 2),
                               .Point(x: -5, y: -1, z: 4),
                               .Point(x: 7,  y: 6,  z: 5),
                               .Point(x: 9,  y: -5, z: 6),
                               .Point(x: 8,  y: 2,  z: 12),
                               .Point(x: 6,  y: 0,  z: -5),
                               .Point(x: 8,  y: 1,  z: 3.5),
                               .Point(x: 9,  y: -1, z: -8),
                               .Point(x: 8,  y: 3,  z: -4),
                               .Point(x: 9,  y: -1, z: -2),
                               .Point(x: 4,  y: 0,  z:  9),
                               .Point(x: 8,  y: 6,  z: -1),
                               .Point(x: 12, y:  5, z:  4),]
        
        let directions: [Tuple] = [.Vector(x: -1, y:  0, z:  0),
                                   .Vector(x: 1,  y: 0,  z: 0),
                                   .Vector(x: 0,  y: -1, z:  0),
                                   .Vector(x: 0,  y: 1,  z: 0),
                                   .Vector(x: 0,  y: 0,  z: -1),
                                   .Vector(x: 0,  y: 0,  z: 1),
                                   .Vector(x: 0,  y: 0,  z: 1),
                                   .Vector(x: 2,  y: 4,  z: 6),
                                   .Vector(x: 6,  y: 2,  z: 4),
                                   .Vector(x: 4,  y: 6,  z: 2),
                                   .Vector(x: 0,  y: 0,  z: -1),
                                   .Vector(x: 0,  y: -1, z:  0),
                                   .Vector(x: -1, y:  0, z:  0),]
        
        let results: [Bool] = [true, true, true, true, true, true, true, false, false, false, false, false, false,]
        
        for index in 0..<points.count {
            let r = Ray(origin: points[index], direction: directions[index].normalized())
            XCTAssertEqual(results[index], box.intersects(ray: r), "Index \(index) does not match.")
        }
    }
}
