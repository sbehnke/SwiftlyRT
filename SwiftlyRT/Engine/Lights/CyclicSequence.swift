//
//  CyclicSequence.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/21/19.
//  Copyright © 2025 Luster Images. All rights reserved.
//

import Foundation

class CyclicSequence: Equatable {
    static func == (lhs: CyclicSequence, rhs: CyclicSequence) -> Bool {
        return lhs.index == rhs.index && lhs.values == rhs.values
    }

    init(_ values: [Double]) {
        self.values = values
    }

    init() {

    }

    subscript(index: Int) -> Double {
        get {
            return values[index % values.count]
        }
    }

    func next() -> Double {
        if values.count > 0 {
            let value = self[index]
            index += 1
            return value
        } else {
            return Double.random(in: 0...1)
        }
    }

    private var index: Int = 0
    private var values: [Double] = []
}
