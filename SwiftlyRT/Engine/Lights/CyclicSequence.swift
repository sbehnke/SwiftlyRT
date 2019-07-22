//
//  CyclicSequence.swift
//  SwiftlyRT
//
//  Created by Steven Behnke on 7/21/19.
//  Copyright © 2019 Luster Images. All rights reserved.
//

import Foundation

class CyclicSequence: Equatable {
    static func == (lhs: CyclicSequence, rhs: CyclicSequence) -> Bool {
        return lhs.index == rhs.index && lhs.values == rhs.values
    }
    
    init(_ values: [Double]) {
        self.values = values
    }
    
    subscript(index:Int) -> Double {
        get {
            return values[index % values.count]
        }
    }
    
    func next() -> Double {
        let value = self[index]
        index += 1
        return value
    }
    
    private var index: Int = 0
    private var values: [Double] = []
}
