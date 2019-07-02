//
//  CameraTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class CameraTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testCameraConstructor() {
//    Scenario: Constructing a camera
//    Given hsize ← 160
//    And vsize ← 120
//    And field_of_view ← π/2
//    When c ← camera(hsize, vsize, field_of_view)
//    Then c.hsize = 160
//    And c.vsize = 120
//    And c.field_of_view = π/2
//    And c.transform = identity_matrix
        
        XCTFail()
    }
    
    func testHorizontalPixelSize() {
//    Scenario: The pixel size for a horizontal canvas
//    Given c ← camera(200, 125, π/2)
//    Then c.pixel_size = 0.01
        
        XCTFail()
    }
    
    func testVerticalPixelSize() {
//    Scenario: The pixel size for a vertical canvas
//    Given c ← camera(125, 200, π/2)
//    Then c.pixel_size = 0.01
        
        XCTFail()
    }
    
    func testRayThroughCenterOfCamera() {
//    Scenario: Constructing a ray through the center of the canvas
//    Given c ← camera(201, 101, π/2)
//    When r ← ray_for_pixel(c, 100, 50)
//    Then r.origin = point(0, 0, 0)
//    And r.direction = vector(0, 0, -1)
        
        XCTFail()
    }
    
    func testRayThroughCornerOfCanvas() {
//    Scenario: Constructing a ray through a corner of the canvas
//    Given c ← camera(201, 101, π/2)
//    When r ← ray_for_pixel(c, 0, 0)
//    Then r.origin = point(0, 0, 0)
//    And r.direction = vector(0.66519, 0.33259, -0.66851)
        
        XCTFail()
    }
    
    func testRayWhenCameraIsTranformed() {
//    Scenario: Constructing a ray when the camera is transformed
//    Given c ← camera(201, 101, π/2)
//    When c.transform ← rotation_y(π/4) * translation(0, -2, 5)
//    And r ← ray_for_pixel(c, 100, 50)
//    Then r.origin = point(0, 2, -5)
//    And r.direction = vector(√2/2, 0, -√2/2)
        
        XCTFail()
    }
    
    func testRenderingWorldWithCamera() {
//    Scenario: Rendering a world with a camera
//    Given w ← default_world()
//    And c ← camera(11, 11, π/2)
//    And from ← point(0, 0, -5)
//    And to ← point(0, 0, 0)
//    And up ← vector(0, 1, 0)
//    And c.transform ← view_transform(from, to, up)
//    When image ← render(c, w)
//    Then pixel_at(image, 5, 5) = color(0.38066, 0.47583, 0.2855)
    
        XCTFail()
    }
}
