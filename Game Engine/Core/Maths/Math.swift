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

// Linear Algebra Methods
extension Math {
    
    static func getCrossProducted(vector1: Vector3f, vector2: Vector3f)->Vector3f {
        var cross: Vector3f = .zero
        cross.x = vector1.y * vector2.z - vector1.z * vector2.y
        cross.y = vector1.z * vector2.x - vector1.x * vector2.z
        cross.z = vector1.x * vector2.y - vector1.y * vector2.x
        return cross
    }
    
    static func getDotProducted(vector1: Vector3f, vector2: Vector3f)->Float {
        let result =
            vector1.x * vector2.x +
            vector1.y * vector2.y +
            vector1.z * vector2.z
        return result
    }
    
}
