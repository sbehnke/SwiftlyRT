//
//  BVH.swift
//  RayTracerTest
//
//  Created by Assistant on 9/11/25.
//

import Foundation

/// A simple Bounding Volume Hierarchy over `Shape`s using `BoundingBox`.
/// - Builder: splits on the longest axis using object bounding-box centers.
/// - Traversal: iterative stack; tests node AABBs before intersecting leaves.
struct BVH {
    struct Node {
        var box: BoundingBox
        var left: Int  // < 0 means leaf; otherwise index of left child in `nodes`
        var right: Int // < 0 means leaf; otherwise index of right child in `nodes`
        var start: Int // for leaf: start index into `indices`
        var count: Int // for leaf: number of indices
    }

    /// Flattened node array
    var nodes: [Node] = []
    /// Indices into the original `shapes` array for each leaf range
    var indices: [Int] = []

    init() {}

    /// Build a BVH for the given shapes using their parent-space bounds.
    static func build(for shapes: [Shape]) -> BVH {
        // Gather primitive indices and their world-space bounds and centers
        var prims: [(index: Int, box: BoundingBox, center: Tuple)] = []
        prims.reserveCapacity(shapes.count)
        for (i, s) in shapes.enumerated() {
            let b = s.parentSpaceBounds()
            let cx = (b.minimum.x + b.maximum.x) * 0.5
            let cy = (b.minimum.y + b.maximum.y) * 0.5
            let cz = (b.minimum.z + b.maximum.z) * 0.5
            prims.append((i, b, Tuple.Point(x: cx, y: cy, z: cz)))
        }

        var bvh = BVH()
        bvh.indices = prims.map { $0.index }
        bvh.nodes.reserveCapacity(max(1, shapes.count * 2))

        func computeBounds(_ range: Range<Int>) -> BoundingBox {
            var box = BoundingBox()
            for i in range {
                box.addBox(box: prims[i].box)
            }
            return box
        }

        // Partition by longest axis using median split
        func buildNode(range: Range<Int>) -> Int {
            let nodeIndex = bvh.nodes.count
            // Placeholder node; will fill after recursion/leaf handling
            bvh.nodes.append(BVH.Node(box: BoundingBox(), left: -1, right: -1, start: 0, count: 0))

            let box = computeBounds(range)
            let count = range.count
            if count <= 4 { // make a leaf
                // Copy the corresponding indices into contiguous region (they already are by construction)
                let start = range.lowerBound
                bvh.nodes[nodeIndex] = BVH.Node(box: box, left: -1, right: -1, start: start, count: count)
                return nodeIndex
            }

            // Determine longest axis
            let dx = box.maximum.x - box.minimum.x
            let dy = box.maximum.y - box.minimum.y
            let dz = box.maximum.z - box.minimum.z
            let axis: Int
            if dx >= dy && dx >= dz { axis = 0 }
            else if dy >= dx && dy >= dz { axis = 1 }
            else { axis = 2 }

            // Sort by center on chosen axis within the range, then split at median
            let mid = (range.lowerBound + range.upperBound) / 2
            switch axis {
            case 0:
                prims[range].sort { $0.center.x < $1.center.x }
            case 1:
                prims[range].sort { $0.center.y < $1.center.y }
            default:
                prims[range].sort { $0.center.z < $1.center.z }
            }

            // Also mirror the `indices` array to match `prims` ordering
            for i in range { bvh.indices[i] = prims[i].index }

            let leftIndex = buildNode(range: range.lowerBound..<mid)
            let rightIndex = buildNode(range: mid..<range.upperBound)

            // Update this inner node
            bvh.nodes[nodeIndex] = BVH.Node(box: box, left: leftIndex, right: rightIndex, start: 0, count: 0)
            return nodeIndex
        }

        if !prims.isEmpty {
            _ = buildNode(range: 0..<prims.count)
        } else {
            // Add a dummy empty leaf so traversal works without special cases
            bvh.nodes.append(BVH.Node(box: BoundingBox(), left: -1, right: -1, start: 0, count: 0))
        }

        return bvh
    }

    /// Intersect the BVH and return all intersections with shapes, unsorted.
    func gatherIntersections(ray: Ray, shapes: [Shape]) -> [Intersection] {
        if nodes.isEmpty { return [] }
        var stack: [Int] = [0]
        var hits: [Intersection] = []
        while let nodeIndex = stack.popLast() {
            let node = nodes[nodeIndex]
            if !node.box.intersects(ray: ray) { continue }
            if node.left < 0 && node.right < 0 { // leaf
                if node.count > 0 {
                    let start = node.start
                    let end = start + node.count
                    var i = start
                    while i < end {
                        let shapeIndex = indices[i]
                        hits.append(contentsOf: shapes[shapeIndex].intersects(ray: ray))
                        i += 1
                    }
                }
            } else {
                // push children
                if node.left >= 0 { stack.append(node.left) }
                if node.right >= 0 { stack.append(node.right) }
            }
        }
        return hits
    }

    /// Any-hit traversal for shadow rays. Returns true if any intersection t is in (0, tMax),
    /// and the hit object castsShadow.
    func anyHit(ray: Ray, tMax: Double, shapes: [Shape]) -> Bool {
        if nodes.isEmpty { return false }
        var stack: [Int] = [0]
        while let nodeIndex = stack.popLast() {
            let node = nodes[nodeIndex]
            if !node.box.intersects(ray: ray) { continue }
            if node.left < 0 && node.right < 0 {
                if node.count > 0 {
                    let start = node.start
                    let end = start + node.count
                    var i = start
                    while i < end {
                        let shapeIndex = indices[i]
                        let shape = shapes[shapeIndex]
                        if !shape.castsShadow { i += 1; continue }
                        let xs = shape.intersects(ray: ray)
                        for x in xs {
                            if x.t > 0 && x.t < tMax { return true }
                        }
                        i += 1
                    }
                }
            } else {
                if node.left >= 0 { stack.append(node.left) }
                if node.right >= 0 { stack.append(node.right) }
            }
        }
        return false
    }
}
