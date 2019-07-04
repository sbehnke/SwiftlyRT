//
//  Pattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class Pattern: Equatable {
    static func == (lhs: Pattern, rhs: Pattern) -> Bool {
        return lhs === rhs
    }
    
    func patternAt(point: Tuple) -> Color {
        return point.toColor()
    }
    
    func patternAtShape(object: Shape?, point: Tuple) -> Color {
        var t = self.transform.invert()
        if object != nil {
            t *= object!.transform.invert()
        }        
        let transformedPoint = t * point
        return patternAt(point: transformedPoint)
    }
    
    var transform = Matrix4x4.identity
}
