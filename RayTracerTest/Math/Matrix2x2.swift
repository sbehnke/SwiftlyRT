//
//  Matrix2x2.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/30/19.
//  Copyright © 2019 Steven Behnke. All rights reserved.
//

import Foundation

struct Matrix2x2 : Equatable, AdditiveArithmetic {
    static var identity = Matrix2x2(a0: 1, a1: 0,
                                    b0: 0, b1: 1)
    
    static var zero = Matrix2x2()
    
    static let rows = 2
    static let columns = 2
    
    init() {
        
    }

    init(values: Array<Double>) {
        assert(values.count == Matrix2x2.rows * Matrix2x2.columns)
        backing = values
    }

    init(a0: Double, a1: Double,
         b0: Double, b1: Double) {
        
        self[0,0] = a0
        self[0,1] = a1

        self[1,0] = b0
        self[1,1] = b1
    }
    
    static func == (lhs: Matrix2x2, rhs: Matrix2x2) -> Bool {
        for i in 0..<(Matrix2x2.rows * Matrix2x2.columns) {
            if (!Tuple.almostEqual(lhs: lhs[i], rhs: rhs[i])) {
                return false
            }
        }
        
        return true
    }
    
    static func *= (lhs: inout Matrix2x2, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] * rhs
            }
        }
    }
    
    static func * (lhs: Matrix2x2, rhs: Double) -> Matrix2x2 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func /= (lhs: inout Matrix2x2, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] / rhs
            }
        }
    }
    
    static func / (lhs: Matrix2x2, rhs: Double) -> Matrix2x2 {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    
    //    static func * (lhs: Matrix2x2, rhs: Vector2) -> Vector2 {
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
    
    static func *= (lhs: inout Matrix2x2, rhs: Matrix2x2) {
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
    
    static func * (lhs: Matrix2x2, rhs: Matrix2x2) -> Matrix2x2 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func += (lhs: inout Matrix2x2, rhs: Matrix2x2) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] + rhs[row, col]
            }
        }
    }
    
    static func + (lhs: Matrix2x2, rhs: Matrix2x2) -> Matrix2x2 {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    
    static func -= (lhs: inout Matrix2x2, rhs: Matrix2x2) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] = lhs[row, col] - rhs[row, col]
            }
        }
    }
    
    static func - (lhs: Matrix2x2, rhs: Matrix2x2) -> Matrix2x2 {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < Matrix2x2.rows && column >= 0 && column < Matrix2x2.columns
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
            return backing[(row * Matrix2x2.columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            backing[(row * Matrix2x2.columns) + column] = newValue
        }
    }
    
    func transpose() -> Matrix2x2 {
        var output = Matrix2x2()
        
        for row in 0..<Matrix2x2.rows {
            for col in 0..<Matrix2x2.columns {
                output[row,col] = self[col,row]
            }
        }
        
        return output
    }
    
    func determinate() -> Double {
        return self[0,0] * self[1,1] -
               self[1,0] * self[0,1]
    }
    
    func canInvert() -> Bool {
        return determinate() != 0
    }
    
    var description: String {
        get {
            var output = String()
            
            output += "[ "
            for row in 0..<Matrix2x2.rows {
                for col in 0..<Matrix2x2.columns {
                    output += String(self[row, col]) + ", "
                }
                output += "\n  "
            }
            output.removeLast(5)
            output += " ]"
            
            return output
        }
    }
    
    private var backing = Array<Double>(repeating: 0.0, count: Matrix2x2.rows * Matrix2x2.columns)
}
