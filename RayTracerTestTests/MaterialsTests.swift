//
//  MaterialsTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

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
        
        XCTFail()
    }
    
    func testTransparencyAndRefractiveIndexForDefaultMaterial() {
//    Scenario: Transparency and Refractive Index for the default material
//    Given m ← material()
//    Then m.transparency = 0.0
//    And m.refractive_index = 1.0
        
        XCTFail()
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
        let result = light.lighting(object: Sphere(), material: m, position: position, eyeVector: eyev, normalVector: normalv)
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
        let result = light.lighting(object: Sphere(), material: m, position: position, eyeVector: eyev, normalVector: normalv)
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
        let result = light.lighting(object: Sphere(), material: m, position: position, eyeVector: eyev, normalVector: normalv)
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
        let result = light.lighting(object: Sphere(), material: m, position: position, eyeVector: eyev, normalVector: normalv)
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
        let result = light.lighting(object: Sphere(), material: m, position: position, eyeVector: eyev, normalVector: normalv)
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
        let result = light.lighting(object: Sphere(), material: m, position: position, eyeVector: eyev, normalVector: normalv, inShadow: inShadow)
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
        let c1 = light.lighting(object: nil, material: m, position: .Point(x: 0.9, y: 0, z: 0), eyeVector: eyev, normalVector: normalv, inShadow: false)
        
        let c2 = light.lighting(object: Sphere(), material: m, position: .Point(x: 1.1, y: 0, z: 0), eyeVector: eyev, normalVector: normalv, inShadow: false)
        
        XCTAssertEqual(c1, Color.white)
        XCTAssertEqual(c2, Color.black)
    }
}
