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
    
    /*
     
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
    
    func testRayTraceSphere() {
//        # start the ray at z = -5
//        ray_origin ← point(0, 0, -5)
        let rayOrigin = Tuple.Point(x: 0, y: 0, z: -5)
//        # put the wall at z = 10
//        wall_z ← 10
        let wallZ = 10.0
//        wall_size ← 7.0
        let wallSize = 7.0
//        canvas_pixels ← 100
        let canvasSize = 100
//        pixel_size ← wall_size / canvas_pixels
        let pixelSize = wallSize / Double(canvasSize)
//        half ← wall_size / 2
        let half = wallSize / 2.0
//        canvas ← canvas(canvas_pixels, canvas_pixels)
        let canvas = Canvas(width: canvasSize, height: canvasSize)
//        color  ← color(1, 0, 0) # red
        let color = Color(r: 1, g: 0, b: 0)
//        shape  ← sphere()
        let shape = Sphere()
        
        // shape.transform = Matrix4x4.scale(x: 1.0, y: 0.5, z: 1)
        // shape.transform = Matrix4x4.scale(x: 0.5, y: 1.0, z: 1).rotateZ(Double.pi / 4)
        // shape.transform = Matrix4x4.scale(x: 0.5, y: 1, z: 1).shear(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0)
        
//        # for each row of pixels in the canvas
//        for y ← 0 to canvas_pixels - 1
        for y in 0..<canvasSize {
//        # compute the world y coordinate (top = +half, bottom = -half)
//        world_y ← half - pixel_size * y
            let worldY = half - pixelSize * Double(y)
//        # for each pixel in the row
//        for x ← 0 to canvas_pixels - 1
            for x in 0..<canvasSize {
//        # compute the world x coordinate (left = -half, right = half)
//        world_x ← -half + pixel_size * x
                let worldX = -half + pixelSize * Double(x)
//        # describe the point on the wall that the ray will target
//        position ← point(world_x, world_y, wall_z)
                let position = Tuple.Point(x: worldX, y: worldY, z: wallZ)
//        r ← ray(ray_origin, normalize(position - ray_origin))
                let ray = Ray(origin: rayOrigin, direction: (position - rayOrigin).normalize())
//        xs ← intersect(shape, r)
                let xs = shape.intersects(ray: ray)
//        if hit(xs) is defined
                if (Intersection.hit(xs) != nil) {
//        write_pixel(canvas, x, y, color)
                    canvas.setPixel(x: x, y: y, color: color)
                }
            }
        }
        
        let data = canvas.getPPM()
        let filename = getDocumentsDirectory().appendingPathComponent("rayTracingSphere.ppm")
        do {
            try data.write(to: filename)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    */
}
