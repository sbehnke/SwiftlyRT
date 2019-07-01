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
    
    func testClock() {
        let canvas = Canvas(width: 300, height: 300)
        let magnitude = 300.0 * (3.0/8.0)
        
        let midnight = Tuple.Point(x: 0, y: 0, z: 1)
        for hour in 1...12 {
            let rotateY = Matrix4x4.rotateY(Double(hour) * Double.pi / 6)
            let output = rotateY * midnight
            let x = output.x * magnitude + 150
            let y = output.z * magnitude + 150
            canvas.setPixel(x: Int(x), y: Int(y), color: Color.white)
        }
        
        canvas.setPixel(x: 150, y: 150, color: Color(r: 1, g: 0, b: 0))
        
        let data = canvas.getPPM()
        let filename = getDocumentsDirectory().appendingPathComponent("clock.ppm")
        do {
            try data.write(to: filename)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func testProjectile() {
        let start = Tuple.Point(x: 0, y: 1, z: 0)
        let velocity = Tuple.normalize(rhs: Tuple.Vector(x: 1, y: 1.8, z: 0)) * 11.25
        let projectile = Projectile(position: start, velocity: velocity)
        
        let gravity = Tuple.Vector(x: 0, y: -0.1, z: 0)
        let wind = Tuple.Vector(x: -0.01, y: 0, z: 0)
        let environment = Environment(gravity: gravity, wind: wind)
        
        let canvas = Canvas(width: 900, height: 550)
        let red = Color(r: 1, g: 0, b: 0)
        
        while (projectile.position.y >= 0 && Int(projectile.position.y) < canvas.height &&
            projectile.position.x >= 0 && Int(projectile.position.x) < canvas.width) {
                canvas.setPixel(x: Int(projectile.position.x), y: 549 - Int(projectile.position.y), color: red)
                projectile.tick(environment: environment)
        }
        
        let data = canvas.getPPM()
        let filename = getDocumentsDirectory().appendingPathComponent("projectile.ppm")
        do {
            try data.write(to: filename)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
}
