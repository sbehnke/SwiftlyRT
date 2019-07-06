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

        let hsize = 160
        let vsize = 120
        let fieldOfView = .pi / 2.0
        let c = Camera(w: hsize, h: vsize, fieldOfView: fieldOfView)
        XCTAssertEqual(c.width, hsize)
        XCTAssertEqual(c.height, vsize)
        XCTAssertEqual(c.fieldOfView, .pi/2.0)
        XCTAssertEqual(c.transform, Matrix4x4.identity)
    }
    
    func testHorizontalPixelSize() {
//    Scenario: The pixel size for a horizontal canvas
//    Given c ← camera(200, 125, π/2)
//    Then c.pixel_size = 0.01
        
        let c = Camera(w: 200, h: 125, fieldOfView: .pi/2.0)
        XCTAssertEqual(c.pixelSize, 0.01, accuracy: Tuple.epsilon)
    }
    
    func testVerticalPixelSize() {
//    Scenario: The pixel size for a vertical canvas
//    Given c ← camera(125, 200, π/2)
//    Then c.pixel_size = 0.01

        let c = Camera(w: 125, h: 200, fieldOfView: .pi/2.0)
        XCTAssertEqual(c.pixelSize, 0.01, accuracy: Tuple.epsilon)
    }
    
    func testRayThroughCenterOfCamera() {
//    Scenario: Constructing a ray through the center of the canvas
//    Given c ← camera(201, 101, π/2)
//    When r ← ray_for_pixel(c, 100, 50)
//    Then r.origin = point(0, 0, 0)
//    And r.direction = vector(0, 0, -1)
        
        let c = Camera(w: 201, h: 101, fieldOfView: .pi / 20)
        let r = c.rayForPixel(x: 100, y: 50)
        XCTAssertEqual(r.origin, Tuple.Point(x: 0, y: 0, z: 0))
        XCTAssertEqual(r.direction, Tuple.Vector(x: 0, y: 0, z: -1))
    }
    
    func testRayThroughCornerOfCanvas() {
//    Scenario: Constructing a ray through a corner of the canvas
//    Given c ← camera(201, 101, π/2)
//    When r ← ray_for_pixel(c, 0, 0)
//    Then r.origin = point(0, 0, 0)
//    And r.direction = vector(0.66519, 0.33259, -0.66851)

        let c = Camera(w: 201, h: 101, fieldOfView: .pi / 2)
        let r = c.rayForPixel(x: 0, y: 0)
        XCTAssertEqual(r.origin, Tuple.Point(x: 0, y: 0, z: 0))
        XCTAssertEqual(r.direction, Tuple.Vector(x: 0.66519, y: 0.33259, z: -0.66851))
    }
    
    func testRayWhenCameraIsTranformed() {
//    Scenario: Constructing a ray when the camera is transformed
//    Given c ← camera(201, 101, π/2)
//    When c.transform ← rotation_y(π/4) * translation(0, -2, 5)
//    And r ← ray_for_pixel(c, 100, 50)
//    Then r.origin = point(0, 2, -5)
//    And r.direction = vector(√2/2, 0, -√2/2)

        var c = Camera(w: 201, h: 101, fieldOfView: .pi / 20)
        c.transform = Matrix4x4.rotateY(.pi / 4.0) * Matrix4x4.translate(x: 0, y: -2, z: 5)
        let r = c.rayForPixel(x: 100, y: 50)
        XCTAssertEqual(r.origin, Tuple.Point(x: 0, y: 2, z: -5))
        XCTAssertEqual(r.direction, Tuple.Vector(x: sqrt(2)/2, y: 0, z: -sqrt(2)/2))
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

        let w = World.defaultWorld()
        var c = Camera(w: 11, h: 11, fieldOfView: .pi / 2)
        let from = Tuple.Point(x: 0, y: 0, z: -5)
        let to = Tuple.Point(x: 0, y: 0, z: 0)
        let up = Tuple.Vector(x: 0, y: 1, z: 0)
        c.transform = Matrix4x4.viewTransform(from: from, to: to, up: up)
        let image = c.render(world: w)
        XCTAssertEqual(image.getPixel(x: 5, y: 5), Color(r: 0.38066, g: 0.47583, b: 0.2855))
    }
}
