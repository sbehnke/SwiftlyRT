//
//  UVAlignCheck.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/21/19.
//  Copyright © 2019 Luster Images. All rights reserved.
//

import Foundation

class UVAlignCheck: Pattern {
    
    init(main: Color, ul: Color, ur: Color, bl: Color, br: Color) {
        super.init()
        
        self.main = main
        self.ul = ul
        self.ur = ur
        self.bl = bl
        self.br = br
    }
    
    override func uvPatternAt(u: Double, v: Double) -> Color {
        if v > 0.8 {
            if u < 0.2 {
                return ul
            }
            if u > 0.8 {
                return ur
            }
        } else if v < 0.2 {
            if u < 0.2 {
                return bl
            }
            if u > 0.8 {
                return br
            }
        }
        
        return main
    }
    
    var main = Color.white
    var ul = Color.white
    var ur = Color.white
    var bl = Color.white
    var br = Color.white
}

