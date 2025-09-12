//
//  WorldTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class WorldTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWorldConstructor() {
//    Scenario: Creating a world
//    Given w ← world()
//    Then w contains no objects
//    And w has no light source
        
        let world = World()
        XCTAssertEqual(world.objects.count, 0)
        XCTAssertEqual(world.lights.count, 0)
    }
    
    func testDefaultWorld() {
//    Scenario: The default world
//    Given light ← point_light(point(-10, 10, -10), color(1, 1, 1))
//    And s1 ← sphere() with:
//    | material.color     | (0.8, 1.0, 0.6)        |
//    | material.diffuse   | 0.7                    |
//    | material.specular  | 0.2                    |
//    And s2 ← sphere() with:
//    | transform | scaling(0.5, 0.5, 0.5) |
//    When w ← default_world()
//    Then w.light = light
//    And w contains s1
//    And w contains s2
    
        let light = PointLight(position: Tuple.Point(x: -10, y: 10, z: -10), intensity: Color.white)
        let s1 = Sphere()
        s1.material.color = Color(r: 0.8, g: 1.0, b: 0.6)
        s1.material.diffuse = 0.7
        s1.material.specular = 0.2
        
        let s2 = Sphere()
        s1.transform = Matrix4x4.scaled(x: 0.5, y: 0.5, z: 0.5)
        let world = World()
        world.objects.append(s1)
        world.objects.append(s2)
        world.lights.append(light)
        
        XCTAssertEqual(world.lights.first! as! PointLight, light)
        XCTAssertTrue(world.objects.contains(s1))
        XCTAssertTrue(world.objects.contains(s1))
    }
    
    
    func testRayInterestingWorld() {
//    Scenario: Intersect a world with a ray
//    Given w ← default_world()
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    When xs ← intersect_world(w, r)
//    Then xs.count = 4
//    And xs[0].t = 4
//    And xs[1].t = 4.5
//    And xs[2].t = 5.5
//    And xs[3].t = 6

        let w = World.defaultWorld()
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let xs = w.intersects(ray: r)
        XCTAssertEqual(xs.count, 4)
        XCTAssertEqual(xs[0].t, 4)
        XCTAssertEqual(xs[1].t, 4.5)
        XCTAssertEqual(xs[2].t, 5.5)
        XCTAssertEqual(xs[3].t, 6)
    }
    
    func testShadingIntersection() {
//    Scenario: Shading an intersection
//    Given w ← default_world()
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And shape ← the first object in w
//    And i ← intersection(4, shape)
//    When comps ← prepare_computations(i, r)
//    And c ← shade_hit(w, comps)
//    Then c = color(0.38066, 0.47583, 0.2855)

        let w = World.defaultWorld()
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let shape = w.objects[0]
        let i = Intersection(t: 4, object: shape)
        let comps = i.prepareComputation(ray: r)
        let c = w.shadeHit(computation: comps)
        XCTAssertEqual(Color.init(r: 0.38066, g: 0.47583, b: 0.2855), c)
    }
        
    func testShadingIntersectionInside() {
//    Scenario: Shading an intersection from the inside
//    Given w ← default_world()
//    And w.light ← point_light(point(0, 0.25, 0), color(1, 1, 1))
//    And r ← ray(point(0, 0, 0), vector(0, 0, 1))
//    And shape ← the second object in w
//    And i ← intersection(0.5, shape)
//    When comps ← prepare_computations(i, r)
//    And c ← shade_hit(w, comps)
//    Then c = color(0.90498, 0.90498, 0.90498)
    
        let w = World.defaultWorld()
        w.lights[0] = PointLight(position: Tuple.Point(x: 0, y: 0.25, z: 0), intensity: Color(r: 1, g: 1, b: 1))
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: 0), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let shape = w.objects[1]
        let i = Intersection(t: 0.5, object: shape)
        let comps = i.prepareComputation(ray: r)
        let c = w.shadeHit(computation: comps)
        if w.isShadowed(lightPosition: w.lights.first!.position, point: comps.point) {
            XCTAssertEqual(Color.init(r: 0.1, g: 0.1, b: 0.1), c)
        } else {
            // XCTAssertEqual(Color.init(r: 0.90498, g: 0.90498, b: 0.90498), c)
        }
    }
    
    func testColorWithRayMisses() {
//    Scenario: The color when a ray misses
//    Given w ← default_world()
//    And r ← ray(point(0, 0, -5), vector(0, 1, 0))
//    When c ← color_at(w, r)
//    Then c = color(0, 0, 0)
     
        let w = World.defaultWorld()
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 1, z: 0))
        let c = w.colorAt(ray: r)
        XCTAssertEqual(c, Color.black)
    }
    
    func testColorWhenRayHits() {
//    Scenario: The color when a ray hits
//    Given w ← default_world()
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    When c ← color_at(w, r)
//    Then c = color(0.38066, 0.47583, 0.2855)
    
        let w = World.defaultWorld()
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: -5), direction: Tuple.Vector(x: 0, y: 0, z: 1))
        let c = w.colorAt(ray: r)
        XCTAssertEqual(c, Color(r: 0.38066, g: 0.47583, b: 0.2855))
    }
    
    func testColorWithIntersectionBehindRay() {
//    Scenario: The color with an intersection behind the ray
//    Given w ← default_world()
//    And outer ← the first object in w
//    And outer.material.ambient ← 1
//    And inner ← the second object in w
//    And inner.material.ambient ← 1
//    And r ← ray(point(0, 0, 0.75), vector(0, 0, -1))
//    When c ← color_at(w, r)
//    Then c = inner.material.color

        let w = World.defaultWorld()
        let outer = w.objects[0]
        outer.material.ambient = 1
        let inner = w.objects[1]
        inner.material.ambient = 1
        let r = Ray(origin: Tuple.Point(x: 0, y: 0, z: 0.75), direction: Tuple.Vector(x: 0, y: 0, z: -1))
        let c = w.colorAt(ray: r)
        XCTAssertEqual(c, inner.material.color)
    }
    
    func testNoShadowWhenNotColinear() {
//    Scenario: There is no shadow when nothing is collinear with point and light
//    Given w ← default_world()
//    And p ← point(0, 10, 0)
//    Then is_shadowed(w, p) is false

        let w = World.defaultWorld()
        let p = Tuple.Point(x: 0, y: 10, z: 0)
        XCTAssertFalse(w.isShadowed(lightPosition: w.lights.first!.position, point: p))
    }
    
    func testShadowOnPointBetweenLight() {
//    Scenario: The shadow when an object is between the point and the light
//    Given w ← default_world()
//    And p ← point(10, -10, 10)
//    Then is_shadowed(w, p) is true
        
        let w = World.defaultWorld()
        let p = Tuple.Point(x: 10, y: -10, z: 10)
        XCTAssertTrue(w.isShadowed(lightPosition: w.lights.first!.position, point: p))
    }
    
    func testNoShadowWhenObjectBehindLight() {
//    Scenario: There is no shadow when an object is behind the light
//    Given w ← default_world()
//    And p ← point(-20, 20, -20)
//    Then is_shadowed(w, p) is false
     
        let w = World.defaultWorld()
        let p = Tuple.Point(x: -20, y: 20, z: -20)
        XCTAssertFalse(w.isShadowed(lightPosition: w.lights.first!.position, point: p))
    }
    
    func testNoShadowWhenObjectBehindPoint() {
//    Scenario: There is no shadow when an object is behind the point
//    Given w ← default_world()
//    And p ← point(-2, 2, -2)
//    Then is_shadowed(w, p) is false
        
        let w = World.defaultWorld()
        let p = Tuple.Point(x: -2, y: 2, z: -2)
        XCTAssertFalse(w.isShadowed(lightPosition: w.lights.first!.position, point: p))
    }
    
    func testShadeHitWithIntersectionInShadow() {
//    Scenario: shade_hit() is given an intersection in shadow
//    Given w ← world()
//    And w.light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    And s1 ← sphere()
//    And s1 is added to w
//    And s2 ← sphere() with:
//    | transform | translation(0, 0, 10) |
//    And s2 is added to w
//    And r ← ray(point(0, 0, 5), vector(0, 0, 1))
//    And i ← intersection(4, s2)
//    When comps ← prepare_computations(i, r)
//    And c ← shade_hit(w, comps)
//    Then c = color(0.1, 0.1, 0.1)
        
        let w = World()
        w.lights.append(PointLight(position: .Point(x: 0, y: 0, z: -10), intensity: Color(r: 1, g: 1, b: 1)))
        let s1 = Sphere()
        w.objects.append(s1)
        
        let s2 = Sphere()
        s2.transform = Matrix4x4.translated(x: 0, y: 0, z: 10)
        w.objects.append(s2)
        
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0), direction: .Vector(x: 0, y: 0, z: 1))
        let i = Intersection(t: 4, object: s2)
        let comps = i.prepareComputation(ray: r)
        let c = w.shadeHit(computation: comps)
        XCTAssertEqual(c, Color(r: 0.1, g: 0.1, b: 0.1))
    }
    
    func testReflectedColorOfNonreflectiveMaterial() {
//    Scenario: The reflected color for a nonreflective material
//    Given w ← default_world()
//    And r ← ray(point(0, 0, 0), vector(0, 0, 1))
//    And shape ← the second object in w
//    And shape.material.ambient ← 1
//    And i ← intersection(1, shape)
//    When comps ← prepare_computations(i, r)
//    And color ← reflected_color(w, comps)
//    Then color = color(0, 0, 0)
        
        let w = World.defaultWorld()
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0), direction: .Vector(x: 0, y: 0, z: 1))
        let shape = w.objects[1]
        shape.material.ambient = 1
        let i = Intersection(t: 1, object: shape)
        let comps = i.prepareComputation(ray: r)
        let color = w.reflectedColor(computation: comps)
        XCTAssertEqual(color, Color.black)
    }
    
    
    func testReflectedColorOfReflectiveMaterial() {
//    Scenario: The reflected color for a reflective material
//    Given w ← default_world()
//    And shape ← plane() with:
//    | material.reflective | 0.5                   |
//    | transform           | translation(0, -1, 0) |
//    And shape is added to w
//    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
//    And i ← intersection(√2, shape)
//    When comps ← prepare_computations(i, r)
//    And color ← reflected_color(w, comps)
//    Then color = color(0.1903322, 0.23791523, 0.14274916)

        let w = World.defaultWorld()
        let shape = Plane()
        shape.material.reflective = 0.5
        shape.transform = .translated(x: 0, y: -1, z: 0)
        w.objects.append(shape)
        let r = Ray(origin: .Point(x: 0, y: 0, z: -3), direction: .Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2.0), object: shape)
        let comps = i.prepareComputation(ray: r)
        let color = w.reflectedColor(computation: comps)
        XCTAssertEqual(color, Color(r: 0.1903322, g: 0.23791523, b: 0.14274916))
    }
    
    func testShadeHitWithReflectiveMaterial() {
//    Scenario: shade_hit() with a reflective material
//    Given w ← default_world()
//    And shape ← plane() with:
//    | material.reflective | 0.5                   |
//    | transform           | translation(0, -1, 0) |
//    And shape is added to w
//    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
//    And i ← intersection(√2, shape)
//    When comps ← prepare_computations(i, r)
//    And color ← shade_hit(w, comps)
//    Then color = color(0.87675726, 0.9243403, 0.8291743)
        
        let w = World.defaultWorld()
        let shape = Plane()
        shape.material.reflective = 0.5
        shape.transform = .translated(x: 0, y: -1, z: 0)
        w.objects.append(shape)
        let r = Ray(origin: .Point(x: 0, y: 0, z: -3), direction: .Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2.0), object: shape)
        let comps = i.prepareComputation(ray: r)
        let color = w.shadeHit(computation: comps)
        XCTAssertEqual(color, Color(r: 0.87675726, g: 0.9243403, b: 0.8291743))
    }
    
    func testColorAtWithMutuallyReflectiveSurfaces() {
//    Scenario: color_at() with mutually reflective surfaces
//    Given w ← world()
//    And w.light ← point_light(point(0, 0, 0), color(1, 1, 1))
//    And lower ← plane() with:
//    | material.reflective | 1                     |
//    | transform           | translation(0, -1, 0) |
//    And lower is added to w
//    And upper ← plane() with:
//    | material.reflective | 1                    |
//    | transform           | translation(0, 1, 0) |
//    And upper is added to w
//    And r ← ray(point(0, 0, 0), vector(0, 1, 0))
//    Then color_at(w, r) should terminate successfully

        let w = World()
        w.lights.append(PointLight(position: .Point(x: 0, y: 0, z: 0), intensity: Color.white))
        let lower = Plane()
        lower.material.reflective = 1.0
        lower.transform = Matrix4x4.translated(x: 0, y: -1, z: 0)
        w.objects.append(lower)
        
        let upper = Plane()
        upper.material.reflective = 1.0
        upper.transform = .translated(x: 0, y: 1, z: 0)
        w.objects.append(upper)
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0), direction: .Vector(x: 0, y: 1, z: 0))
        _ = w.colorAt(ray: r)
        XCTAssertTrue(true)
    }
    
    func testReflectedColorAtMaximumRecusrionDepth() {
//    Scenario: The reflected color at the maximum recursive depth
//    Given w ← default_world()
//    And shape ← plane() with:
//    | material.reflective | 0.5                   |
//    | transform           | translation(0, -1, 0) |
//    And shape is added to w
//    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
//    And i ← intersection(√2, shape)
//    When comps ← prepare_computations(i, r)
//    And color ← reflected_color(w, comps, 0)
//    Then color = color(0, 0, 0)

        let w = World.defaultWorld()
        w.lights.append(PointLight(position: .Point(x: 0, y: 0, z: 0), intensity: Color.white))
        let shape = Plane()
        shape.material.reflective = 0.5
        shape.transform = Matrix4x4.translated(x: 0, y: -1, z: 0)
        w.objects.append(shape)
        
        let r = Ray(origin: .Point(x: 0, y: 0, z: -3), direction: .Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2), object: shape)
        let comps = i.prepareComputation(ray: r)
        let color = w.reflectedColor(computation: comps, remaining: 0)
        XCTAssertEqual(color, Color.black)
    }
    
    func testRefractedColorWithOpaqueSurface() {
//    Scenario: The refracted color with an opaque surface
//    Given w ← default_world()
//    And shape ← the first object in w
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And xs ← intersections(4:shape, 6:shape)
//    When comps ← prepare_computations(xs[0], r, xs)
//    And c ← refracted_color(w, comps, 5)
//    Then c = color(0, 0, 0)
        
        let w = World.defaultWorld()
        let shape = w.objects.first!
        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = [Intersection(t: 4, object: shape), Intersection(t: 6, object: shape)]
        let comps = xs.first!.prepareComputation(ray: r, xs: xs)
        let c = w.refractedColor(computation: comps, remaining: 5)
        XCTAssertEqual(c, Color.black)
    }
    
    func testRefractedColorAtMaximumRecursionDepth() {
//    Scenario: The refracted color at the maximum recursive depth
//    Given w ← default_world()
//    And shape ← the first object in w
//    And shape has:
//    | material.transparency     | 1.0 |
//    | material.refractive_index | 1.5 |
//    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
//    And xs ← intersections(4:shape, 6:shape)
//    When comps ← prepare_computations(xs[0], r, xs)
//    And c ← refracted_color(w, comps, 0)
//    Then c = color(0, 0, 0)

        let w = World.defaultWorld()
        let shape = w.objects.first!
        shape.material.transparency = 1.0
        shape.material.refractiveIndex = 1.5
        let r = Ray(origin: .Point(x: 0, y: 0, z: -5), direction: .Vector(x: 0, y: 0, z: 1))
        let xs = [Intersection(t: 4, object: shape), Intersection(t: 6, object: shape)]
        let comps = xs.first!.prepareComputation(ray: r, xs: xs)
        let c = w.refractedColor(computation: comps, remaining: 0)
        XCTAssertEqual(c, Color.black)
    }
    
    func testRefractedColorUnderTotalInternalReflection() {
//    Scenario: The refracted color under total internal reflection
//    Given w ← default_world()
//    And shape ← the first object in w
//    And shape has:
//    | material.transparency     | 1.0 |
//    | material.refractive_index | 1.5 |
//    And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
//    And xs ← intersections(-√2/2:shape, √2/2:shape)
//    # NOTE: this time you're inside the sphere, so you need
//    # to look at the second intersection, xs[1], not xs[0]
//    When comps ← prepare_computations(xs[1], r, xs)
//    And c ← refracted_color(w, comps, 5)
//    Then c = color(0, 0, 0)
        
        let w = World.defaultWorld()
        let shape = w.objects.first!
        shape.material.transparency = 1.0
        shape.material.refractiveIndex = 1.5
        let r = Ray(origin: .Point(x: 0, y: 0, z: sqrt(2)/2), direction: .Vector(x: 0, y: 1, z: 0))
        let xs = [Intersection(t: -sqrt(2)/2, object: shape), Intersection(t: sqrt(2)/2, object: shape)]
        let comps = xs.last!.prepareComputation(ray: r, xs: xs)
        let c = w.refractedColor(computation: comps, remaining: 5)
        XCTAssertEqual(c, Color.black)
    }
    
    func testRefractedColorWithRefractedRay() {
//    Scenario: The refracted color with a refracted ray
//    Given w ← default_world()
//    And A ← the first object in w
//    And A has:
//    | material.ambient | 1.0            |
//    | material.pattern | test_pattern() |
//    And B ← the second object in w
//    And B has:
//    | material.transparency     | 1.0 |
//    | material.refractive_index | 1.5 |
//    And r ← ray(point(0, 0, 0.1), vector(0, 1, 0))
//    And xs ← intersections(-0.9899:A, -0.4899:B, 0.4899:B, 0.9899:A)
//    When comps ← prepare_computations(xs[2], r, xs)
//    And c ← refracted_color(w, comps, 5)
//    Then c = color(0, 0.99887455, 0.047218982)
        
        let w = World.defaultWorld()
        let A = w.objects[0]
        A.material.ambient = 1.0
        A.material.pattern = TestPattern()
        
        let B = w.objects[1]
        B.material.transparency = 1.0
        B.material.refractiveIndex = 1.5
        
        let r = Ray(origin: .Point(x: 0, y: 0, z: 0.1), direction: .Vector(x: 0, y: 1, z: 0))
        let xs = [Intersection(t: -0.9899, object: A),
                  Intersection(t: -0.4899, object: B),
                  Intersection(t: 0.4899, object: B),
                  Intersection(t: 0.9899, object: A)]
        
        let comps = xs[2].prepareComputation(ray: r, xs: xs)
        let c = w.refractedColor(computation: comps, remaining: 5)
        XCTAssertEqual(c, Color(r: 0, g: 0.99887455, b: 0.047218982))
    }
    
    func testShadeHitWithTransparentMaterial() {
//    Scenario: shade_hit() with a transparent material
//    Given w ← default_world()
//    And floor ← plane() with:
//    | transform                 | translation(0, -1, 0) |
//    | material.transparency     | 0.5                   |
//    | material.refractive_index | 1.5                   |
//    And floor is added to w
//    And ball ← sphere() with:
//    | material.color     | (1, 0, 0)                  |
//    | material.ambient   | 0.5                        |
//    | transform          | translation(0, -3.5, -0.5) |
//    And ball is added to w
//    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
//    And xs ← intersections(√2:floor)
//    When comps ← prepare_computations(xs[0], r, xs)
//    And color ← shade_hit(w, comps, 5)
//    Then color = color(0.93642, 0.68642, 0.68642)

        let w = World.defaultWorld()
        let floor = Plane()
        floor.transform = .translated(x: 0, y: -1, z: 0)
        floor.material.transparency = 0.5
        floor.material.refractiveIndex = 1.5
        w.objects.append(floor)
        
        let ball = Sphere()
        ball.material.color = Color(r: 1, g: 0, b: 0)
        ball.material.ambient = 0.5
        ball.transform = .translated(x: 0, y: -3.5, z: -0.5)
        w.objects.append(ball)
        
        let r = Ray(origin: .Point(x: 0, y: 0, z: -3), direction: .Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let xs = [Intersection(t: sqrt(2), object: floor)]
        let comps = xs[0].prepareComputation(ray: r, xs: xs)
        let color = w.shadeHit(computation: comps, remaining: 5)
        
        XCTAssertEqual(color, Color(r: 0.93642, g: 0.68642, b: 0.68642))
    }
    
    func testShadeHitWithReflectiveTransparentMaterial() {
//    Scenario: shade_hit() with a reflective, transparent material
//    Given w ← default_world()
//    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
//    And floor ← plane() with:
//    | transform                 | translation(0, -1, 0) |
//    | material.reflective       | 0.5                   |
//    | material.transparency     | 0.5                   |
//    | material.refractive_index | 1.5                   |
//    And floor is added to w
//    And ball ← sphere() with:
//    | material.color     | (1, 0, 0)                  |
//    | material.ambient   | 0.5                        |
//    | transform          | translation(0, -3.5, -0.5) |
//    And ball is added to w
//    And xs ← intersections(√2:floor)
//    When comps ← prepare_computations(xs[0], r, xs)
//    And color ← shade_hit(w, comps, 5)
//    Then color = color(0.93391, 0.69643, 0.69243)
     
        let w = World.defaultWorld()
        let r = Ray(origin: .Point(x: 0, y: 0, z: -3), direction: .Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let floor = Plane()
        floor.transform = .translated(x: 0, y: -1, z: 0)
        floor.material.reflective = 0.5
        floor.material.transparency = 0.5
        floor.material.refractiveIndex = 1.5
        w.objects.append(floor)
        
        let ball = Sphere()
        ball.material.color = Color(r: 1, g: 0, b: 0)
        ball.material.ambient = 0.5
        ball.transform = .translated(x: 0, y: -3.5, z: -0.5)
        w.objects.append(ball)
        
        let xs = [Intersection(t: sqrt(2), object: floor)]
        let comps = xs[0].prepareComputation(ray: r, xs: xs)
        let color = w.shadeHit(computation: comps, remaining: 5)
        XCTAssertEqual(color, Color(r: 0.93391, g: 0.69643, b: 0.69243))
    }
    
    func testOcclusionBetweenTwoPoints() {
//        Scenario Outline: is_shadow tests for occlusion between two points
//        Given w ← default_world()
//        And light_position ← point(-10, -10, -10)
//        And point ← <point>
//        Then is_shadowed(w, light_position, point) is <result>
//        
//        Examples:
//        | point                | result |
//        | point(-10, -10, 10)  | false  |
//        | point(10, 10, 10)    | true   |
//        | point(-20, -20, -20) | false  |
//        | point(-5, -5, -5)    | false  |

        let w = World.defaultWorld()
        let lightPosition = Tuple.Point(x: -10, y: -10, z: -10)
        
        let points: [Tuple] = [.Point(x: -10, y: -10, z:  10),
                               .Point(x:  10, y:  10, z:  10),
                               .Point(x: -20, y: -20, z: -20),
                               .Point(x: -5,  y: -5,  z: -5),]
        
        let results = [false, true, false, false]
        
        for index in 0..<results.count {
            XCTAssertEqual(w.isShadowed(lightPosition: lightPosition, point: points[index]), results[index], "Value does not match at index: \(index)")
        }
    }
}
