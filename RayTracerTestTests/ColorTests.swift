//
//  ColorTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class ColorTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testColorMultiplication() {
        let c1 = Color(r: 1, g: 0.2, b: 0.4)
        let c2 = Color(r: 0.9, g: 1.0, b: 0.1)
        XCTAssertEqual(c1 * c2, Color(r: 0.9, g: 0.2, b: 0.04))
    }
    
}
