//
//  UVImage.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/21/19.
//  Copyright © 2019 Luster Images. All rights reserved.
//

import Foundation

class UVImage: Pattern {

    init(canvas: Canvas) {
        super.init()

        self.canvas = canvas
    }

    override func uvPatternAt(u: Double, v: Double) -> Color {
        let flippedV = 1 - v

        let xDouble = u * Double((canvas!.width - 1))
        let yDouble = flippedV * Double((canvas!.height - 1))

        let x = Int(xDouble.rounded())
        let y = Int(yDouble.rounded())

        return canvas?.getPixel(x: x, y: y) ?? Color.black
    }

    var canvas: Canvas? = nil
}
