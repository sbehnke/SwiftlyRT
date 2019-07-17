//
//  StripePattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/4/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class StripePattern: Pattern {
    
    init(a: Color, b: Color) {
        self.a = a
        self.b = b
    }
    
    override func patternAt(point: Tuple) -> Color {
        if floor(point.x).modulo(2.0) == 0.0 {
            return a
        } else {
            return b
        }
    }
    
    var a = Color.white
    var b = Color.white
}
