//
//  Group.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation
import OSLog

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let groupLogger = OSLog(subsystem: subsystem, category: "ObjLoader")
}

class Group: Shape {

    func addChildren(_ children: [Shape]) {
        for child in children {
            addChild(child)
        }
    }

    func removeAllChildren() {
        for child in children {
            removeChild(child)
        }
    }

    func removeChild(_ child: Shape) {
        assert(child.parent == self)
        assert(children.contains(child))
        child.parent = nil
        children.remove(at: children.firstIndex(of: child)!)
    }

    func addChild(_ child: Shape) {
        if child.parent != nil {
            child.removeFromParent()
        }

        child.parent = self
        children.append(child)
    }

    var empty: Bool {
        return children.count == 0
    }

    override func localIntersects(ray: Ray) -> [Intersection] {
        var intersections: [Intersection] = []

        let box = boundingBox()
        let intersects = box.intersects(ray: ray)
//        os_log("This object: %public@: %public@", log: OSLog.groupLogger, type: .info, name, intersects.description)

        // TODO: Figure out why this is breaking things.
        if intersects {
            for child in children {
                let xs = child.intersects(ray: ray)
                intersections.append(contentsOf: xs)
            }
        }
        return intersections.sorted()
    }

    override func boundingBox() -> BoundingBox {
        if bounds == nil {
            var box = BoundingBox()
            for child in children {
                box.addBox(box: child.parentSpaceBounds())
            }

            bounds = box
        }

        return bounds!
    }

    override func divide(threshold: Int) {
        if threshold <= children.count {
            let (left, right) = partitionChildren()

            if !left.isEmpty {
                makeSubgroup(children: left)
            }

            if !right.isEmpty {
                makeSubgroup(children: right)
            }
        }

        for child in children {
            child.divide(threshold: threshold)
        }
    }

    func partitionChildren() -> ([Shape], [Shape]) {
        var left: [Shape] = []
        var right: [Shape] = []

        let (boundsLeft, boundsRight) = boundingBox().splitBoundingBox()

        for child in children {
            if boundsLeft.containsBox(box: child.parentSpaceBounds()) {
                child.removeFromParent()
                left.append(child)
            } else if boundsRight.containsBox(box: child.parentSpaceBounds()) {
                child.removeFromParent()
                right.append(child)
            }
        }

        return (left, right)
    }

    override func includes(_ shape: Shape) -> Bool {
        for child in children {
            if child.includes(shape) {
                return true
            }
        }

        return false
    }

    func makeSubgroup(children: [Shape]) {
        let g = Group()
        g.addChildren(children)
        addChild(g)
    }

    func setMaterialAndChildrenMaterial(_ m: Material) {
        material = m

        for child in children {
            child.material = material
        }
    }
}
