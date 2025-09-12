#if canImport(XCTest)
import Foundation
import QuartzCore
import XCTest
@testable import SwiftlyRT

final class RayTracerPerformanceTests: XCTestCase {

    // Helper to build a small test world and camera
    private func makeTestWorld(width: Int = 160, height: Int = 120) -> (World, Camera) {
        let w = World.defaultWorld()
        var camera = Camera(w: width, h: height, fieldOfView: 0.5)
        camera.transform = .viewTransformed(
            from: .Point(x: 1, y: 2, z: -5),
            to: .pointZero,
            up: .Vector(x: 0, y: 1, z: 0)
        )
        w.camera = camera
        w.computeBounds()
        return (w, camera)
    }

    /// Measures full-frame render performance and validates basic canvas shape.
    func testFullFrameRenderPerformance() throws {
        let (world, camera) = makeTestWorld()

        // Warm-up & sanity validation (not measured)
        do {
            let canvas = Camera.render(c: camera, world: world, progress: nil)
            XCTAssertEqual(canvas.width, camera.width)
            XCTAssertEqual(canvas.height, camera.height)
            XCTAssertEqual(canvas.count, camera.width * camera.height)
        }

        // Measure the render performance without extra logging or assertions inside the block.
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            _ = Camera.render(c: camera, world: world, progress: nil)
        }
    }

    /// Measures tiled render performance, validates equality with full-frame, and keeps a loose timing check.
    func testTiledRenderEqualsFullFramePerformance() throws {
        let (world, camera) = makeTestWorld()

        // Reference full-frame render and timing (outside measurement)
        let t0 = CACurrentMediaTime()
        let full = Camera.render(c: camera, world: world, progress: nil)
        let fullTime = CACurrentMediaTime() - t0

        let tileSize = 64

        // Warm-up tiled render (not measured)
        do {
            let dest = Canvas(width: camera.width, height: camera.height)
            var y = 0
            while y < camera.height {
                var x = 0
                while x < camera.width {
                    camera.renderTile(into: dest, world: world, startX: x, startY: y, width: tileSize, height: tileSize)
                    x += tileSize
                }
                y += tileSize
            }
        }

        // Measure tiled render performance. Capture the last produced canvas for validation after measurement.
        var lastTiled: Canvas? = nil

        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            let dest = Canvas(width: camera.width, height: camera.height)
            var y = 0
            while y < camera.height {
                var x = 0
                while x < camera.width {
                    camera.renderTile(into: dest, world: world, startX: x, startY: y, width: tileSize, height: tileSize)
                    x += tileSize
                }
                y += tileSize
            }
            lastTiled = dest
        }

        // Validate pixel equality using the last measured iteration output.
        guard let tiled = lastTiled else {
            XCTFail("Tiled render did not produce a canvas")
            return
        }
        XCTAssertEqual(tiled.width, full.width)
        XCTAssertEqual(tiled.height, full.height)
        XCTAssertEqual(tiled.count, full.count)
        for i in 0..<full.count {
            XCTAssertEqual(tiled[i], full[i])
        }

        // Optional loose assertion using manual timing (single run) to ensure tiled isn't dramatically slower.
        // We perform one additional timed tiled render outside measure to obtain a comparable scalar.
        let t1 = CACurrentMediaTime()
        do {
            let dest = Canvas(width: camera.width, height: camera.height)
            var y = 0
            while y < camera.height {
                var x = 0
                while x < camera.width {
                    camera.renderTile(into: dest, world: world, startX: x, startY: y, width: tileSize, height: tileSize)
                    x += tileSize
                }
                y += tileSize
            }
        }
        let tiledTime = CACurrentMediaTime() - t1

        XCTAssertLessThan(tiledTime, fullTime * 2.0, "Tiled render was dramatically slower than full-frame render")
    }
}
#endif
