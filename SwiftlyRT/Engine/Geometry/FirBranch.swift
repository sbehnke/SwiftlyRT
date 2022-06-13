//
//  FirBranch.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 6/12/22.
//  Copyright © 2022 Luster Images. All rights reserved.
//

import Foundation

class FirBranch: Group {

    override init() {
        super.init()

        let length = 2.0
        let radius = 0.025
        let segments = 20
        let per_segment = 24

        let branch = Cylinder()
        branch.minimum = 0.0
        branch.maximum = length
        branch.transform = .scaled(x: radius, y: 1.0, z: radius)
        branch.material.color = Color(r: 0.5, g: 0.35, b: 0.26)
        branch.material.ambient = 0.2
        branch.material.specular = 0.0
        branch.material.diffuse = 0.6

        let seg_size = length / Double(segments - 1)
        let theta = 2.1 * Double.pi / Double(per_segment)
        let max_length = 20.0 * radius

        let object = Group()
        object.addChild(branch)

        for y in 0..<(segments - 1) {
            let subgroup = Group()

            for i in 0..<(segments - 1) {
                // Double.random(in: 0...1)
                let y_base = seg_size * Double(y) + Double.random(in: 0...1) * seg_size
                let y_tip = y_base - Double.random(in: 0...1) * seg_size
                let y_angle = Double(i) * theta + Double.random(in: 0...1) * theta
                let needle_length = max_length / 2.0 * (1.0 + Double.random(in: 0...1))
                let ofs = radius / 2.0

                let p1 = Tuple.Point(x: ofs, y: y_base, z: ofs)
                let p2 = Tuple.Point(x: -ofs, y: y_base, z: ofs)
                let p3 = Tuple.Point(x: 0.0, y: y_tip, z: needle_length)

                let tri = Triangle(point1: p1, point2: p2, point3: p3)
                tri.transform = .rotatedY(y_angle)
                tri.material.color = Color(r: 0.26, g: 0.36, b: 0.16)
                tri.material.specular = 0.1

                subgroup.addChild(tri)
            }

            object.addChild(subgroup)
        }

        self.addChild(object)
    }
}
