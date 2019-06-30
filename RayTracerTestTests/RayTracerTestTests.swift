//
//  RayTracerTestTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import XCTest
@testable import RayTracerTest

class RayTracerTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    func testProjectile() {
//        
////        let p = Projectile(position: Point(x: 0, y: 1, z: 0), velocity: Vector.normalize(rhs: Vector(x: 1, y: 1, z: 0)))
////        let environment = Environment(gravity: Vector(x: 0, y: -0.1, z: 0, w: 1.0), wind: Vector(x: -0.01, y: 0, z: 0, w: 1.0))
////
////        while (p.position.y > 0) {
////            p.tick(environment: environment)
////            print("(\(p.position.x), \(p.position.y))")
////        }
//        
//        let start = Point(x: 0, y: 1, z: 0, w: 0)
//        let velocity = Vector4.normalize(rhs: Vector4(x: 1, y: 1.8, z: 0, w: 0.0)) * 11.25
//        let projectile = Projectile(position: start, velocity: velocity)
//        
//        let gravity = Vector4(x: 0, y: -0.1, z: 0, w: 1.0)
//        let wind = Vector4(x: -0.01, y: 0, z: 0, w: 1.0)
//        let environment = Environment(gravity: gravity, wind: wind)
//        
//        let canvas = Canvas(width: 900, height: 550)
//        let red = Color(r: 1, g: 0, b: 0)
//        
//        while (projectile.position.y >= 0 && Int(projectile.position.y) < canvas.height &&
//            projectile.position.x >= 0 && Int(projectile.position.x) < canvas.width) {
//                canvas.setPixel(x: Int(projectile.position.x), y: 549 - Int(projectile.position.y), color: red)
//                projectile.tick(environment: environment)
//        }
//        
//        let data = canvas.getPPM()
//        let filename = getDocumentsDirectory().appendingPathComponent("projectile.ppm")
//        do {
//            try data.write(to: filename)
//        } catch {
//            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//        }
//    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
