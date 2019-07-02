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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultMaterial() {
//    Background:
//    Given m ← material()
//    And position ← point(0, 0, 0)
//
//    Scenario: The default material
//    Given m ← material()
//    Then m.color = color(1, 1, 1)
//    And m.ambient = 0.1
//    And m.diffuse = 0.9
//    And m.specular = 0.9
//    And m.shininess = 200.0
    
        XCTFail()
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
        
        XCTFail()
    }
    
    func testLightBetweenEyeAndSurface() {
//    Scenario: Lighting with the eye between light and surface, eye offset 45°
//    Given eyev ← vector(0, √2/2, -√2/2)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(1.0, 1.0, 1.0)
        
        XCTFail()
    }
    
    func testLightWithEyeOppositeSurface() {
//    Scenario: Lighting with eye opposite surface, light offset 45°
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 10, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(0.7364, 0.7364, 0.7364)
        
        XCTFail()
    }
    
    func testLightWithEyeInPathOfReflectionVector() {
//    Scenario: Lighting with eye in the path of the reflection vector
//    Given eyev ← vector(0, -√2/2, -√2/2)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 10, -10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(1.6364, 1.6364, 1.6364)
        
        XCTFail()
    }

    func testLightingBehindSurface() {
//    Scenario: Lighting with the light behind the surface
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, 10), color(1, 1, 1))
//    When result ← lighting(m, light, position, eyev, normalv)
//    Then result = color(0.1, 0.1, 0.1)
        
        XCTFail()
    }

    func testLightingWithSurfaceInShadow() {
//    Scenario: Lighting with the surface in shadow
//    Given eyev ← vector(0, 0, -1)
//    And normalv ← vector(0, 0, -1)
//    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
//    And in_shadow ← true
//    When result ← lighting(m, light, position, eyev, normalv, in_shadow)
//    Then result = color(0.1, 0.1, 0.1)
        
        XCTFail()
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
        
        XCTFail()
    }
}
