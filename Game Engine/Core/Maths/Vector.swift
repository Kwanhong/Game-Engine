//
//  Vector.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/15.
//

import Foundation
import MetalKit

// Vector2
extension Vector2f {
    
    var asCGPoint: CGPoint {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    
    var asVector3f: Vector3f {
        return Vector3f(self.x, self.y, .zero)
    }
    
    func asVector3f(z: Float)->Vector3f {
        return Vector3f(x, y, z)
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
    
    mutating func rotate(to theta: Float) {
        Math.rotate(vector: &self, to: theta)
    }
    
    func rotated(to theta: Float)->Vector2f {
        return Math.getRotated(vector: self, to: theta)
    }
    
}

// Vector3
extension Vector3f {
    
    var asVector2f: Vector2f {
        return Vector2f(self.x, self.y)
    }
    
    var asVector4f: Vector4f {
        return Vector4f(self.x, self.y, self.z, 1)
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
    
    mutating func rotate(by rotation: Vector3f) {
    
        let xzVec = Math.getRotated(vector: Vector2f(x, z), to: rotation.y)
        self = Vector3f(xzVec.x, y, xzVec.y)
        
        let xyVec = Math.getRotated(vector: Vector2f(x, y), to: rotation.z)
        self = Vector3f(xyVec.x, xyVec.y, z)
        
        let yzVec = Math.getRotated(vector: Vector2f(y, z), to: rotation.x)
        self = Vector3f(x, -yzVec.x, yzVec.y)
        
    }
    
    func rotated(by rotation: Vector3f)->Vector3f {
        
        var result = self
        
        let yzVec = Vector2f(result.y, result.z).rotated(to: rotation.x)
        result = Vector3f(result.x, yzVec.x, yzVec.y)
        
        let xzVec = Vector2f(result.x, result.z).rotated(to: rotation.y)
        result = Vector3f(xzVec.x, result.y, xzVec.y)
        
        let xyVec = Vector2f(result.x, result.y).rotated(to: rotation.z)
        result = Vector3f(xyVec.x, -xyVec.y, result.z)
        
        return result
        
    }
    
}

// Vector3 (aka RGB Color)
extension Vector3f {
    
    static var red: Vector3f {
        return .init(1, 0, 0)
    }
    static var green: Vector3f {
        return .init(0, 1, 0)
    }
    static var blue: Vector3f {
        return .init(0, 0, 1)
    }
    static var black: Vector3f {
        return .init(0, 0, 0)
    }
    static var white: Vector3f {
        return .init(1, 1, 1)
    }
    static var gray: Vector3f {
        return .init(0.5,0.5,0.5)
    }
    static func gray(_ color: Float)->Vector3f {
        return .init(color, color, color)
    }
    
    static var random: Vector3f {
        return .init(
            .random(in: 0...1),
            .random(in: 0...1),
            .random(in: 0...1)
        )
    }
    
    
}

// Vector4 (aka RGBA Color)
extension Vector4f {
    
    var asVector3f: Vector3f {
        return Vector3f(self.x, self.y, self.z)
    }
    
    static var red: Vector4f {
        return .init(1, 0, 0, 1)
    }
    static var green: Vector4f {
        return .init(0, 1, 0, 1)
    }
    static var blue: Vector4f {
        return .init(0, 0, 1, 1)
    }
    static var black: Vector4f {
        return .init(0, 0, 0, 1)
    }
    static var white: Vector4f {
        return .init(1, 1, 1, 1)
    }
    static var gray: Vector4f {
        return .init(0.5,0.5,0.5,1)
    }
    static func gray(_ color: Float)->Vector4f {
        return .init(color, color, color, 1)
    }
    
    static var random: Vector4f {
        return .init(
            .random(in: 0...1),
            .random(in: 0...1),
            .random(in: 0...1),
            Float(1)
        )
    }
    
}
