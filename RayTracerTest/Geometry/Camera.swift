//
//  Camera.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct Camera {
    
    private mutating func computePixelSize() {
        halfView = tan(fieldOfView / 2.0)
        let aspect = Double(width) / Double(height)
        
        if (aspect >= 1) {
            halfWidth = halfView
            halfHeight = halfView / aspect
        } else {
            halfWidth = halfView * aspect
            halfHeight = halfView
        }
        
        pixelSize = (halfWidth * 2) / Double(width)
    }
    
    init(w: Int, h: Int, fieldOfView: Double) {
        self.width = w
        self.height = h
        self.fieldOfView = fieldOfView

        computePixelSize()
    }
    
    static func rayForPixel(camera: Camera, x: Int, y: Int) -> Ray {
        let xoffset = (Double(x) + 0.5) * camera.pixelSize
        let yoffset = (Double(y) + 0.5) * camera.pixelSize
        
        let worldX = camera.halfWidth - xoffset
        let worldY = camera.halfHeight - yoffset
        
        let pixel = camera.inverseTransform * Tuple.Point(x: worldX, y: worldY, z: -1)
        let origin = camera.inverseTransform * Tuple.pointZero
        let direction = (pixel - origin).normalied()
        
        return Ray(origin: origin, direction: direction)
    }
    
    func rayForPixel(x: Int, y: Int) -> Ray {
        return Camera.rayForPixel(camera: self, x: x, y: y)
    }
    
    public typealias RenderProgress = (Int, Int) -> Void
    static func render(c: Camera, world: World, progress: RenderProgress? = nil) -> Canvas {
        let image = Canvas(width: c.width, height: c.height)
        
        for y in 0..<c.height {
            for x in 0..<c.width {
                let ray = c.rayForPixel(x: x, y: y)
                let color = world.colorAt(ray: ray)
                image.setPixel(x: x, y: y, color: color)
                progress?(x, y)
            }
        }
        
        return image
    }
    
    public typealias MultiThreadedProgress = (Int, Int, Int) -> Void
    func partialRender(dispatchGroup: DispatchGroup, jobNumber: Int, startingY: Int, endingY: Int, image: Canvas, world: World, progress: MultiThreadedProgress? = nil) {

        let numberOfRows = endingY - startingY
        
        for y in startingY...endingY {
            progress?(jobNumber, y - startingY, numberOfRows)

            for x in 0..<width {
                let ray = rayForPixel(x: x, y: y)
                let color = world.colorAt(ray: ray)
                image.setPixel(x: x, y: y, color: color)
            }
        }
        
        dispatchGroup.leave()
    }
    
//    func multiThreadedRender(world: World, numberOfJobs: Int = 1, progress: MultiThreadedProgress? = nil) -> Canvas {
//        let image = Canvas(width: width, height: height)
//
//        let rows = Array(0..<height)
//        let rowsPerJob = height / numberOfJobs
//        let chunks = rows.chunked(into: rowsPerJob)
//        var jobNumber = 0
//        
//        let dispatchGroup = DispatchGroup()
//        
//        for chunk in chunks {
//            let startingRow = chunk.min()!
//            let endingRow = chunk.max()!
//
//            let j = jobNumber
//            DispatchQueue.global(qos: .background).async {
//                dispatchGroup.enter()
//                self.partialRender(dispatchGroup: dispatchGroup, jobNumber: j, startingY: startingRow, endingY: endingRow, image: image, world: world, progress: progress)
//            }
//            
//            jobNumber += 1
//        }
//        
//        dispatchGroup.wait()
//        return image
//    }
    
    func render(world: World, progress: RenderProgress? = nil) -> Canvas {
        return Camera.render(c: self, world: world, progress: progress)
    }
    
    private(set) var pixelSize = 0.0
    private(set) var width = 0
    private(set) var height = 0
    private(set) var fieldOfView: Double = 0.0
    
    private var halfWidth = 0.0
    private var halfHeight = 0.0
    private var halfView = 0.0
    
    var transform = Matrix4x4.identity {
        didSet {
            inverseTransform = transform.inversed()
        }
    }
    private(set) var inverseTransform = Matrix4x4.identity
}
