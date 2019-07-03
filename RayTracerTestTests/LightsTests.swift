//
//  LightsTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

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
}
