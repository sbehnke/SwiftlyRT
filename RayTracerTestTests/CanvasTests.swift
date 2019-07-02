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
    

    func testCreateCanvas() {
//    Scenario: Creating a canvas
//    Given c ← canvas(10, 20)
//    Then c.width = 10
//    And c.height = 20
//    And every pixel of c is color(0, 0, 0)
    
        let c = Canvas(width: 10, height: 20)
        XCTAssertEqual(c.width, 10)
        XCTAssertEqual(c.height, 20)
        
        let black = Color(r: 0, g: 0, b: 0)
        for index in 0..<c.count {
            let color = c[index]
            XCTAssertEqual(color, black)
        }
    }

    func testCanvasHeader() {
//
//    Scenario: Constructing the PPM header
//    Given c ← canvas(5, 3)
//    When ppm ← canvas_to_ppm(c)
//    Then lines 1-3 of ppm are
//    """
//    P3
//    5 3
//    255
//    """
        let header = """
P3
5 3
255
"""
     
        let c = Canvas(width: 5, height: 3)

        let ppm = c.getPPM()
        let str = String(data: ppm, encoding: .ascii)
        XCTAssertTrue(str!.starts(with: header))
    }

    
    func testCanvasPixels() {
//        Scenario: Writing pixels to a canvas
//        Given c ← canvas(10, 20)
//        And red ← color(1, 0, 0)
//        When write_pixel(c, 2, 3, red)
//        Then pixel_at(c, 2, 3) = red
//
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
//        Scenario: Constructing the PPM pixel data
//        Given c ← canvas(5, 3)
//        And c1 ← color(1.5, 0, 0)
//        And c2 ← color(0, 0.5, 0)
//        And c3 ← color(-0.5, 0, 1)
//        When write_pixel(c, 0, 0, c1)
//        And write_pixel(c, 2, 1, c2)
//        And write_pixel(c, 4, 2, c3)
//        And ppm ← canvas_to_ppm(c)
//        Then lines 4-6 of ppm are
//        """
//        255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
//        0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
//        0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
//        """
        
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
//        Scenario: Splitting long lines in PPM files
//        Given c ← canvas(10, 2)
//        When every pixel of c is set to color(1, 0.8, 0.6)
//        And ppm ← canvas_to_ppm(c)
//        Then lines 4-7 of ppm are
//        """
//        255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
//        153 255 204 153 255 204 153 255 204 153 255 204 153
//        255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
//        153 255 204 153 255 204 153 255 204 153 255 204 153
//        """
        
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

    func testPPMEndingWithNewLine() {
//    Scenario: PPM files are terminated by a newline character
//    Given c ← canvas(5, 3)
//    When ppm ← canvas_to_ppm(c)
//    Then ppm ends with a newline character

        let c = Canvas(width: 3, height: 5)
        let ppm = c.getPPM()
        let str = String(data: ppm, encoding: .ascii)
        
        XCTAssertEqual(str?.last!, "\n")
        
    }
}
