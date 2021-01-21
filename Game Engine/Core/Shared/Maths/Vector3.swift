//
//  Vector3.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/30.
//

import Foundation

extension Vector3f {
    
    static var right: Vector3f {
        return Vector3f(1, 0, 0)
    }
    
    static var up: Vector3f {
        return Vector3f(0, 1, 0)
    }
    
    static var forward: Vector3f {
        return Vector3f(0, 0, 1)
    }
    
    var xy: Vector2f { return Vector2f(x, y) }
    
    var xz: Vector2f { return Vector2f(x, z) }
    
    var yx: Vector2f { return Vector2f(y, x) }
    
    var yz: Vector2f { return Vector2f(y, z) }
    
    var zx: Vector2f { return Vector2f(z, x) }
    
    var zy: Vector2f { return Vector2f(z, y) }
    
    var asVector4f: Vector4f {
        return Vector4f(self.x, self.y, self.z, .zero)
    }
    
    func asVector4f(w: Float)->Vector4f {
        return Vector4f(x, y, z, w)
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
        
        self.rotate(x: rotation.x, y: rotation.y, z: rotation.z)
        
    }
    
    mutating func rotate(x: Float? = nil, y: Float? = nil, z: Float? = nil) {
        
        if let y = y {
            let xzVec = Math.getRotated(vector: Vector2f(self.x, self.z), to: y)
            self = Vector3f(xzVec.x, self.y, xzVec.y)
        }
        if let z = z {
            let xyVec = Math.getRotated(vector: Vector2f(self.x, self.y), to: z)
            self = Vector3f(xyVec.x, xyVec.y, self.z)
        }
        if let x = x {
            let yzVec = Math.getRotated(vector: Vector2f(self.y, self.z), to: x)
            self = Vector3f(self.x, -yzVec.x, yzVec.y)
        }
        
    }
    
    func rotated(by rotation: Vector3f)->Vector3f {
        
        return self.rotated(x: rotation.x, y: rotation.y, z: rotation.z)
        
    }
    
    func rotated(x: Float? = nil, y: Float? = nil, z: Float? = nil)->Vector3f {
        
        var result = self
        
        if let y = y {
            let xzVec = Math.getRotated(vector: Vector2f(result.x, result.z), to: y)
            result = Vector3f(xzVec.x, result.y, xzVec.y)
        }
        if let z = z {
            let xyVec = Math.getRotated(vector: Vector2f(result.x, result.y), to: z)
            result = Vector3f(xyVec.x, xyVec.y, result.z)
        }
        if let x = x {
            let yzVec = Math.getRotated(vector: Vector2f(result.y, result.z), to: x)
            result = Vector3f(result.x, -yzVec.x, yzVec.y)
        }
        
        return result
        
    }
    
}

// RGB Color
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
