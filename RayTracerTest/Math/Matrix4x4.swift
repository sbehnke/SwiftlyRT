//
//  Matrix4x4.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Matrix4x4 : Equatable, AdditiveArithmetic {
    static var identity = Matrix4x4(a0: 1, a1: 0, a2: 0, a3: 0, 
         b0: 0, b1: 1, b2: 0, b3: 0, 
         c0: 0, c1: 0, c2: 1, c3: 0, 
         d0: 0, d1: 0, d2: 0, d3: 1)
        
    static var zero = Matrix4x4()

    let rows = 4
    let columns = 4

    init() {

    }

    init(a0: Double, a1: Double, a2: Double, a3: Double, 
         b0: Double, b1: Double, b2: Double, b3: Double, 
         c0: Double, c1: Double, c2: Double, c3: Double, 
         d0: Double, d1: Double, d2: Double, d3: Double) {
                
        ma_0 = a0
        ma_1 = a1
        ma_2 = a2
        ma_3 = a3

        mb_0 = b0
        mb_1 = b1
        mb_2 = b2
        mb_3 = b3

        mc_0 = c0
        mc_1 = c1
        mc_2 = c2
        mc_3 = c3

        md_0 = d0
        md_1 = d1
        md_2 = d2
        md_3 = d3
    }

    static func == (lhs: Matrix4x4, rhs: Matrix4x4) -> Bool {
        return lhs.ma_0 == rhs.ma_0 && lhs.ma_1 == rhs.ma_1 && lhs.ma_2 == rhs.ma_2 && lhs.ma_3 == rhs.ma_3 &&
               lhs.ma_0 == rhs.ma_0 && lhs.ma_1 == rhs.ma_1 && lhs.ma_2 == rhs.ma_2 && lhs.ma_3 == rhs.ma_3 &&
               lhs.ma_0 == rhs.ma_0 && lhs.ma_1 == rhs.ma_1 && lhs.ma_2 == rhs.ma_2 && lhs.ma_3 == rhs.ma_3 &&
               lhs.ma_0 == rhs.ma_0 && lhs.ma_1 == rhs.ma_1 && lhs.ma_2 == rhs.ma_2 && lhs.ma_3 == rhs.ma_3
    }

    static func *= (lhs: inout Matrix4x4, rhs: Double) {
        for row in 0...3 {
            for col in 0...3 {
                lhs[col, row] = lhs[row, col] * rhs
            }
        }
    }

    static func * (lhs: Matrix4x4, rhs: Double) -> Matrix4x4 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func /= (lhs: inout Matrix4x4, rhs: Double) {
        for row in 0...3 {
            for col in 0...3 {
                lhs[col, row] = lhs[row, col] / rhs
            }
        }
    }

    static func / (lhs: Matrix4x4, rhs: Double) -> Matrix4x4 {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }

    static func * (lhs: Matrix4x4, rhs: Vector) -> Vector {
        var value = Vector()

        for row in 0...3 {
                value[row] = lhs[0, row] * rhs[0] +
                             lhs[1, row] * rhs[1] +
                             lhs[2, row] * rhs[2] +
                             lhs[3, row] * rhs[3]
        }

        return value
    }

    static func *= (lhs: inout Matrix4x4, rhs: Matrix4x4) {
        let a = lhs
        for i in 0...3 {
            for j in 0...3 {
                lhs[i, j] = 0
                for k in 0...3 {
                    lhs[i, j] += a[i, k] * rhs[k, j]
                }
            }
        }
    }

    static func * (lhs: Matrix4x4, rhs: Matrix4x4) -> Matrix4x4 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }

    static func += (lhs: inout Matrix4x4, rhs: Matrix4x4) {
        for row in 0...3 {
            for col in 0...3 {
                lhs[col, row] = lhs[row, col] + rhs[row, col]
            }
        }
    }

    static func + (lhs: Matrix4x4, rhs: Matrix4x4) -> Matrix4x4 {
        var lhs = lhs
        lhs += rhs
        return lhs
    }

    static func -= (lhs: inout Matrix4x4, rhs: Matrix4x4) {
        for row in 0...3 {
            for col in 0...3 {
                lhs[col, row] = lhs[row, col] - rhs[row, col]
            }
        }
    }

    static func - (lhs: Matrix4x4, rhs: Matrix4x4) -> Matrix4x4 {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }

    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    subscript(index:Int) -> Double {
        get {
            assert(index >= 0 && index < backing.count, "Index out of range")
            return backing[index]
        }
        set {
            assert(index >= 0 && index < backing.count, "Index out of range")
            backing[index] = newValue
        }
    }

    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return backing[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            backing[(row * columns) + column] = newValue
        }
    }

    var ma_0 : Double {
        get {
            return backing[0]
        }
        set {
            backing[0] = newValue
        }
    }
    var ma_1 : Double {
        get {
            return backing[1]
        }
        set {
            backing[1] = newValue
        }
    }
    var ma_2 : Double {
        get {
            return backing[2]
        }
        set {
            backing[2] = newValue
        }
    }
    var ma_3 : Double {
        get {
            return backing[3]
        }
        set {
            backing[3] = newValue
        }
    }
    
    var mb_0 : Double {
        get {
            return backing[4]
        }
        set {
            backing[4] = newValue
        }
    }
    var mb_1 : Double {
        get {
            return backing[5]
        }
        set {
            backing[5] = newValue
        }
    }
    var mb_2 : Double {
        get {
            return backing[6]
        }
        set {
            backing[6] = newValue
        }
    }
    var mb_3 : Double {
        get {
            return backing[7]
        }
        set {
            backing[7] = newValue
        }
    }

    var mc_0 : Double {
        get {
            return backing[8]
        }
        set {
            backing[8] = newValue
        }
    }
    var mc_1 : Double {
        get {
            return backing[9]
        }
        set {
            backing[9] = newValue
        }
    }
    var mc_2 : Double {
        get {
            return backing[10]
        }
        set {
            backing[10] = newValue
        }
    }
    var mc_3 : Double {
        get {
            return backing[11]
        }
        set {
            backing[11] = newValue
        }
    }

    var md_0 : Double {
        get {
            return backing[12]
        }
        set {
            backing[12] = newValue
        }
    }
    var md_1 : Double {
        get {
            return backing[13]
        }
        set {
            backing[13] = newValue
        }
    }
    var md_2 : Double {
        get {
            return backing[14]
        }
        set {
            backing[14] = newValue
        }
    }
    var md_3 : Double {
        get {
            return backing[0]
        }
        set {
            backing[15] = newValue
        }
    }

    private var backing = Array<Double>(repeating: 0.0, count: 4 * 4)
}
