//
//  UVCheckers.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/14/19.
//  Copyright © 2019 Luster Images. All rights reserved.
//

import Foundation

class UVCheckers: Pattern {
    
    init(width: Int, height: Int, a: Color, b: Color) {
        super.init()
        
        self.width = width
        self.height = height
        self.a = a
        self.b = b
    }
    
    override func uvPatternAt(u: Double, v: Double) -> Color {
        let u2 = floor(u * Double(width))
        let v2 = floor(v * Double(height))

        if (u2 + v2).remainder(dividingBy: 2.0) == 0.0 {
            return a
        } else {
            return b
        }
    }
    
    var a: Color = Color.white
    var b: Color = Color.white
    var width: Int = 1
    var height: Int = 1
}
