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

    static let rows = 4
    static let columns = 4
    
    init() {
    }

    init(_ values: Array<Double>) {
        assert(values.count == Matrix4x4.rows * Matrix4x4.columns)
        backing = values
    }
    
    init(a0: Double, a1: Double, a2: Double, a3: Double, 
         b0: Double, b1: Double, b2: Double, b3: Double, 
         c0: Double, c1: Double, c2: Double, c3: Double, 
         d0: Double, d1: Double, d2: Double, d3: Double) {
                
        self[0,0] = a0
        self[0,1] = a1
        self[0,2] = a2
        self[0,3] = a3

        self[1,0] = b0
        self[1,1] = b1
        self[1,2] = b2
        self[1,3] = b3

        self[2,0] = c0
        self[2,1] = c1
        self[2,2] = c2
        self[2,3] = c3

        self[3,0] = d0
        self[3,1] = d1
        self[3,2] = d2
        self[3,3] = d3
    }

    static func == (lhs: Matrix4x4, rhs: Matrix4x4) -> Bool {
        for i in 0..<(Matrix4x4.rows * Matrix4x4.columns) {
            if (!Tuple.almostEqual(lhs: lhs[i], rhs: rhs[i])) {
                return false
            }
        }
        
        return true
    }

    static func *= (lhs: inout Matrix4x4, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[col, row] *= rhs
            }
        }
    }

    static func * (lhs: Matrix4x4, rhs: Double) -> Matrix4x4 {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    
    static func /= (lhs: inout Matrix4x4, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[row, col] /= rhs
            }
        }
    }

    static func / (lhs: Matrix4x4, rhs: Double) -> Matrix4x4 {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }

    static func * (lhs: Matrix4x4, rhs: Tuple) -> Tuple {
        var value = Tuple.zero

        for row in 0..<rows {
            var sum = 0.0
            for col in 0..<columns {
                sum += lhs[row, col] * rhs[col]
            }
            value[row] = sum
        }

        return value
    }
    
    static func * (lhs: Matrix4x4, rhs: Ray) -> Ray {
        return Ray(origin: lhs * rhs.origin, direction: lhs * rhs.direction)
    }
    
    static func *= (lhs: inout Matrix4x4, rhs: Matrix4x4) {
        let a = lhs
        for i in 0..<rows {
            for j in 0..<columns {
                lhs[i, j] = 0
                for k in 0..<rows {
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
        for row in 0..<rows {
            for col in 0..<columns {
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
        for row in 0..<rows {
            for col in 0..<columns {
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
        return row >= 0 && row < Matrix4x4.rows && column >= 0 && column < Matrix4x4.columns
    }
    
    func transpose() -> Matrix4x4 {
        var output = Matrix4x4()
        
        for row in 0..<Matrix4x4.rows {
            for col in 0..<Matrix4x4.columns {
                output[row,col] = self[col,row]
            }
        }
        
        return output
    }
    
    func subMatrix(row: Int, column: Int) -> Matrix3x3 {
        assert(indexIsValid(row: row, column: column))
        var values = Array<Double>()
        
        for i in 0..<Matrix4x4.rows {
            for j in 0..<Matrix4x4.columns {
                if (i == row || column == j) {
                    continue
                }
                
                values.append(self[i, j])
            }
        }
        
        return Matrix3x3(values: values)
    }
    
    func minor(row: Int, column: Int) -> Double {
        assert(indexIsValid(row: row, column: column))
        return subMatrix(row: row, column: column).determinate()
    }
    
    func cofactor(row: Int, column: Int) -> Double {
        let m1 = Matrix4x4(a0: 1, a1: -1, a2: 1, a3: -1,
                           b0: -1, b1: 1, b2: -1, b3: 1,
                           c0: 1, c1: -1, c2: 1, c3: -1,
                           d0: -1, d1: 1, d2: -1, d3: 1)

        assert(indexIsValid(row: row, column: column))
        return subMatrix(row: row, column: column).determinate() * m1[row, column]
    }
    
    func determinate() -> Double {
        var sum = 0.0
        for i in 0..<Matrix4x4.columns {
            sum += self[0, i] * cofactor(row: 0, column: i)
        }
        return sum
    }
    
    func canInvert() -> Bool {
        return determinate() != 0
    }
    
    func invert() -> Matrix4x4 {
        assert(canInvert())
        var result = Matrix4x4()
        let d = determinate()

        for i in 0..<Matrix4x4.rows {
            for j in 0..<Matrix4x4.columns {
                let c = cofactor(row: i, column: j)
                result[j, i] = c
            }
        }
                
        result /= d
        return result
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
            return backing[(row * Matrix4x4.columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            backing[(row * Matrix4x4.columns) + column] = newValue
        }
    }
    
    static func translate(x: Double, y: Double, z: Double) -> Matrix4x4 {
        var m = Matrix4x4.identity
        m[0, 3] = x
        m[1, 3] = y
        m[2, 3] = z
        return m
    }
    
    func translate(x: Double, y: Double, z: Double) -> Matrix4x4 {
        return Matrix4x4.translate(x: x, y: y, z: z) * self
    }
    
    static func scale(x: Double, y: Double, z: Double) -> Matrix4x4 {
        var m = Matrix4x4.identity
        m[0,0] = x
        m[1,1] = y
        m[2,2] = z
        return m
    }
    
    func scale(x: Double, y: Double, z: Double) -> Matrix4x4 {
        return Matrix4x4.scale(x: x, y: y, z: z) * self
    }
    
    static func rotateX(_ radians: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity
        matrix[1, 1] = cos(radians)
        matrix[1, 2] = -sin(radians)
        matrix[2, 1] = sin(radians)
        matrix[2, 2] = cos(radians)
        return matrix
    }
    
    func rotateX(_ radians: Double) -> Matrix4x4 {
        return Matrix4x4.rotateX(radians) * self
    }

    static func rotateY(_ radians: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity
        matrix[0, 0] = cos(radians)
        matrix[0, 2] = sin(radians)
        matrix[2, 0] = -sin(radians)
        matrix[2, 2] = cos(radians)
        return matrix
    }
    
    func rotateY(_ radians: Double) -> Matrix4x4 {
        return Matrix4x4.rotateY(radians) * self
    }
    
    static func rotateZ(_ radians: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity
        matrix[0, 0] = cos(radians)
        matrix[0, 1] = -sin(radians)
        matrix[1, 0] = sin(radians)
        matrix[1, 1] = cos(radians)
        return matrix
    }
    
    func rotateZ(_ radians: Double) -> Matrix4x4 {
        return Matrix4x4.rotateZ(radians) * self
    }
    
    static func shear(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity

        matrix[0, 1] = xy
        matrix[0, 2] = xz
        matrix[1, 0] = yx
        matrix[1, 2] = yz
        matrix[2, 0] = zx
        matrix[2, 1] = zy
        
        return matrix
    }
    
    func shear(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double) -> Matrix4x4 {
        return Matrix4x4.shear(xy: xy, xz: xz, yx: yx, yz: yz, zx: zx, zy: zy) * self
    }
    
    var description: String {
        get {
            var output = String()
            
            output += "[ "
            for row in 0..<Matrix4x4.rows {
                for col in 0..<Matrix4x4.columns {
                    output += String(self[row, col]) + ", "
                }
                output += "\n  "
            }
            output.removeLast(5)
            output += " ]"
            
            return output
        }
    }

    private var backing = Array<Double>(repeating: 0.0, count: rows * columns)
}
