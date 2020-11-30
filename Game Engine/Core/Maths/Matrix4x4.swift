//
//  Matrix.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/15.
//

import Foundation
import MetalKit

extension Matrix4x4f {
    
    static var identity: Matrix4x4f {
        return matrix_identity_float4x4
    }
    
    static func mutliply(_ matrix1: Matrix4x4f, with matrix2: Matrix4x4f) -> Matrix4x4f {
        
        if matrix1 == .identity {
            return matrix2
        } else if matrix2 == .identity {
            return matrix1
        } else {
            return matrix_multiply(matrix1, matrix2)
        }
        
    }
    
    mutating func multiply(with matrix: Matrix4x4f) {
        
        if self == .identity {
            self = matrix
        } else if matrix != .identity {
            self = matrix_multiply(self, matrix)
        }
        
    }
    
    mutating func translate(direction: Vector3f) {
        
        var result: Matrix4x4f = .identity
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            Vector4f(1, 0, 0, 0),
            Vector4f(0, 1, 0, 0),
            Vector4f(0, 0, 1, 0),
            Vector4f(x, y, z, 1)
        )
        
        self.multiply(with: result)
        
    }
    
    mutating func scale(axis: Vector3f) {
        
        var result: Matrix4x4f = .identity
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            Vector4f(x, 0, 0, 0),
            Vector4f(0, y, 0, 0),
            Vector4f(0, 0, z, 0),
            Vector4f(0, 0, 0, 1)
        )
        
        self.multiply(with: result)
        
    }
    
    mutating func rotate(rotation: Vector3f) {
        
        self.rotate(angle: rotation.x, axis: Math.xAxis)
        self.rotate(angle: rotation.y, axis: Math.yAxis)
        self.rotate(angle: rotation.z, axis: Math.zAxis)
        
    }
    
    mutating func rotate(angle: Float, axis: Vector3f) {
        
        var result: Matrix4x4f = .identity
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = .zero
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = .zero
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = .zero
        
        let r1c4: Float = .zero
        let r2c4: Float = .zero
        let r3c4: Float = .zero
        let r4c4: Float = 1.0
        
        result.columns = (
            Vector4f(r1c1, r2c1, r3c1, r4c1),
            Vector4f(r1c2, r2c2, r3c2, r4c2),
            Vector4f(r1c3, r2c3, r3c3, r4c3),
            Vector4f(r1c4, r2c4, r3c4, r4c4)
        )
        
        self.multiply(with: result)
        
    }
    
    mutating func lookat(from origin: Vector3f, to target: Vector3f, up: Vector3f) {
        
        var result: Matrix4x4f = .identity
        
        var zaxis = (target - origin).normalized
        let xaxis = Math.getCrossProducted(vector1: zaxis, vector2: up).normalized
        let yaxis = Math.getCrossProducted(vector1: xaxis, vector2: zaxis)
        
        zaxis *= -1
        
        result.columns = (
            Vector4f(xaxis.x, xaxis.y, xaxis.z, Math.getDotProducted(vector1: xaxis, vector2: origin)),
            Vector4f(yaxis.x, yaxis.y, yaxis.z, Math.getDotProducted(vector1: yaxis, vector2: origin)),
            Vector4f(zaxis.x, zaxis.y, zaxis.z, Math.getDotProducted(vector1: zaxis, vector2: origin)),
            Vector4f(0, 0, 0, 1)
        )
        
        self.multiply(with: result)
    }
    
    static func perspective(degreesFov: Float, aspectRatio: Float, near: Float, far: Float)->Matrix4x4f {
        
        let fov = degreesFov.toRadians
        
        let t: Float = tan(fov / 2)
        
        let x: Float = 1 / (aspectRatio * t)
        let y: Float = 1 / t
        let z: Float = (far + near) / (near - far)
        let w: Float = (2 * far * near) / (near - far)
        
        var result: Matrix4x4f = .identity
        
        result.columns = (
            Vector4f(x, 0, 0, 0),
            Vector4f(0, y, 0, 0),
            Vector4f(0, 0, z,-1),
            Vector4f(0, 0, w, 0)
        )
        
        return result
        
    }
    
    func getRotation()->Vector3f {
        
        let y = -asin (self[0, 2])
        let x = atan2(self[1, 2] / cos(y), self[2, 2] / cos(y))
        let z = atan2(self[0, 1] / cos(y), self[0, 0] / cos(y))
        
        return Vector3f(x, y, z)
        
    }
    
}

