//
//  LightsTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import SwiftlyRT

class LightsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPointLight() {
//        Scenario: A point light has a position and intensity
//        Given intensity ← color(1, 1, 1)
//        And position ← point(0, 0, 0)
//        When light ← point_light(position, intensity)
//        Then light.position = position
//        And light.intensity = intensity

        let intensity = Color(r: 1, g: 1, b: 1)
        let position = Tuple.Point(x: 0, y: 0, z: 0)
        let light = PointLight(position: position, intensity: intensity)
        XCTAssertEqual(light.position, position)
        XCTAssertEqual(light.intensity, intensity)
    }
    
    func testPointLightsEvaluateLightIntensity() {
//        Scenario Outline: Point lights evaluate the light intensity at a given point
//        Given w ← default_world()
//        And light ← w.light
//        And pt ← <point>
//        When intensity ← intensity_at(light, pt, w)
//        Then intensity = <result>
//        
//        Examples:
//        | point                | result |
//        | point(0, 1.0001, 0)  | 1.0    |
//        | point(-1.0001, 0, 0) | 1.0    |
//        | point(0, 0, -1.0001) | 1.0    |
//        | point(0, 0, 1.0001)  | 0.0    |
//        | point(1.0001, 0, 0)  | 0.0    |
//        | point(0, -1.0001, 0) | 0.0    |
//        | point(0, 0, 0)       | 0.0    |
     
        let w = World.defaultWorld()
        let light = w.lights.first!
        
        let results = [1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
        
        let points: [Tuple] = [.Point(x: 0,      y: 1.0001,  z: 0),
                               .Point(x:-1.0001, y: 0,       z: 0),
                               .Point(x: 0,      y: 0,       z: -1.0001),
                               .Point(x: 0,      y: 0,       z: 1.0001),
                               .Point(x: 1.0001, y: 0,       z: 0),
                               .Point(x: 0,      y: -1.0001, z: 0),
                               .Point(x: 0,      y: 0,       z: 0),]
        
        for index in 0..<results.count {
            XCTAssertEqual(results[index], light.intensityAt(point: points[index], world: w), "Intensity does not match at index: \(index)")
        }
    }
    
    func testCreatingAreaLight() {
//        Scenario: Creating an area light
//        Given corner ← point(0, 0, 0)
//        And v1 ← vector(2, 0, 0)
//        And v2 ← vector(0, 0, 1)
//        When light ← area_light(corner, v1, 4, v2, 2, color(1, 1, 1))
//        Then light.corner = corner
//        And light.uvec = vector(0.5, 0, 0)
//        And light.usteps = 4
//        And light.vvec = vector(0, 0, 0.5)
//        And light.vsteps = 2
//        And light.samples = 8
//        And light.position = point(1, 0, 0.5)

        let corner = Tuple.pointZero
        let v1 = Tuple.Vector(x: 2, y: 0, z: 0)
        let v2 = Tuple.Vector(x: 0, y: 0, z: 1)
        let light = AreaLight(corner: corner, uvec: v1, usteps: 4, vvec: v2, vsteps: 2, intensity: .white)
        XCTAssertEqual(light.corner, corner)
        XCTAssertEqual(light.uvec, Tuple.Vector(x: 0.5, y: 0, z: 0))
        XCTAssertEqual(light.usteps, 4)
        XCTAssertEqual(light.vvec, Tuple.Vector(x: 0, y: 0, z: 0.5))
        XCTAssertEqual(light.vsteps, 2)
        XCTAssertEqual(light.samples, 8)
        XCTAssertEqual(light.position, Tuple.Point(x: 1, y: 0, z: 0.5))
    }
    
    func testFindingSinglePointOnAreaLight() {
//        Scenario Outline: Finding a single point on an area light
//        Given corner ← point(0, 0, 0)
//        And v1 ← vector(2, 0, 0)
//        And v2 ← vector(0, 0, 1)
//        And light ← area_light(corner, v1, 4, v2, 2, color(1, 1, 1))
//        When pt ← point_on_light(light, <u>, <v>)
//        Then pt = <result>
//
//        Examples:
//        | u | v | result               |
//        | 0 | 0 | point(0.25, 0, 0.25) |
//        | 1 | 0 | point(0.75, 0, 0.25) |
//        | 0 | 1 | point(0.25, 0, 0.75) |
//        | 2 | 0 | point(1.25, 0, 0.25) |
//        | 3 | 1 | point(1.75, 0, 0.75) |
        
        let u: [Double] = [0, 1, 0, 2, 3]
        let v: [Double] = [0, 0, 1, 0, 1]
        let points: [Tuple] = [.Point(x: 0.25, y: 0, z: 0.25),
                               .Point(x: 0.75, y: 0, z: 0.25),
                               .Point(x: 0.25, y: 0, z: 0.75),
                               .Point(x: 1.25, y: 0, z: 0.25),
                               .Point(x: 1.75, y: 0, z: 0.75),]
        
        let corner = Tuple.Point(x: 0, y: 0, z: 0)
        let v1 = Tuple.Vector(x: 2, y: 0, z: 0)
        let v2 = Tuple.Vector(x: 0, y: 0, z: 1)
        let light = AreaLight(corner: corner, uvec: v1, usteps: 4, vvec: v2, vsteps: 2, intensity: .white)
        
        for index in 0..<points.count {
            let pt = light.pointOnLight(u: u[index], v: v[index])
            XCTAssertEqual(pt, points[index], "Point does not match for index: \(index)")
        }
    }
    
    func testAreaLightIntensityFunction() {
//        Scenario Outline: The area light intensity function
//        Given w ← default_world()
//        And corner ← point(-0.5, -0.5, -5)
//        And v1 ← vector(1, 0, 0)
//        And v2 ← vector(0, 1, 0)
//        And light ← area_light(corner, v1, 2, v2, 2, color(1, 1, 1))
//        And pt ← <point>
//        When intensity ← intensity_at(light, pt, w)
//        Then intensity = <result>
//        
//        Examples:
//        | point                | result |
//        | point(0, 0, 2)       | 0.0    |
//        | point(1, -1, 2)      | 0.25   |
//        | point(1.5, 0, 2)     | 0.5    |
//        | point(1.25, 1.25, 3) | 0.75   |
//        | point(0, 0, -2)      | 1.0    |

        let w = World.defaultWorld()
        let corner = Tuple.Point(x: -0.5, y: -0.5, z: -5)
        let v1 = Tuple.Vector(x: 1, y: 0, z: 0)
        let v2 = Tuple.Vector(x: 0, y: 1, z: 0)
        let light = AreaLight(corner: corner, uvec: v1, usteps: 2, vvec: v2, vsteps: 2, intensity: .white)
        
        let results = [0.0, 0.25, 0.5, 0.75, 1.0]
        let points: [Tuple] = [.Point(x: 0,    y: 0,    z: 2),
                               .Point(x: 1,    y: -1,   z: 2),
                               .Point(x: 1.5,  y: 0,    z: 2),
                               .Point(x: 1.25, y: 1.25, z: 3),
                               .Point(x: 0,    y: 0,    z: -2),]
        
        for index in 0..<results.count {
            let result = light.intensityAt(point: points[index], world: w)
            XCTAssertEqual(results[index], result, "Intensity does not match at index: \(index)")
        }
    }
    
    func testFindingSinglePointOnJitteredAreaLight() {
//        Scenario Outline: Finding a single point on a jittered area light
//        Given corner ← point(0, 0, 0)
//        And v1 ← vector(2, 0, 0)
//        And v2 ← vector(0, 0, 1)
//        And light ← area_light(corner, v1, 4, v2, 2, color(1, 1, 1))
//        And light.jitter_by ← sequence(0.3, 0.7)
//        When pt ← point_on_light(light, <u>, <v>)
//        Then pt = <result>
//
//        Examples:
//        | u | v | result               |
//        | 0 | 0 | point(0.15, 0, 0.35) |
//        | 1 | 0 | point(0.65, 0, 0.35) |
//        | 0 | 1 | point(0.15, 0, 0.85) |
//        | 2 | 0 | point(1.15, 0, 0.35) |
//        | 3 | 1 | point(1.65, 0, 0.85) |

        let corner = Tuple.Point(x: 0, y: 0, z: 0)
        let v1 = Tuple.Vector(x: 2, y: 0, z: 0)
        let v2 = Tuple.Vector(x: 0, y: 0, z: 1)
        var light = AreaLight(corner: corner, uvec: v1, usteps: 4, vvec: v2, vsteps: 2, intensity: .white)
        light.jitterBy = CyclicSequence([0.3, 0.7])
        
        let u: [Double] = [0, 1, 0, 2, 3]
        let v: [Double] = [0, 0, 1, 0, 1]
        
        let points: [Tuple] = [.Point(x: 0.15, y: 0, z: 0.35),
                               .Point(x: 0.65, y: 0, z: 0.35),
                               .Point(x: 0.15, y: 0, z: 0.85),
                               .Point(x: 1.15, y: 0, z: 0.35),
                               .Point(x: 1.65, y: 0, z: 0.85),]
        
        for index in 0..<points.count {
            let pt = light.pointOnLight(u: u[index], v: v[index])
            XCTAssertEqual(pt, points[index])
        }
    }
    
    func testAreaLightWithJitteredSamples() {
//        Scenario Outline: The area light with jittered samples
//        Given w ← default_world()
//        And corner ← point(-0.5, -0.5, -5)
//        And v1 ← vector(1, 0, 0)
//        And v2 ← vector(0, 1, 0)
//        And light ← area_light(corner, v1, 2, v2, 2, color(1, 1, 1))
//        And light.jitter_by ← sequence(0.7, 0.3, 0.9, 0.1, 0.5)
//        And pt ← <point>
//        When intensity ← intensity_at(light, pt, w)
//        Then intensity = <result>
//        
//        Examples:
//        | point                | result |
//        | point(0, 0, 2)       | 0.0    |
//        | point(1, -1, 2)      | 0.5    |
//        | point(1.5, 0, 2)     | 0.75   |
//        | point(1.25, 1.25, 3) | 0.75   |
//        | point(0, 0, -2)      | 1.0    |

        let w = World.defaultWorld()
        let corner = Tuple.Point(x: -0.5, y: -0.5, z: -5)
        let v1 = Tuple.Vector(x: 1, y: 0, z: 0)
        let v2 = Tuple.Vector(x: 0, y: 1, z: 0)
        var light = AreaLight(corner: corner, uvec: v1, usteps: 2, vvec: v2, vsteps: 2, intensity: .white)
        light.jitterBy = CyclicSequence([0.7, 0.3, 0.9, 0.1, 0.5])
        
        let points: [Tuple] = [.Point(x: 0,    y: 0,    z: 2),
                               .Point(x: 1,    y: -1,   z: 2),
                               .Point(x: 1.5,  y: 0,    z: 2),
                               .Point(x: 1.25, y: 1.25, z: 3),
                               .Point(x: 0,    y: 0,    z: -2),]
        
        let results = [0.0, 0.5, 0.75, 0.75, 1.0]
        

        for index in 0..<results.count {
            let intensity = light.intensityAt(point: points[index], world: w)
            XCTAssertEqual(results[index], intensity, accuracy: Tuple.epsilon, "Intensity does not match for index: \(index)")
        }
    }
}
