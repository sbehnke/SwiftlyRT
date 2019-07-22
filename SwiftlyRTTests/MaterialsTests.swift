//
//  MaterialsTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import SwiftlyRT

class MaterialsTests: XCTestCase {

    //    Background:
    //    Given m ← material()
    //    And position ← point(0, 0, 0)
    
    var m = Material()
    var position = Tuple.pointZero
    
    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultMaterial() {
//    Scenario: The default material
//    Given m ← material()
//    Then m.color = color(1, 1, 1)
//    And m.ambient = 0.1
//    And m.diffuse = 0.9
//    And m.specular = 0.9
//    And m.shininess = 200.0
    
        XCTAssertEqual(m.color, Color.white)
        XCTAssertEqual(m.ambient, 0.1)
        XCTAssertEqual(m.diffuse, 0.9)
        XCTAssertEqual(m.specular, 0.9)
        XCTAssertEqual(m.shininess, 200.0)
    }
    
    func testDefaultMaterialReflectivity() {
//    Scenario: Reflectivity for the default material
//    Given m ← material()
//    Then m.reflective = 0.0

        let m = Material()
        XCTAssertEqual(m.reflective, 0.0)
    }
    
    func testTransparencyAndRefractiveIndexForDefaultMaterial() {
//    Scenario: Transparency and Refractive Index for the default material
//    Given m ← material()
//    Then m.transparency = 0.0
//    And m.refractive_index = 1.0

        let m = Material()
        XCTAssertEqual(m.transparency, 0.0)
        XCTAssertEqual(m.refractiveIndex, 1.0)
    }
    
    func testLightingWithEyeBetweenLightAndSurface() {
//    Scenario: Lighting with the eye between the light and the surface
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(1.9, 1.9, 1.9)
        
        let eyev = Tuple.Vector(x: 0, y: 0, z: -1)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: Tuple.Point(x: 0, y: 0, z: -10), intensity: Color.white)
        let result = m.lighting(object: Sphere(), light: light, position: position, eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        XCTAssertEqual(result, Color(r: 1.9, g: 1.9, b: 1.9))
    }
    
    func testLightBetweenEyeAndSurface() {
//    Scenario: Lighting with the eye between light and surface, eye offset 45°
//    Given eyev ← vector(0, √2/2, -√2/2)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(1.0, 1.0, 1.0)
        
        let eyev = Tuple.Vector(x: 0, y: sqrt(2.0)/2.0, z: -sqrt(2.0)/2.0)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: Tuple.Point(x: 0, y: 0, z: -10), intensity: Color.white)
        let result = m.lighting(object: Sphere(), light: light, position: position, eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        XCTAssertEqual(result, Color.white)
    }
    
    func testLightWithEyeOppositeSurface() {
//    Scenario: Lighting with eye opposite surface, light offset 45°
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 10, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(0.7364, 0.7364, 0.7364)
        
        let eyev = Tuple.Vector(x: 0, y: 0, z: -1)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: Tuple.Point(x: 0, y: 10, z: -10), intensity: Color.white)
        let result = m.lighting(object: Sphere(), light: light, position: position, eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        XCTAssertEqual(result, Color.init(r: 0.7364, g: 0.7364, b: 0.7364))
    }
    
    func testLightWithEyeInPathOfReflectionVector() {
//    Scenario: Lighting with eye in the path of the reflection vector
//    Given eyev ← vector(0, -√2/2, -√2/2)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 10, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(1.6364, 1.6364, 1.6364)
        
        let eyev = Tuple.Vector(x: 0, y: -sqrt(2.0)/2.0, z: -sqrt(2.0)/2.0)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: Tuple.Point(x: 0, y: 10, z: -10), intensity: Color.white)
        let result = m.lighting(object: Sphere(), light: light, position: position, eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        XCTAssertEqual(result, Color.init(r: 1.6364, g: 1.6364, b: 1.6364))
    }
    
    func testLightingBehindSurface() {
//    Scenario: Lighting with the light behind the surface
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, 10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(0.1, 0.1, 0.1)
        
        let eyev = Tuple.Vector(x: 0, y: 0, z: -1)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: Tuple.Point(x: 0, y: 0, z: 10), intensity: Color.white)
        let result = m.lighting(object: Sphere(), light: light, position: position, eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        XCTAssertEqual(result, Color.init(r: 0.1, g: 0.1, b: 0.1))
    }

    func testLightingWithSurfaceInShadow() {
//    Scenario: Lighting with the surface in shadow
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    And in_shadow ← true
//    When result ← lighting(m, light, position, eyev, normalv, in_shadow)
//    Then result = color(0.1, 0.1, 0.1)

        let eyev = Tuple.Vector(x: 0, y: 0, z: -1)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .Point(x: 0, y: 0, z: -10), intensity: Color(r: 1, g: 1, b: 1))
        let inShadow = true
        let result = m.lighting(object: Sphere(), light: light, position: position, eyeVector: eyev, normalVector: normalv, intensity: 0.0)
        XCTAssertEqual(result, Color(r: 0.1, g: 0.1, b: 0.1))
    }
    
    func testLightingWithPatternApplied() {
//    Scenario: Lighting with a pattern applied
//    Given m.pattern ← stripe_pattern(color(1, 1, 1), color(0, 0, 0))
//    And m.ambient ← 1
//    And m.diffuse ← 0
//    And m.specular ← 0
//    And eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    When c1 ← lighting(m, light, point(0.9, 0, 0), eyev, normalv, false)
//    And c2 ← lighting(m, light, point(1.1, 0, 0), eyev, normalv, false)
//    Then c1 = color(1, 1, 1)
//    And c2 = color(0, 0, 0)

        m.pattern = StripePattern(a: Color.white, b: Color.black)
        m.ambient = 1
        m.diffuse = 0
        m.specular = 0
        let eyev = Tuple.Vector(x: 0, y: 0, z: -1)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .Point(x: 0, y: 0, z: -10), intensity: Color.white)
        
        let c1 = m.lighting(object: Sphere(), light: light, position: .Point(x: 0.9, y: 0, z: 0), eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        let c2 = m.lighting(object: Sphere(), light: light, position: .Point(x: 1.1, y: 0, z: 0), eyeVector: eyev, normalVector: normalv, intensity: 1.0)
        
        XCTAssertEqual(c1, Color.white)
        XCTAssertEqual(c2, Color.black)
    }
    
    func testLightingUsesLightIntensityToAttenuate() {
//        Scenario Outline: lighting() uses light intensity to attenuate color
//        Given w ← default_world()
//        And w.light ← point_light(point(0, 0, -10), color(1, 1, 1))
//        And shape ← the first object in w
//        And shape.material.ambient ← 0.1
//        And shape.material.diffuse ← 0.9
//        And shape.material.specular ← 0
//        And shape.material.color ← color(1, 1, 1)
//        And pt ← point(0, 0, -1)
//        And eyev ← vector(0, 0, -1)
//        And normalv ← vector(0, 0, -1)
//        When result ← lighting(shape.material, w.light, pt, eyev, normalv, <intensity>)
//        Then result = <result>
//
//        Examples:
//        | intensity | result                  |
//        | 1.0       | color(1, 1, 1)          |
//        | 0.5       | color(0.55, 0.55, 0.55) |
//        | 0.0       | color(0.1, 0.1, 0.1)    |
        
        let w = World.defaultWorld()
        w.lights[0] = PointLight(position: .Point(x: 0, y: 0, z: -10), intensity: .white)
        let shape = w.objects.first!
        shape.material.ambient = 0.1
        shape.material.diffuse = 0.9
        shape.material.specular = 0
        shape.material.color = Color.white
        let pt = Tuple.Point(x: 0, y: 0, z: -1)
        let eyev = Tuple.Vector(x: 0, y: 0, z: -1)
        let normalv = Tuple.Vector(x: 0, y: 0, z: -1)
        
        let intensity = [1.0, 0.5, 0.0]
        let colors: [Color] = [Color.white, Color(r: 0.55, g: 0.55, b: 0.55), Color(r: 0.1, g: 0.1, b: 0.1)]
    
    
        for index in 0..<intensity.count {
            let result = shape.material.lighting(object: shape, light: w.lights.first!, position: pt, eyeVector: eyev, normalVector: normalv, intensity: intensity[index])
            XCTAssertEqual(result, colors[index])
        }
    }
    
    func testLightingSamplesAreaLight() {
//        Scenario Outline: lighting() samples the area light
//        Given corner ← point(-0.5, -0.5, -5)
//        And v1 ← vector(1, 0, 0)
//        And v2 ← vector(0, 1, 0)
//        And light ← area_light(corner, v1, 2, v2, 2, color(1, 1, 1))
//        And shape ← sphere()
//        And shape.material.ambient ← 0.1
//        And shape.material.diffuse ← 0.9
//        And shape.material.specular ← 0
//        And shape.material.color ← color(1, 1, 1)
//        And eye ← point(0, 0, -5)
//        And pt ← <point>
//        And eyev ← normalize(eye - pt)
//        And normalv ← vector(pt.x, pt.y, pt.z)
//        When result ← lighting(shape.material, shape, light, pt, eyev, normalv, 1.0)
//        Then result = <result>
//        
//        Examples:
//        | point                      | result                        |
//        | point(0, 0, -1)            | color(0.9965, 0.9965, 0.9965) |
//        | point(0, 0.7071, -0.7071)  | color(0.6232, 0.6232, 0.6232) |
        
        let corner = Tuple.Point(x: -0.5, y: -0.5, z: -5)
        let v1 = Tuple.Vector(x: 1, y: 0, z: 0)
        let v2 = Tuple.Vector(x: 0, y: 1, z: 0)
        let light = AreaLight(corner: corner, uvec: v1, usteps: 2, vvec: v2, vsteps: 2, intensity: .white)
        let shape = Sphere()
        shape.material.ambient = 0.1
        shape.material.diffuse = 0.9
        shape.material.specular = 0
        shape.material.color = .white
        let eye = Tuple.Point(x: 0, y: 0, z: -5)
        
        let points: [Tuple] = [.Point(x: 0, y: 0, z: -1), .Point(x: 0, y: 0.7071, z: -0.7071)]
        let colors: [Color] = [Color(r: 0.9965, g: 0.9965, b: 0.9965), Color(r: 0.6232, g: 0.6232, b: 0.6232),]
        
        for index in 0..<points.count {
            let pt = points[index]
            let eyev = (eye - pt).normalized()
            let normalv = Tuple.Vector(x: pt.x, y: pt.y, z: pt.z)

            let result = shape.material.lighting(object: shape, light: light, position: pt, eyeVector: eyev, normalVector: normalv, intensity: 1.0)
            XCTAssertEqual(result, colors[index], "Color does not match for index: \(index)")
        }
    }
}
