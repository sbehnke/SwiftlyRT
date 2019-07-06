//
//  LightBase.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 7/2/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct PointLight: Equatable {
    init(position: Tuple, intensity : Color) {
        assert(position.isPoint())
        self.position = position
        self.intensity = intensity
    }
    
    var position = Tuple.pointZero
    var intensity = Color()
}
