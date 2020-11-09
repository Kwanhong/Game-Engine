//
//  Math.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class Math {
    
    static var xAxis: simd_float3 {
        return simd_float3(1, 0, 0)
    }
    
    static var yAxis: simd_float3 {
        return simd_float3(0, 1, 0)
    }
    
    static var zAxis: simd_float3 {
        return simd_float3(0, 0, 1)
    }
    
}

// Overall Float Methods
extension Math {
    
    static func getDegree(of radian: Float)->Float {
        return radian * 180 / Float.pi
    }
    
    static func getRadian(of degree: Float)->Float {
        return degree * Float.pi / 180
    }
    
    static func mapAndLimit(
        _ value:Float,
        start1:Float, stop1:Float,
        start2:Float, stop2:Float
    ) -> Float {
        let result = ((value - start1) / (stop1 - start1)) * (stop2 - start2) + start2
        return getLimited(value: result, min: start2, max: stop2)
    }
    
    static func map(
        _ value:Float,
        start1:Float, stop1:Float,
        start2:Float, stop2:Float
    ) -> Float {
        return ((value - start1) / (stop1 - start1)) * (stop2 - start2) + start2
    }
    
    static func limit(
        _ value: inout Float, min: Float, max: Float
    ) {
        if value < min {
            value = min
        } else if value > max {
            value = max
        }
    }
    
    static func getLimited(
        value: Float, min: Float, max: Float
    )->Float {
        if value < min {
            return min
        } else if value > max {
            return max
        } else {
            return value
        }
    }
    
}

// Overall Vector Methods
extension Math {
    
    static func getAreaOf(
        v1: simd_float2, v2: simd_float2,
        v3: simd_float2, v4: simd_float2
    )->Float {
        return 0.5 *
        (
            (v1.x * v2.y + v2.x * v3.y + v3.x * v4.y + v4.x + v1.y) -
            (v2.x * v1.y + v3.x * v2.y + v4.x * v3.y + v1.x * v4.y)
        )
    }
    
    static func limit(
        _ vector: inout simd_float2,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    ) {
        if getMagnitude(of: vector) < min {
            setMagnitude(min, to: &vector)
        } else if getMagnitude(of: vector) > max {
            setMagnitude(max, to: &vector)
        }
    }
    
    static func limit(
        _ vector: inout simd_float3,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    ) {
        if getMagnitude(of: vector) < min {
            setMagnitude(min, to: &vector)
        } else if getMagnitude(of: vector) > max {
            setMagnitude(max, to: &vector)
        }
    }
    
    static func getLimited(
        vector: simd_float2,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    )->simd_float2 {
        if getMagnitude(of: vector) < min {
            return getVector(vector, withMagnitudeOf: min)
        } else if getMagnitude(of: vector) > max {
            return getVector(vector, withMagnitudeOf: max)
        } else {
            return vector
        }
    }
    
    static func getLimited(
        vector: inout simd_float3,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    )->simd_float3 {
        if getMagnitude(of: vector) < min {
            return getVector(vector, withMagnitudeOf: min)
        } else if getMagnitude(of: vector) > max {
            return getVector(vector, withMagnitudeOf: max)
        } else {
            return vector
        }
    }
    
    static func getMagnitude(of vector: simd_float2)->Float {
        return sqrt(vector.x * vector.x + vector.y * vector.y)
    }
    
    static func getMagnitude(of vector: simd_float3)->Float {
        return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
    }
    
    static func getVector(_ vector: simd_float2, withMagnitudeOf magnitude: Float)->simd_float2 {
        return getNormalized(vector: vector) * magnitude
    }
    
    static func getVector(_ vector: simd_float3, withMagnitudeOf magnitude: Float)->simd_float3 {
        return getNormalized(vector: vector) * magnitude
    }
    
    static func setMagnitude(_ magnitude: Float, to vector: inout simd_float2) {
        normalize(&vector)
        vector *= magnitude
    }
    
    static func setMagnitude(_ magnitude: Float, to vector: inout simd_float3) {
        normalize(&vector)
        vector *= magnitude
    }
    
    static func getNormalized(vector: simd_float2)->simd_float2 {
        let magnitude = getMagnitude(of: vector)
        return vector / magnitude
    }
    
    static func getNormalized(vector: simd_float3)->simd_float3 {
        let magnitude = getMagnitude(of: vector)
        return vector / magnitude
    }
    
    static func normalize(_ vector: inout simd_float2) {
        let magnitude = getMagnitude(of: vector)
        vector = vector / magnitude
    }
    
    static func normalize(_ vector: inout simd_float3) {
        let magnitude = getMagnitude(of: vector)
        vector = vector / magnitude
    }
    
    static func getDistance(of pos1: simd_float2, to pos2: simd_float2)->Float {
        return sqrt(
            pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2)
        )
    }
    
    static func getDistance(of pos1: simd_float3, to pos2: simd_float3)->Float {
        return sqrt(
            pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2) + pow(pos1.z - pos2.z, 2)
        )
    }
    
    static func getAngle(of vector: simd_float2)->Float {
        return atan2(vector.y, vector.x)
    }
    
    static func rotate(vector: inout simd_float2, to angle: Float) {
        vector = simd_float2(
            cos(angle) * vector.x - sin(angle) * vector.y,
            sin(angle) * vector.x + cos(angle) * vector.y
        )
    }
    
    static func getRotated(vector: simd_float2, to angle: Float)->simd_float2 {
        return simd_float2(
            cos(angle) * vector.x - sin(angle) * vector.y,
            sin(angle) * vector.x + cos(angle) * vector.y
        )
    }
    
}

// Vector2
extension simd_float2 {
    
    var vector3: simd_float3 {
        return simd_float3(self.x, self.y, .zero)
    }
    
}

// Vector3
extension simd_float3 {
    
    var vector2: simd_float2 {
        return simd_float2(self.x, self.y)
    }
    
}

// Matrix
extension matrix_float4x4 {
    
    mutating func translate(direction: simd_float3) {
        
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(x, y, z, 1)
        )
        
        self = matrix_multiply(self, result)
        
    }
    
    mutating func scale(axis: simd_float3) {
        
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            simd_float4(x, 0, 0, 0),
            simd_float4(0, y, 0, 0),
            simd_float4(0, 0, z, 0),
            simd_float4(0, 0, 0, 1)
        )
        
        self = matrix_multiply(self, result)
        
    }
    
    mutating func rotate(angle: Float, axis: simd_float3) {
        
        var result = matrix_identity_float4x4
        
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
            simd_float4(r1c1, r2c1, r3c1, r4c1),
            simd_float4(r1c2, r2c2, r3c2, r4c2),
            simd_float4(r1c3, r2c3, r3c3, r4c3),
            simd_float4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
        
    }
}

