//
//  TexturePattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

class TexturePattern: Pattern {

    override func uvPatternAt(u: Double, v: Double) -> Color {
        //        function uv_pattern_at(uv_image, u, v)
        //        # flip v over so it matches the image layout, with y at the top
        //        let v ← 1 - v
        //
        //        let x ← u * (uv_image.canvas.width - 1)
        //        let y ← v * (uv_image.canvas.height - 1)
        //
        //        # be sure and round x and y to the nearest whole number
        //        return pixel_at(uv_image.canvas, round(x), round(y))
        //        end function

        return Color.black
    }
}
