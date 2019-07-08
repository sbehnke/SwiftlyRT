//
//  ObjFileTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import RayTracerTest

class ObjFileTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIgnoringUnrecognizedLines() {
//    Scenario: Ignoring unrecognized lines
//    Given gibberish ← a file containing:
//    """
//    There was a young lady named Bright
//    who traveled much faster than light.
//    She set out one day
//    in a relative way,
//    and came back the previous night.
//    """
//    When parser ← parse_obj_file(gibberish)
//    Then parser should have ignored 5 lines

        let gibberish = """
There was a young lady named Bright
who traveled much faster than light.
She set out one day
in a relative way,
and came back the previous night.
"""
        let parser = ObjParser.parse(objFileData: gibberish)
        XCTAssertEqual(parser.ignoredLineCount, 5)
    }
    
    func testVertexRecords() {
//    Scenario: Vertex records
//    Given file ← a file containing:
//    """
//    v -1 1 0
//    v -1.0000 0.5000 0.0000
//    v 1 0 0
//    v 1 1 0
//    """
//    When parser ← parse_obj_file(file)
//    Then parser.vertices[1] = point(-1, 1, 0)
//    And parser.vertices[2] = point(-1, 0.5, 0)
//    And parser.vertices[3] = point(1, 0, 0)
//    And parser.vertices[4] = point(1, 1, 0)

        let file = """
v -1 1 0
v -1.0000 0.5000 0.0000
v 1 0 0
v 1 1 0
"""
        let parser = ObjParser.parse(objFileData: file)
        XCTAssertEqual(parser.ignoredLineCount, 0)
        XCTAssertEqual(parser.vertices.count, 4)
        XCTAssertEqual(parser.vertices[1], Tuple.Point(x: -1, y: 1, z: 0))
        XCTAssertEqual(parser.vertices[2], Tuple.Point(x: -1, y: 0.5, z: 0))
        XCTAssertEqual(parser.vertices[3], Tuple.Point(x: 1, y: 0, z: 0))
        XCTAssertEqual(parser.vertices[4], Tuple.Point(x: 1, y: 1, z: 0))
    }
    
    func testParsingTriangleFaces() {
//    Scenario: Parsing triangle faces
//    Given file ← a file containing:
//    """
//    v -1 1 0
//    v -1 0 0
//    v 1 0 0
//    v 1 1 0
//
//    f 1 2 3
//    f 1 3 4
//    """
//    When parser ← parse_obj_file(file)
//    And g ← parser.default_group
//    And t1 ← first child of g
//    And t2 ← second child of g
//    Then t1.p1 = parser.vertices[1]
//    And t1.p2 = parser.vertices[2]
//    And t1.p3 = parser.vertices[3]
//    And t2.p1 = parser.vertices[1]
//    And t2.p2 = parser.vertices[3]
//    And t2.p3 = parser.vertices[4]
        
        let file =
"""
v -1 1 0
v -1 0 0
v 1 0 0
v 1 1 0

f 1 2 3
f 1 3 4
"""
        let parser = ObjParser.parse(objFileData: file)
        let g = parser.defaultGroup
        XCTAssertEqual(2, g.children.count)
        let t1 = g.children[0] as! Triangle
        let t2 = g.children[1] as! Triangle
        
        XCTAssertEqual(t1.p1, parser.vertices[1])
        XCTAssertEqual(t1.p2, parser.vertices[2])
        XCTAssertEqual(t1.p3, parser.vertices[3])
        XCTAssertEqual(t2.p1, parser.vertices[1])
        XCTAssertEqual(t2.p2, parser.vertices[3])
        XCTAssertEqual(t2.p3, parser.vertices[4])
    }
    
    func testTriangulatingPolygons() {
//    Scenario: Triangulating polygons
//    Given file ← a file containing:
//    """
//    v -1 1 0
//    v -1 0 0
//    v 1 0 0
//    v 1 1 0
//    v 0 2 0
//
//    f 1 2 3 4 5
//    """
//    When parser ← parse_obj_file(file)
//    And g ← parser.default_group
//    And t1 ← first child of g
//    And t2 ← second child of g
//    And t3 ← third child of g
//    Then t1.p1 = parser.vertices[1]
//    And t1.p2 = parser.vertices[2]
//    And t1.p3 = parser.vertices[3]
//    And t2.p1 = parser.vertices[1]
//    And t2.p2 = parser.vertices[3]
//    And t2.p3 = parser.vertices[4]
//    And t3.p1 = parser.vertices[1]
//    And t3.p2 = parser.vertices[4]
//    And t3.p3 = parser.vertices[5]
        
        let file =
        """
v -1 1 0
v -1 0 0
v 1 0 0
v 1 1 0
v 0 2 0

f 1 2 3 4 5
"""
        let parser = ObjParser.parse(objFileData: file)
        let g = parser.defaultGroup
        XCTAssertEqual(3, g.children.count)
        let t1 = g.children[0] as! Triangle
        let t2 = g.children[1] as! Triangle
        let t3 = g.children[2] as! Triangle
        
        XCTAssertEqual(t1.p1, parser.vertices[1])
        XCTAssertEqual(t1.p2, parser.vertices[2])
        XCTAssertEqual(t1.p3, parser.vertices[3])
        XCTAssertEqual(t2.p1, parser.vertices[1])
        XCTAssertEqual(t2.p2, parser.vertices[3])
        XCTAssertEqual(t2.p3, parser.vertices[4])
        XCTAssertEqual(t3.p1, parser.vertices[1])
        XCTAssertEqual(t3.p2, parser.vertices[4])
        XCTAssertEqual(t3.p3, parser.vertices[5])
    }
    
    func testTrianglesInGroups() {
//    Scenario: Triangles in groups
//    Given file ← the file "triangles.obj"
//    When parser ← parse_obj_file(file)
//    And g1 ← "FirstGroup" from parser
//    And g2 ← "SecondGroup" from parser
//    And t1 ← first child of g1
//    And t2 ← first child of g2
//    Then t1.p1 = parser.vertices[1]
//    And t1.p2 = parser.vertices[2]
//    And t1.p3 = parser.vertices[3]
//    And t2.p1 = parser.vertices[1]
//    And t2.p2 = parser.vertices[3]
//    And t2.p3 = parser.vertices[4]

        let bundle = Bundle(for: RayTracerTestTests.self)
        let url = bundle.url(forResource: "triangles", withExtension: "obj")
        let parser = ObjParser.parse(objFilePath: url)
        let g1 = parser.groups["FirstGroup"]!
        let g2 = parser.groups["SecondGroup"]!
        let t1 = g1.children[0] as! Triangle
        let t2 = g2.children[0] as! Triangle
        XCTAssertEqual(t1.p1, parser.vertices[1])
        XCTAssertEqual(t1.p2, parser.vertices[2])
        XCTAssertEqual(t1.p3, parser.vertices[3])
        XCTAssertEqual(t2.p1, parser.vertices[1])
        XCTAssertEqual(t2.p2, parser.vertices[3])
        XCTAssertEqual(t2.p3, parser.vertices[4])
    }
        
    func testConvertingOBJToGroup() {
//    Scenario: Converting an OBJ file to a group
//    Given file ← the file "triangles.obj"
//    And parser ← parse_obj_file(file)
//    When g ← obj_to_group(parser)
//    Then g includes "FirstGroup" from parser
//    And g includes "SecondGroup" from parser
    
        let bundle = Bundle(for: RayTracerTestTests.self)
        let url = bundle.url(forResource: "triangles", withExtension: "obj")
        let parser = ObjParser.parse(objFilePath: url)
        let g = parser.toGroup()
        
        XCTAssertTrue(g.children.contains(parser.groups["FirstGroup"]!))
        XCTAssertTrue(g.children.contains(parser.groups["SecondGroup"]!))
    }
        
    func testVertexNormalRecords() {
//    Scenario: Vertex normal records
//    Given file ← a file containing:
//    """
//    vn 0 0 1
//    vn 0.707 0 -0.707
//    vn 1 2 3
//    """
//    When parser ← parse_obj_file(file)
//    Then parser.normals[1] = vector(0, 0, 1)
//    And parser.normals[2] = vector(0.707, 0, -0.707)
//    And parser.normals[3] = vector(1, 2, 3)
    
        let file = """
vn 0 0 1
vn 0.707 0 -0.707
vn 1 2 3
"""
        let parser = ObjParser.parse(objFileData: file)
        XCTAssertEqual(parser.normals[1], Tuple.Vector(x: 0, y: 0, z: 1))
        XCTAssertEqual(parser.normals[2], Tuple.Vector(x: 0.707, y: 0, z: -0.707))
        XCTAssertEqual(parser.normals[3], Tuple.Vector(x: 1, y: 2, z: 3))
    }
        
    func testFacesWithNormals() {
//    Scenario: Faces with normals
//    Given file ← a file containing:
//    """
//    v 0 1 0
//    v -1 0 0
//    v 1 0 0
//    
//    vn -1 0 0
//    vn 1 0 0
//    vn 0 1 0
//    
//    f 1//3 2//1 3//2
//    f 1/0/3 2/102/1 3/14/2
//    """
//    When parser ← parse_obj_file(file)
//    And g ← parser.default_group
//    And t1 ← first child of g
//    And t2 ← second child of g
//    Then t1.p1 = parser.vertices[1]
//    And t1.p2 = parser.vertices[2]
//    And t1.p3 = parser.vertices[3]
//    And t1.n1 = parser.normals[3]
//    And t1.n2 = parser.normals[1]
//    And t1.n3 = parser.normals[2]
//    And t2 = t1

        let file = """
v 0 1 0
v -1 0 0
v 1 0 0

vn -1 0 0
vn 1 0 0
vn 0 1 0

f 1//3 2//1 3//2
f 1/0/3 2/102/1 3/14/2
"""
        let parser = ObjParser.parse(objFileData: file)
        XCTAssertEqual(parser.defaultGroup.children.count, 2)
        
        if parser.defaultGroup.children[0] is SmoothTriangle {
            let t1 = parser.defaultGroup.children[0] as! SmoothTriangle
            XCTAssertEqual(t1.p1, parser.vertices[1])
            XCTAssertEqual(t1.p2, parser.vertices[2])
            XCTAssertEqual(t1.p3, parser.vertices[3])
            XCTAssertEqual(t1.n1, parser.normals[3])
            XCTAssertEqual(t1.n2, parser.normals[1])
            XCTAssertEqual(t1.n3, parser.normals[2])
            
            if parser.defaultGroup.children[1] is SmoothTriangle {
                let t2 = parser.defaultGroup.children[1] as! SmoothTriangle
                XCTAssertTrue(SmoothTriangle.equals(lhs: t1, rhs: t2))
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testObjFileDivideSpeed() {
        self.measure() {
            let bundle = Bundle(for: RayTracerTestTests.self)
            let url = bundle.url(forResource: "cube", withExtension: "obj")
            let parser = ObjParser.parse(objFilePath: url)
            let g = parser.toGroup()
            g.divide(threshold: 1)
        }
    }
}
