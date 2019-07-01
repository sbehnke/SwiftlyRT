//
//  Matrix3x3.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/30/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Matrix3x3 : Equatable, AdditiveArithmetic {
    static var identity = Matrix3x3(a0: 1, a1: 0, a2: 0,
                                    b0: 0, b1: 1, b2: 0,
                                    c0: 0, c1: 0, c2: 1)
    
    static var zero = Matrix3x3()
    
    static let rows = 3
    static let columns = 3
    
    init() {
        
    }
    
    init(values: Array<Double>) {
        assert(values.count == Matrix3x3.rows * Matrix3x3.columns)
        backing = values
    }
    
    init(a0: Double, a1: Double, a2: Double,
         b0: Double, b1: Double, b2: Double,
         c0: Double, c1: Double, c2: Double) {
        
        ma_0 = a0
        ma_1 = a1
        ma_2 = a2
        
        mb_0 = b0
        mb_1 = b1
        mb_2 = b2
        
        mc_0 = c0
        mc_1 = c1
        mc_2 = c2
    }
    
    static func == (lhs: Matrix3x3, rhs: Matrix3x3) -> Bool {
        for i in 0..<(Matrix3x3.rows * Matrix3x3.columns) {
            if (!Vector4.almostEqual(lhs: lhs[i], rhs: rhs[i])) {
                return false
            }
        }
        
        return true
    }
    
    static func *= (lhs: inout Matrix3x3, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] * rhs
            }
        }
    }
    
    static func * (lhs: Matrix3x3, rhs: Double) -> Matrix3x3 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func /= (lhs: inout Matrix3x3, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] / rhs
            }
        }
    }
    
    static func / (lhs: Matrix3x3, rhs: Double) -> Matrix3x3 {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    
//    static func * (lhs: Matrix3x3, rhs: Vector3) -> Vector3 {
//        var value = Vector4()
//
//        for row in 0..<rows {
//            var sum = 0.0
//            for col in 0..<columns {
//                sum += lhs[row, col] * rhs[col]
//            }
//            value[row] = sum
//        }
//
//        return value
//    }
    
    static func *= (lhs: inout Matrix3x3, rhs: Matrix3x3) {
        let a = lhs
        for i in 0..<rows {
            for j in 0..<columns {
                lhs[i, j] = 0
                for k in 0..<columns {
                    lhs[i, j] += a[i, k] * rhs[k, j]
                }
            }
        }
    }
    
    static func * (lhs: Matrix3x3, rhs: Matrix3x3) -> Matrix3x3 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func += (lhs: inout Matrix3x3, rhs: Matrix3x3) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] + rhs[row, col]
            }
        }
    }
    
    static func + (lhs: Matrix3x3, rhs: Matrix3x3) -> Matrix3x3 {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func -= (lhs: inout Matrix3x3, rhs: Matrix3x3) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] - rhs[row, col]
            }
        }
    }
    
    static func - (lhs: Matrix3x3, rhs: Matrix3x3) -> Matrix3x3 {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < Matrix3x3.rows && column >= 0 && column < Matrix3x3.columns
    }
    
    func transpose() -> Matrix3x3 {
        var output = Matrix3x3()
        
        for row in 0..<Matrix3x3.rows {
            for col in 0..<Matrix3x3.columns {
                output[row,col] = self[col,row]
            }
        }
        
        return output
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
            return backing[(row * Matrix3x3.columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            backing[(row * Matrix3x3.columns) + column] = newValue
        }
    }
    
    func subMatrix(row: Int, column: Int) -> Matrix2x2 {
        assert(indexIsValid(row: row, column: column))
        var values = Array<Double>()
        
        for i in 0..<Matrix3x3.rows {
            for j in 0..<Matrix3x3.columns {
                if (i == row || column == j) {
                    continue
                }
                
                values.append(self[i, j])
            }
        }
        
        return Matrix2x2(values: values)
    }
    
    func minor(row: Int, column: Int) -> Double {
        assert(indexIsValid(row: row, column: column))
        return subMatrix(row: row, column: column).determinate()
    }
    
    func cofactor(row: Int, column: Int) -> Double {
        var factor = 1.0
        if (row + column % 2 != 0) {
            factor = -1.0
        }
        assert(indexIsValid(row: row, column: column))
        return subMatrix(row: row, column: column).determinate() * factor
    }
    
    func determinate() -> Double {
        var sum = 0.0
        for i in 0..<Matrix3x3.columns {
            sum += self[0, i] * cofactor(row: 0, column: i)
        }
        return sum
    }
    
    func canInvert() -> Bool {
        return determinate() != 0
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
    
    var mb_0 : Double {
        get {
            return backing[3]
        }
        set {
            backing[3] = newValue
        }
    }
    var mb_1 : Double {
        get {
            return backing[4]
        }
        set {
            backing[4] = newValue
        }
    }
    var mb_2 : Double {
        get {
            return backing[5]
        }
        set {
            backing[5] = newValue
        }
    }
    
    var mc_0 : Double {
        get {
            return backing[6]
        }
        set {
            backing[6] = newValue
        }
    }
    var mc_1 : Double {
        get {
            return backing[7]
        }
        set {
            backing[7] = newValue
        }
    }
    var mc_2 : Double {
        get {
            return backing[8]
        }
        set {
            backing[8] = newValue
        }
    }
    
    private var backing = Array<Double>(repeating: 0.0, count: Matrix3x3.rows * Matrix3x3.columns)
}
