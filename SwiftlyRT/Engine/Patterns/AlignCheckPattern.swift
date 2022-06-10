//
//  AlignCheckPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class AlignCheckPattern: Pattern {

    override func uvPatternAt(u: Double, v: Double) -> Color {
        //        function uv_pattern_at(align_check, u, v)
        //        # remember: v=0 at the bottom, v=1 at the top
        //        if v > 0.8 then
        //        if u < 0.2 then return align_check.ul
        //        if u > 0.8 then return align_check.ur
        //        else if v < 0.2 then
        //        if u < 0.2 then return align_check.bl
        //        if u > 0.8 then return align_check.br
        //        end if
        //
        //        return align_check.main
        //        end function

        return main
    }

    var main = Color()
    var ul = Color()
    var ur = Color()
    var bl = Color()
    var br = Color()
}
