//
//  Matrix2x2Tests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/30/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class Matrix2x2Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeterminate() {
        let m1 = Matrix2x2(a0: 1, a1: 5,
                           b0: -3, b1: 2)
        
        let determinate = m1.determinate()
        XCTAssertEqual(determinate, 17)
    }
}
