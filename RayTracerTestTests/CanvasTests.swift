//
//  CanvasTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class CavnasTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanvasPixels() {
        let x = 2
        let y = 3
        let red = Color(r: 1, g: 0, b: 0)
        let canvas = Canvas(width: 10, height: 20)
        canvas.setPixel(x: x, y: y, color: red)
        XCTAssertEqual(red, canvas.getPixel(x: x, y: y))
    }
    
    func testRowColumn() {
        let canvas = Canvas(width: 2, height: 2)
        canvas.setPixel(x: 0, y: 0, color: Color(r: 0, g: 0, b: 0))
        canvas.setPixel(x: 1, y: 0, color: Color(r: 0, g: 1, b: 0))
        canvas.setPixel(x: 0, y: 1, color: Color(r: 0, g: 0, b: 1))
        canvas.setPixel(x: 1, y: 1, color: Color(r: 0, g: 1, b: 1))
    }
    
    func testPPMFormat() {
        
        let c = Canvas(width: 5, height: 3)
        let c1 = Color(r: 1.5, g: 0, b: 0)
        let c2 = Color(r: 0, g: 0.5, b: 0)
        let c3 = Color(r: -0.5, g: 0, b: 1)
        
        c.setPixel(x: 0, y: 0, color: c1)
        c.setPixel(x: 2, y: 1, color: c2)
        c.setPixel(x: 4, y: 2, color: c3)
        
        let output = String("""
P3
5 3
255
255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 255

""")
        let ppm = c.getPPM()
        let ppmString = String(bytes: ppm, encoding: .ascii)
        XCTAssertEqual(ppmString, output)
    }
    
    func testPPMLineWrap() {
        let c = Canvas(width: 10, height: 2)
        for x in 0..<c.width {
            for y in 0..<c.height {
                c.setPixel(x: x, y: y, color: Color(r: 1, g: 0.8, b: 0.6))
            }
        }
        
        let output = """
P3
10 2
255
255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
153 255 204 153 255 204 153 255 204 153 255 204 153
255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
153 255 204 153 255 204 153 255 204 153 255 204 153

"""
        let ppm = String(bytes: c.getPPM(), encoding: .ascii)!
        let size1 = ppm.count
        let size2 = output.count
        print(size1)
        print(size2)
        XCTAssertEqual(output, ppm)
    }
}
