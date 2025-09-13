//
//  Camera.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/3/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

#if canImport(OSLog)
import OSLog

private let cameraLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "SwiftlyRT", category: "Camera")
#endif

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

struct Camera: @unchecked Sendable {

    private mutating func computePixelSize() {
        halfView = tan(fieldOfView / 2.0)
        let aspect = Double(width) / Double(height)

        if aspect >= 1 {
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
        let direction = (pixel - origin).normalized()

        return Ray(origin: origin, direction: direction)
    }

    func rayForPixel(x: Int, y: Int) -> Ray {
        return Camera.rayForPixel(camera: self, x: x, y: y)
    }

    public typealias RenderProgress = (Int, Int) -> Void
    static func render(c: Camera, world: World, progress: RenderProgress? = nil) -> Canvas {

        var camera = c

        if let fromPoint = camera.from,
           let toPoint = camera.to,
           let upVector = camera.up {
            camera.transform = Matrix4x4.viewTransformed(from: fromPoint, to: toPoint, up: upVector)
        }

        let M = camera.inverseTransform
        let C0 = Tuple(x: M[0,0], y: M[1,0], z: M[2,0], w: M[3,0])
        let C1 = Tuple(x: M[0,1], y: M[1,1], z: M[2,1], w: M[3,1])
        let C2 = Tuple(x: M[0,2], y: M[1,2], z: M[2,2], w: M[3,2])
        let C3 = Tuple(x: M[0,3], y: M[1,3], z: M[2,3], w: M[3,3])
        let origin = C3 // since origin = M * (0,0,0,1)

        let image = Canvas(width: camera.width, height: camera.height)
        let progressInterval = max(1, camera.width / 4)

#if canImport(OSLog)
        let spid = OSSignpostID(log: cameraLog)
        os_signpost(.begin, log: cameraLog, name: "RenderFullFrame", signpostID: spid, "w:%{public}d h:%{public}d fov:%{public}.3f", camera.width, camera.height, camera.fieldOfView)
#endif

        // Render using incremental world coordinates and linear indexing
        let tileWidth = camera.width
        for y in 0..<camera.height {
            progress?(0, y)

            let worldY = camera.halfHeight - ((Double(y) + 0.5) * camera.pixelSize)
            var worldX = camera.halfWidth - (0.5 * camera.pixelSize)

            var idx = y * tileWidth
            var x = 0
            while x < camera.width {
                // Build ray directly from worldX/worldY using the inverse transform
                let pixel = (C0 * worldX) + (C1 * worldY) + (C2 * -1.0) + C3
                let direction = (pixel - origin).normalized()
                let ray = Ray(origin: origin, direction: direction)

                let color = world.colorAt(ray: ray)
                image.setPixelUnchecked(linearIndex: idx, color: color)

                if x % progressInterval == 0 { progress?(x, y) }

                worldX -= camera.pixelSize
                idx += 1
                x += 1
            }
        }

#if canImport(OSLog)
        // Signpost: end full-frame render
        os_signpost(.end, log: cameraLog, name: "RenderFullFrame", signpostID: spid)
#endif

        return image
    }

    func render(c: Camera, world: World, startX: Int, startY: Int, width: Int, height: Int) -> Canvas {

        var camera = c

        if let fromPoint = camera.from,
            let toPoint = camera.to,
            let upVector = camera.up
        {
            camera.transform = Matrix4x4.viewTransformed(from: fromPoint, to: toPoint, up: upVector)
        }

        let M = camera.inverseTransform
        let C0 = Tuple(x: M[0,0], y: M[1,0], z: M[2,0], w: M[3,0])
        let C1 = Tuple(x: M[0,1], y: M[1,1], z: M[2,1], w: M[3,1])
        let C2 = Tuple(x: M[0,2], y: M[1,2], z: M[2,2], w: M[3,2])
        let C3 = Tuple(x: M[0,3], y: M[1,3], z: M[2,3], w: M[3,3])
        let origin = C3 // since origin = M * (0,0,0,1)

        let endY = (startY + height) < camera.height ? startY + height : camera.height
        let endX = (startX + width) < camera.width ? startX + width : camera.width
        let tileWidth = endX - startX
        let tileHeight = endY - startY
        let image = Canvas(width: tileWidth, height: tileHeight)

#if canImport(OSLog)
        let tileSpid = OSSignpostID(log: cameraLog)
        os_signpost(.begin, log: cameraLog, name: "RenderTile", signpostID: tileSpid, "x:%{public}d y:%{public}d w:%{public}d h:%{public}d", startX, startY, tileWidth, tileHeight)
#endif

        // Precompute worldY per row and increment worldX per pixel to avoid repeated work
        for y in startY..<endY {
            let worldY = camera.halfHeight - ((Double(y) + 0.5) * camera.pixelSize)
            var worldX = camera.halfWidth - ((Double(startX) + 0.5) * camera.pixelSize)

            // Linear index into tile buffer for this row
            var idx = (y - startY) * tileWidth

            for _ in startX..<endX {
                // Build ray directly from worldX/worldY using the inverse transform
                let pixel = (C0 * worldX) + (C1 * worldY) + (C2 * -1.0) + C3
                let direction = (pixel - origin).normalized()
                let ray = Ray(origin: origin, direction: direction)

                let color = world.colorAt(ray: ray)
                image.setPixelUnchecked(linearIndex: idx, color: color)

                worldX -= camera.pixelSize
                idx += 1
            }
        }

        os_signpost(.end, log: cameraLog, name: "RenderTile", signpostID: tileSpid)

        return image
    }

    /// Renders a tile directly into the destination canvas without intermediate allocations.
    /// The region is clamped to both the camera's bounds and the destination's bounds.
    func renderTile(into dest: Canvas,
                    world: World,
                    startX: Int,
                    startY: Int,
                    width: Int,
                    height: Int) {
        var camera = self

        if let fromPoint = camera.from,
           let toPoint = camera.to,
           let upVector = camera.up {
            camera.transform = Matrix4x4.viewTransformed(from: fromPoint, to: toPoint, up: upVector)
        }

        let M = camera.inverseTransform
        let C0 = Tuple(x: M[0,0], y: M[1,0], z: M[2,0], w: M[3,0])
        let C1 = Tuple(x: M[0,1], y: M[1,1], z: M[2,1], w: M[3,1])
        let C2 = Tuple(x: M[0,2], y: M[1,2], z: M[2,2], w: M[3,2])
        let C3 = Tuple(x: M[0,3], y: M[1,3], z: M[2,3], w: M[3,3])
        let origin = C3 // since origin = M * (0,0,0,1)

        // Clamp extents to camera and destination bounds
        let endY = min(startY + height, min(camera.height, dest.height))
        let endX = min(startX + width, min(camera.width, dest.width))
        if startX >= endX || startY >= endY { return }

        // Precompute per-row worldY and per-pixel worldX increments
        for y in startY..<endY {
            let worldY = camera.halfHeight - ((Double(y) + 0.5) * camera.pixelSize)
            var worldX = camera.halfWidth - ((Double(startX) + 0.5) * camera.pixelSize)

            // Linear index into destination for this row
            var destIdx = y * dest.width + startX

            var x = startX
            while x < endX {
                // Build ray directly from worldX/worldY using the inverse transform
                let pixel = (C0 * worldX) + (C1 * worldY) + (C2 * -1.0) + C3
                let direction = (pixel - origin).normalized()
                let ray = Ray(origin: origin, direction: direction)

                let color = world.colorAt(ray: ray)
                dest.setPixelUnchecked(linearIndex: destIdx, color: color)

                worldX -= camera.pixelSize
                destIdx += 1
                x += 1
            }
        }
    }

    /// Concurrently renders the image in tiles and composites the results into a destination canvas.
    /// Heavy work (ray tracing) is done in parallel per tile; compositing is serialized and fast.
    /// - Parameters:
    ///   - world: The world to render.
    ///   - tileWidth: Tile width (default 64).
    ///   - tileHeight: Tile height (default 64).
    /// - Returns: A fully rendered canvas matching the camera dimensions.
    func renderConcurrent(world: World, tileWidth: Int = 64, tileHeight: Int = 64) async -> Canvas {
        var camera = self

        if let fromPoint = camera.from,
           let toPoint = camera.to,
           let upVector = camera.up {
            camera.transform = Matrix4x4.viewTransformed(from: fromPoint, to: toPoint, up: upVector)
        }

        let dest = Canvas(width: camera.width, height: camera.height)
        let localCamera = camera
        let localWorld = world

        await withTaskGroup(of: (x: Int, y: Int, canvas: Canvas).self) { group in
            var y = 0
            while y < localCamera.height {
                var x = 0
                while x < localCamera.width {
                    let sx = x
                    let sy = y
                    group.addTask { @Sendable in
                        let w = min(tileWidth, localCamera.width - sx)
                        let h = min(tileHeight, localCamera.height - sy)
                        // Reuse existing per-tile renderer that returns a Canvas
                        let tile = localCamera.render(c: localCamera, world: localWorld, startX: sx, startY: sy, width: w, height: h)
                        return (x: sx, y: sy, canvas: tile)
                    }
                    x += tileWidth
                }
                y += tileHeight
            }

            // Composite tiles serially (fast row-wise copy in Canvas.setPixels)
            for await result in group {
                dest.setPixels(source: result.canvas, destX: result.x, destY: result.y)
            }
        }

        return dest
    }

    static func renderSinglePixel(c: Camera, world: World, x: Int, y: Int) -> Color {
        let ray = c.rayForPixel(x: x, y: y)
        return world.colorAt(ray: ray)
    }

    public typealias MultiThreadedProgress = (Int, Int, Int) -> Void
    func partialRender(
        dispatchGroup: DispatchGroup, jobNumber: Int, startingY: Int, endingY: Int, image: Canvas,
        world: World, progress: MultiThreadedProgress? = nil
    ) {

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
    public var width = 0 {
        didSet {
            computePixelSize()
        }
    }

    public var height = 0 {
        didSet {
            computePixelSize()
        }
    }

    public var fieldOfView: Double = 0.0 {
        didSet {
            computePixelSize()
        }
    }

    var to: Tuple? = nil
    var from: Tuple? = nil
    var up: Tuple? = nil

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
