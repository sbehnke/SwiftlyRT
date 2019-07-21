//
//  TextureMapPattern.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

enum Mapping: String {
    case Spherical = "spherical"
    case Planar = "planar"
    case Cylindrical = "cylindrical"
    case Cube = "cube"
}

class TextureMapPattern: Pattern {
    
    init(mapping: Mapping, uvPattern: Pattern) {
        self.mapping = mapping
        self.uvPattern = uvPattern
    }
    
    func uvMap(point: Tuple) -> (Double, Double) {
        switch mapping {
        case .Spherical:
            return point.sphericalMap()
        case .Planar:
            return point.planarMap()
        case .Cylindrical:
            return point.cylindricalMap()
        case .Cube:
            let face = point.faceFromPoint()
            
            var u = 0.0
            var v = 0.0
            
            switch face {
            case .Front:
                (u, v) = point.cubeUvFront()
            case .Back:
                (u, v) = point.cubeUvBack()
            case .Left:
                (u, v) = point.cubeUvLeft()
            case .Right:
                (u, v) = point.cubeUvRight()
            case .Up:
                (u, v) = point.cubeUvUp()
            case .Down:
                (u, v) = point.cubeUvDown()
            }
            
            return (u, v)
        }
    }
    
    override func patternAt(point: Tuple) -> Color {

        if let pattern = uvPattern {
            let (u, v) = uvMap(point: point)
            return pattern.uvPatternAt(u: u, v: v)
        }
        
        return Color.black
    }
    var mapping: Mapping = .Spherical
    var uvPattern: Pattern? = nil
}
