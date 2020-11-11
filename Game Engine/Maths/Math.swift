//
//  Math.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class Math {
    
    static var xAxis: Vector3f {
        return Vector3f(1, 0, 0)
    }
    
    static var yAxis: Vector3f {
        return Vector3f(0, 1, 0)
    }
    
    static var zAxis: Vector3f {
        return Vector3f(0, 0, 1)
    }
    
}

// Overall Float Methods
extension Math {
    
    static func getDegrees(of radian: Float)->Float {
        return radian * 180 / Float.pi
    }
    
    static func getRadians(of degree: Float)->Float {
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
        v1: Vector2f, v2: Vector2f,
        v3: Vector2f, v4: Vector2f
    )->Float {
        return 0.5 *
        (
            (v1.x * v2.y + v2.x * v3.y + v3.x * v4.y + v4.x + v1.y) -
            (v2.x * v1.y + v3.x * v2.y + v4.x * v3.y + v1.x * v4.y)
        )
    }
    
    static func limit(
        _ vector: inout Vector2f,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    ) {
        if getMagnitude(of: vector) < min {
            setMagnitude(min, to: &vector)
        } else if getMagnitude(of: vector) > max {
            setMagnitude(max, to: &vector)
        }
    }
    
    static func limit(
        _ vector: inout Vector3f,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    ) {
        if getMagnitude(of: vector) < min {
            setMagnitude(min, to: &vector)
        } else if getMagnitude(of: vector) > max {
            setMagnitude(max, to: &vector)
        }
    }
    
    static func getLimited(
        vector: Vector2f,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    )->Vector2f {
        if getMagnitude(of: vector) < min {
            return getVector(direction: vector, withMagnitudeOf: min)
        } else if getMagnitude(of: vector) > max {
            return getVector(direction: vector, withMagnitudeOf: max)
        } else {
            return vector
        }
    }
    
    static func getLimited(
        vector: inout Vector3f,
        min: Float = .zero, max: Float = .greatestFiniteMagnitude
    )->Vector3f {
        if getMagnitude(of: vector) < min {
            return getVector(direction: vector, withMagnitudeOf: min)
        } else if getMagnitude(of: vector) > max {
            return getVector(direction: vector, withMagnitudeOf: max)
        } else {
            return vector
        }
    }
    
    static func getMagnitude(of vector: Vector2f)->Float {
        return sqrt(vector.x * vector.x + vector.y * vector.y)
    }
    
    static func getMagnitude(of vector: Vector3f)->Float {
        return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
    }
    
    static func getVector(direction: Vector2f, withMagnitudeOf magnitude: Float)->Vector2f {
        return getNormalized(vector: direction) * magnitude
    }
    
    static func getVector(direction: Vector3f, withMagnitudeOf magnitude: Float)->Vector3f {
        return getNormalized(vector: direction) * magnitude
    }
    
    static func setMagnitude(_ magnitude: Float, to vector: inout Vector2f) {
        normalize(&vector)
        vector *= magnitude
    }
    
    static func setMagnitude(_ magnitude: Float, to vector: inout Vector3f) {
        normalize(&vector)
        vector *= magnitude
    }
    
    static func getNormalized(vector: Vector2f)->Vector2f {
        let magnitude = getMagnitude(of: vector)
        return vector / magnitude
    }
    
    static func getNormalized(vector: Vector3f)->Vector3f {
        let magnitude = getMagnitude(of: vector)
        return vector / magnitude
    }
    
    static func normalize(_ vector: inout Vector2f) {
        let magnitude = getMagnitude(of: vector)
        vector = vector / magnitude
    }
    
    static func normalize(_ vector: inout Vector3f) {
        let magnitude = getMagnitude(of: vector)
        vector = vector / magnitude
    }
    
    static func getDistance(of pos1: Vector2f, to pos2: Vector2f)->Float {
        return sqrt(
            pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2)
        )
    }
    
    static func getDistance(of pos1: Vector3f, to pos2: Vector3f)->Float {
        return sqrt(
            pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2) + pow(pos1.z - pos2.z, 2)
        )
    }
    
    static func getAngle(of vector: Vector2f)->Float {
        return atan2(vector.y, vector.x)
    }
    
    static func rotate(vector: inout Vector2f, to angle: Float) {
        vector = Vector2f(
            cos(angle) * vector.x - sin(angle) * vector.y,
            sin(angle) * vector.x + cos(angle) * vector.y
        )
    }
    
    static func getRotated(vector: Vector2f, to angle: Float)->Vector2f {
        return Vector2f(
            cos(angle) * vector.x - sin(angle) * vector.y,
            sin(angle) * vector.x + cos(angle) * vector.y
        )
    }
    
}

// Float
extension Float {
    
    var toDegrees: Float {
        return Math.getDegrees(of: self)
    }
    
    var toRadians: Float {
        return Math.getRadians(of: self)
    }
    
}

// Vector2
extension Vector2f {
    
    var asVector3f: Vector3f {
        return Vector3f(self.x, self.y, .zero)
    }
    
    var magnitude: Float {
        return Math.getMagnitude(of: self)
    }
    
    var normalized: Vector2f {
        return Math.getNormalized(vector: self)
    }
    
    mutating func setMagnitude(to magnitude: Float) {
        Math.setMagnitude(magnitude, to: &self)
    }
    
    mutating func normalize() {
        Math.normalize(&self)
    }
    
}

// Vector3
extension Vector3f {
    
    var asVector2f: Vector2f {
        return Vector2f(self.x, self.y)
    }
    
    var magnitude: Float {
        return Math.getMagnitude(of: self)
    }
    
    var normalized: Vector3f {
        return Math.getNormalized(vector: self)
    }
    
    mutating func setMagnitude(to magnitude: Float) {
        Math.setMagnitude(magnitude, to: &self)
    }
    
    mutating func normalize() {
        Math.normalize(&self)
    }
    
}

// Matrix
extension Matrix4x4f {
    
    static var identity: Matrix4x4f {
        return matrix_identity_float4x4
    }
    
    mutating func multiply(with matrix: Matrix4x4f) {
        self = matrix_multiply(self, matrix)
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
}

