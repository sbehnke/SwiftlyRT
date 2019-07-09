//
//  CSG.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/6/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

enum GeometryOperation {
    case union
    case intersection
    case difference
}

class CSG : Group {
    
    static func union(left: Shape, right: Shape) -> CSG {
        return CSG(oper: GeometryOperation.union, left: left, right: right)
    }
    
    static func intersection(left: Shape, right: Shape) -> CSG {
        return CSG(oper: GeometryOperation.intersection, left: left, right: right)
    }

    static func difference(left: Shape, right: Shape) -> CSG {
        return CSG(oper: GeometryOperation.difference, left: left, right: right)
    }
    
    static func intersectionAllowed(op: GeometryOperation, lhit: Bool, inl: Bool, inr: Bool) -> Bool {
        switch op {
        case .union:            
            return (lhit && !inr) || (!lhit && !inl)
            
        case .intersection:
            return (lhit && inr) || (!lhit && inl)
            
        case .difference:
            return (lhit && !inr) || (!lhit && inl)
        }
    }
    
    func filterIntersections(_ xs: [Intersection]) -> [Intersection] {
        var intersections: [Intersection] = []
        
        var inl = false
        var inr = false
        
        for i in xs {
            assert(i.object != nil)
            let lhit = left.includes(i.object!)
            
            if CSG.intersectionAllowed(op: oper, lhit: lhit, inl: inl, inr: inr) {
                intersections.append(i)
            }
            
            if lhit {
                inl = !inl
            } else {
                inr = !inr
            }
        }
        
        return intersections.sorted()
    }
    
    init(oper: GeometryOperation, left: Shape, right: Shape) {
        super.init()
        
        self.oper = oper
        self.left = left
        self.left.parent = self
        self.right = right
        self.right.parent = self
    }
    
    override func includes(_ shape: Shape) -> Bool {
        if (left.includes(shape)) {
            return true
        }
        
        if (right.includes(shape)) {
            return true
        }
        
        return false
    }
    
    override func localIntersects(ray: Ray) -> [Intersection] {
        let box = boundingBox()
        let intersects = box.intersects(ray: ray)
        if !intersects {
            return []
        }
        
        var combined: [Intersection] = []
        
        combined.append(contentsOf: left.intersects(ray: ray))
        combined.append(contentsOf: right.intersects(ray: ray))
        combined.sort()
        
        return filterIntersections(combined)
    }
    
    override func divide(threshold: Int) {
        left.divide(threshold: threshold)
        right.divide(threshold: threshold)
    }
    
    override func boundingBox() -> BoundingBox {
        if bounds == nil {
            var box = BoundingBox()
            box.addBox(box: left.parentSpaceBounds())
            box.addBox(box: right.parentSpaceBounds())
            bounds = box
        }
        
        return bounds!
    }
    
    var oper: GeometryOperation = GeometryOperation.union
    var left = Shape()
    var right = Shape()
}

