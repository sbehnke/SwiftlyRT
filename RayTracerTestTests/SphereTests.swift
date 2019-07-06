//
//  SphereTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/1/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class SphereTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRayIntersectionAtTwoPoints() {
//    Scenario: A ray intersects a sphere at two points
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And s ← sphere()
//    When xs ← intersect(s, r)
//    Then xs.count = 2
//    And xs[0] = 4.0
//    And xs[1] = 6.0
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(4.0, xs[0].t)
        XCTAssertEqual(6.0, xs[1].t)
    }

    func testRayIntersectionAtTangent() {
//    Scenario: A ray intersects a sphere at a tangent
//    Given r ← ray(point(0, 1, -5), vector(0, 0, 1))
//    And s ← sphere()
//    When xs ← intersect(s, r)
//    Then xs.count = 2
//    And xs[0] = 5.0
//    And xs[1] = 5.0
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 1, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(5.0, xs[0].t)
        XCTAssertEqual(5.0, xs[1].t)
    }

    func testRayMissesSphere() {
//    Scenario: A ray misses a sphere
//    Given r ← ray(point(0, 2, -5), vector(0, 0, 1))
//    And s ← sphere()
//    When xs ← intersect(s, r)
//    Then xs.count = 0

        let r = Ray(origin: Tuple.Point(x: 0, y: 2, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersects(ray: r)
        XCTAssertEqual(0, xs.count)
    }

    func testRayOriginatesInsideSphere() {
//    Scenario: A ray originates inside a sphere
//    Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
//    And s ← sphere()
//    When xs ← intersect(s, r)
//    Then xs.count = 2
//    And xs[0] = -1.0
//    And xs[1] = 1.0
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: 0), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(-1.0, xs[0].t)
        XCTAssertEqual(1.0, xs[1].t)
    }
    
    func testRayIsBehindSphere() {
//    Scenario: A sphere is behind a ray
//    Given r ← ray(point(0, 0, 5), vector(0, 0, 1))
//    And s ← sphere()
//    When xs ← intersect(s, r)
//    Then xs.count = 2
//    And xs[0] = -6.0
//    And xs[1] = -4.0
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: 5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(-6.0, xs[0].t)
        XCTAssertEqual(-4.0, xs[1].t)
    }
    
    func testIntersectSetsObjectOnIntersection() {
//    Scenario: Intersect sets the object on the intersection
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And s ← sphere()
//    When xs ← intersect(s, r)
//    Then xs.count = 2
//    And xs[0].object = s
//    And xs[1].object = s
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(s, xs[0].object)
        XCTAssertEqual(s, xs[1].object)
    }
    
    func testSphereDefaultTransformation() {
//    Scenario: A sphere's default transformation
//    Given s ← sphere()
//    Then s.transform = identity_matrix

        let s = Sphere()
        XCTAssertEqual(s.transform, Matrix4x4.identity)
    }
    
    func testChangingTransformation() {
//    Scenario: Changing a sphere's transformation
//    Given s ← sphere()
//    And t ← translation(2, 3, 4)
//    When set_transform(s, t)
//    Then s.transform = t
        
        let s = Sphere()
        let t = Matrix4x4.translated(x: 2, y: 3, z: 4)
        s.transform = t
        XCTAssertEqual(s.transform, t)
    }
    
    func testIntersectingAScaledSphere() {
//    Scenario: Intersecting a scaled sphere with a ray
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And s ← sphere()
//    When set_transform(s, scaling(2, 2, 2))
//    And xs ← intersect(s, r)
//    Then xs.count = 2
//    And xs[0].t = 3
//    And xs[1].t = 7
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        s.transform = Matrix4x4.scaled(x: 2, y: 2, z: 2)
        let xs = s.intersects(ray: r)
        XCTAssertEqual(2, xs.count)
        XCTAssertEqual(xs[0].t, 3)
        XCTAssertEqual(xs[1].t, 7)
    }
    
    func testIntersectingTranslatedSphere() {
//    Scenario: Intersecting a translated sphere with a ray
//    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And s ← sphere()
//    When set_transform(s, translation(5, 0, 0))
//    And xs ← intersect(s, r)
//    Then xs.count = 0
        
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        s.transform = Matrix4x4.translated(x: 5, y: 0, z: 0)
        let xs = s.intersects(ray: r)
        XCTAssertEqual(0, xs.count)
    }

    func testSphereNormalOnPointOnXAxis() {
//    Scenario: The normal on a sphere at a point on the x axis
//    Given s ← sphere()
//    When n ← normal_at(s, point(1, 0, 0))
//    Then n = vector(1, 0, 0)
        let s = Sphere()
        let n = s.normalAt(p: Tuple.Point(x: 1, y: 0, z: 0))
        XCTAssertEqual(n, Tuple.Vector(x: 1, y: 0, z: 0))
    }
    
    func testSphereNormalOnPointOnYAxis() {
//    Scenario: The normal on a sphere at a point on the y axis
//    Given s ← sphere()
//    When n ← normal_at(s, point(0, 1, 0))
//    Then n = vector(0, 1, 0)
        let s = Sphere()
        let n = s.normalAt(p: Tuple.Point(x: 0, y: 1, z: 0))
        XCTAssertEqual(n, Tuple.Vector(x: 0, y: 1, z: 0))
    }
    
    func testSphereNormalOnPointOnZAxis() {
//    Scenario: The normal on a sphere at a point on the z axis
//    Given s ← sphere()
//    When n ← normal_at(s, point(0, 0, 1))
//    Then n = vector(0, 0, 1)

        let s = Sphere()
        let n = s.normalAt(p: Tuple.Point(x: 0, y: 0, z: 1))
        XCTAssertEqual(n, Tuple.Vector(x: 0, y: 0, z: 1))
    }
    
    func testNormalOnSphereAtNonAxialPoint() {
//    Scenario: The normal on a sphere at a nonaxial point
//    Given s ← sphere()
//    When n ← normal_at(s, point(√3/3, √3/3, √3/3))
//    Then n = vector(√3/3, √3/3, √3/3)
       
        let value = sqrt(3.0) / 3.0
        let s = Sphere()
        let n = s.normalAt(p: Tuple.Point(x: value, y: value, z: value))
        XCTAssertEqual(n, Tuple.Vector(x: value, y: value, z: value))
    }
    
    func testNormalIsANormalizedVector() {
//    Scenario: The normal is a normalized vector
//    Given s ← sphere()
//    When n ← normal_at(s, point(√3/3, √3/3, √3/3))
//    Then n = normalize(n)
        
        let value = sqrt(3.0) / 3.0
        let s = Sphere()
        let n = s.normalAt(p: Tuple.Point(x: value, y: value, z: value))
        XCTAssertEqual(n, n.normalied())
    }
    
    func testComputingTheNormalOnTranslatedSphere() {
//    Scenario: Computing the normal on a translated sphere
//    Given s ← sphere()
//    And set_transform(s, translation(0, 1, 0))
//    When n ← normal_at(s, point(0, 1.70711, -0.70711))
//    Then n = vector(0, 0.70711, -0.70711)
        let s = Sphere()
        s.transform = Matrix4x4.translated(x: 0, y: 1, z: 0)
        let n = s.normalAt(p: Tuple.Point(x: 0, y: 1.70711, z: -0.70711))
        XCTAssertEqual(n, Tuple.Vector(x: 0, y: 0.70711, z: -0.70711))
    }
    
    func testComputingTheNormalOnTransformedSphere() {
//    Scenario: Computing the normal on a transformed sphere
//    Given s ← sphere()
//    And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
//    And set_transform(s, m)
//    When n ← normal_at(s, point(0, √2/2, -√2/2))
//    Then n = vector(0, 0.97014, -0.24254)

        let s = Sphere()
        let m = Matrix4x4.rotatedZ(Double.pi/5.0).scaled(x: 1, y: 0.5, z: 1)
        s.transform = m
        let n = s.normalAt(p: Tuple.Point(x: 0, y: sqrt(2.0)/2.0, z: -sqrt(2.0)/2.0))
        XCTAssertEqual(n, Tuple.Vector(x: 0, y: 0.97014, z: -0.24254))
    }
    
    func testSphereHasDefaultMaterial() {
//    Scenario: A sphere has a default material
//    Given s ← sphere()
//    When m ← s.material
//    Then m = material()

        let s = Sphere()
        XCTAssertEqual(s.material, Material())
    }
    
    func testSphereMayBeAssignedMaterial() {
//    Scenario: A sphere may be assigned a material
//    Given s ← sphere()
//    And m ← material()
//    And m.ambient ← 1
//    When s.material ← m
//    Then s.material = m

        let s = Sphere()
        var m = Material()
        m.ambient = 1.0
        s.material = m
        XCTAssertEqual(s.material, m)
    }
    
    static func GlassSphere() -> Sphere {
//    Scenario: A helper for producing a sphere with a glassy material
//    Given s ← glass_sphere()
//    Then s.transform = identity_matrix
//    And s.material.transparency = 1.0
//    And s.material.refractive_index = 1.5

        let s = Sphere()
        s.transform = Matrix4x4.identity
        s.material.transparency = 1.0
        s.material.refractiveIndex = 1.5
        return s
    }
}
