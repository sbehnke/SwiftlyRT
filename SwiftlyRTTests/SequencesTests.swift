//
//  SequencesTests.swift
//  RayTracerTestTests
//
//  Created by Steven Behnke on 7/7/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftlyRT

class SequencesTests: XCTestCase {
    
    func testGeneratorReturnACyclicSequenceOfNumbers() {
//    Scenario: A number generator returns a cyclic sequence of numbers
//    Given gen ← sequence(0.1, 0.5, 1.0)
//    Then next(gen) = 0.1
//    And next(gen) = 0.5
//    And next(gen) = 1.0
//    And next(gen) = 0.1

        let gen = CyclicSequence([0.1, 0.5, 1.0])
        XCTAssertEqual(gen.next(), 0.1)
        XCTAssertEqual(gen.next(), 0.5)
        XCTAssertEqual(gen.next(), 1.0)
        XCTAssertEqual(gen.next(), 0.1)
        XCTAssertEqual(gen.next(), 0.5)
        XCTAssertEqual(gen.next(), 1.0)
    }
}
