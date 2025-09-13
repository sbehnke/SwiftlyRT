//
//  Matrix4x4.swift
//  RayTracerTest
//
//  Created by Steven Behnke on 6/29/19.
//  Copyright © 2025 Steven Behnke. All rights reserved.
//

import Foundation

#if canImport(simd)
import simd
#endif

struct Matrix4x4: Equatable, AdditiveArithmetic {
    static let identity = Matrix4x4(
        a0: 1, a1: 0, a2: 0, a3: 0,
        b0: 0, b1: 1, b2: 0, b3: 0,
        c0: 0, c1: 0, c2: 1, c3: 0,
        d0: 0, d1: 0, d2: 0, d3: 1)

    static let zero = Matrix4x4()

    static let rows = 4
    static let columns = 4

    init() {
    }

    init(_ values: [Double]) {
        assert(values.count == Matrix4x4.rows * Matrix4x4.columns)
        backing = values
    }

    init(
        a0: Double, a1: Double, a2: Double, a3: Double,
        b0: Double, b1: Double, b2: Double, b3: Double,
        c0: Double, c1: Double, c2: Double, c3: Double,
        d0: Double, d1: Double, d2: Double, d3: Double
    ) {

        self[0, 0] = a0
        self[0, 1] = a1
        self[0, 2] = a2
        self[0, 3] = a3

        self[1, 0] = b0
        self[1, 1] = b1
        self[1, 2] = b2
        self[1, 3] = b3

        self[2, 0] = c0
        self[2, 1] = c1
        self[2, 2] = c2
        self[2, 3] = c3

        self[3, 0] = d0
        self[3, 1] = d1
        self[3, 2] = d2
        self[3, 3] = d3
    }

    static func == (lhs: Matrix4x4, rhs: Matrix4x4) -> Bool {
        for i in 0..<(Matrix4x4.rows * Matrix4x4.columns) {
            if !Tuple.almostEqual(lhs: lhs[i], rhs: rhs[i]) {
                return false
            }
        }

        return true
    }

    static func *= (lhs: inout Matrix4x4, rhs: Double) {
        for row in 0..<rows {
            for col in 0..<columns {
                lhs[row, col] *= rhs
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

#if canImport(simd)
    private var simdMatrix: simd_double4x4 {
        // Build by COLUMNS: each SIMD4 is a column (m00, m10, m20, m30), etc.
        let c0 = SIMD4<Double>(self[0,0], self[1,0], self[2,0], self[3,0])
        let c1 = SIMD4<Double>(self[0,1], self[1,1], self[2,1], self[3,1])
        let c2 = SIMD4<Double>(self[0,2], self[1,2], self[2,2], self[3,2])
        let c3 = SIMD4<Double>(self[0,3], self[1,3], self[2,3], self[3,3])
        return simd_double4x4(c0, c1, c2, c3)
    }

    static func * (lhs: Matrix4x4, rhs: Tuple) -> Tuple {
        let M = lhs.simdMatrix
        let v = SIMD4<Double>(rhs.x, rhs.y, rhs.z, rhs.w)
        let r = M * v
        return Tuple(x: r.x, y: r.y, z: r.z, w: r.w)
    }
#else
    static func * (lhs: Matrix4x4, rhs: Tuple) -> Tuple {
        var value = Tuple.zero

        for col in 0..<columns {
            var sum = 0.0
            for row in 0..<rows {
                sum += lhs[row, col] * rhs[col]
            }
            value[row] = sum
        }

        return value
    }
#endif

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
                lhs[row, col] = lhs[row, col] + rhs[row, col]
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
                lhs[row, col] = lhs[row, col] - rhs[row, col]
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

    func transposed() -> Matrix4x4 {
        var output = Matrix4x4()

        for row in 0..<Matrix4x4.rows {
            for col in 0..<Matrix4x4.columns {
                output[row, col] = self[col, row]
            }
        }

        return output
    }

    func subMatrix(row: Int, column: Int) -> Matrix3x3 {
        assert(indexIsValid(row: row, column: column))
        var values = [Double]()

        for i in 0..<Matrix4x4.rows {
            for j in 0..<Matrix4x4.columns {
                if i == row || column == j {
                    continue
                }

                values.append(self[i, j])
            }
        }

        return Matrix3x3(values)
    }

    func minor(row: Int, column: Int) -> Double {
        assert(indexIsValid(row: row, column: column))
        return subMatrix(row: row, column: column).determinate()
    }

    func cofactor(row: Int, column: Int) -> Double {
        let factor = (row + column) % 2 == 0 ? 1.0 : -1.0
        assert(indexIsValid(row: row, column: column))
        return subMatrix(row: row, column: column).determinate() * factor
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

    func inversed() -> Matrix4x4 {
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

    subscript(index: Int) -> Double {
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

    static func translated(x: Double, y: Double, z: Double) -> Matrix4x4 {
        var m = Matrix4x4.identity
        m[0, 3] = x
        m[1, 3] = y
        m[2, 3] = z
        return m
    }

    func translated(x: Double, y: Double, z: Double) -> Matrix4x4 {
        return Matrix4x4.translated(x: x, y: y, z: z) * self
    }

    static func scaled(x: Double, y: Double, z: Double) -> Matrix4x4 {
        var m = Matrix4x4.identity
        m[0, 0] = x
        m[1, 1] = y
        m[2, 2] = z
        return m
    }

    func scaled(x: Double, y: Double, z: Double) -> Matrix4x4 {
        return Matrix4x4.scaled(x: x, y: y, z: z) * self
    }

    static func rotatedX(_ radians: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity
        matrix[1, 1] = cos(radians)
        matrix[1, 2] = -sin(radians)
        matrix[2, 1] = sin(radians)
        matrix[2, 2] = cos(radians)
        return matrix
    }

    func rotatedX(_ radians: Double) -> Matrix4x4 {
        return Matrix4x4.rotatedX(radians) * self
    }

    static func rotatedY(_ radians: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity
        matrix[0, 0] = cos(radians)
        matrix[0, 2] = sin(radians)
        matrix[2, 0] = -sin(radians)
        matrix[2, 2] = cos(radians)
        return matrix
    }

    func rotatedY(_ radians: Double) -> Matrix4x4 {
        return Matrix4x4.rotatedY(radians) * self
    }

    static func rotatedZ(_ radians: Double) -> Matrix4x4 {
        var matrix = Matrix4x4.identity
        matrix[0, 0] = cos(radians)
        matrix[0, 1] = -sin(radians)
        matrix[1, 0] = sin(radians)
        matrix[1, 1] = cos(radians)
        return matrix
    }

    func rotatedZ(_ radians: Double) -> Matrix4x4 {
        return Matrix4x4.rotatedZ(radians) * self
    }

    static func sheared(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double)
        -> Matrix4x4
    {
        var matrix = Matrix4x4.identity

        matrix[0, 1] = xy
        matrix[0, 2] = xz
        matrix[1, 0] = yx
        matrix[1, 2] = yz
        matrix[2, 0] = zx
        matrix[2, 1] = zy

        return matrix
    }

    func sheared(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double)
        -> Matrix4x4
    {
        return Matrix4x4.sheared(xy: xy, xz: xz, yx: yx, yz: yz, zx: zx, zy: zy) * self
    }

    #if canImport(simd)
    func viewTransformedSIMD(from: vector_double3, to: vector_double3, up: vector_double3)
        -> Matrix4x4
    {
        let forward = simd_normalize(to - from)
        let upn = simd_normalize(up)
        let left = simd_cross(forward, upn)
        let true_up = simd_cross(left, forward)

        let orientation = matrix_double4x4(
            vector_double4(arrayLiteral: left.x, left.y, left.z, 0),
            vector_double4(arrayLiteral: true_up.x, true_up.y, true_up.z, 0),
            vector_double4(arrayLiteral: -forward.x, -forward.y, -forward.z, 0),
            vector_double4(arrayLiteral: 0, 0, 0, 1))

        var translation = matrix_identity_double4x4
        translation[0, 3] = -from.x
        translation[1, 3] = -from.y
        translation[2, 3] = -from.z
        let transformed = orientation * translation

        return Matrix4x4(a0: transformed[0].x, a1: transformed[0].y, a2: transformed[0].z, a3: transformed[0].w,
                  b0: transformed[1].x, b1: transformed[1].y, b2: transformed[1].z, b3: transformed[1].w,
                  c0: transformed[2].x, c1: transformed[2].y, c2: transformed[2].z, c3: transformed[2].w,
                  d0: transformed[3].x, d1: transformed[3].y, d2: transformed[3].z, d3: transformed[3].w)
    }
    #endif

    static func viewTransformed(from: Tuple, to: Tuple, up: Tuple) -> Matrix4x4 {
        assert(from.isPoint())
        assert(to.isPoint())
        assert(up.isVector())

        let forward = (to - from).normalized()
        let upn = up.normalized()
        let left = forward.cross(upn)
        let trueUp = left.cross(forward)

        let orientation = Matrix4x4([
            left.x, left.y, left.z, 0,
            trueUp.x, trueUp.y, trueUp.z, 0,
            -forward.x, -forward.y, -forward.z, 0,
            0, 0, 0, 1,
        ])

        return orientation * Matrix4x4.translated(x: -from.x, y: -from.y, z: -from.z)
    }

    var description: String {
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

    private var backing = [Double](repeating: 0.0, count: rows * columns)
}

