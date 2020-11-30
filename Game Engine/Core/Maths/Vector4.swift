//
//  Vector4.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/30.
//

import Foundation

extension Vector4f {
    
    var xyz: Vector3f { return Vector3f(x, y, z) }
    
    var xyw: Vector3f { return Vector3f(x, y, w) }
    
    var xzy: Vector3f { return Vector3f(x, z, y) }
    
    var xzw: Vector3f { return Vector3f(x, z, w) }
    
    var xwy: Vector3f { return Vector3f(x, w, y) }
    
    var xwz: Vector3f { return Vector3f(x, w, z) }
    
    var yxz: Vector3f { return Vector3f(y, x, z) }
    
    var yxw: Vector3f { return Vector3f(y, x, w) }
    
    var yzx: Vector3f { return Vector3f(y, z, x) }
    
    var yzw: Vector3f { return Vector3f(y, z, w) }
    
    var ywx: Vector3f { return Vector3f(y, w, x) }
    
    var ywz: Vector3f { return Vector3f(y, w, z) }
    
    var zyx: Vector3f { return Vector3f(z, y, x) }
    
    var zyw: Vector3f { return Vector3f(z, y, w) }
    
    var zxy: Vector3f { return Vector3f(z, x, y) }
    
    var zxw: Vector3f { return Vector3f(z, x, w) }
    
    var zwy: Vector3f { return Vector3f(z, w, y) }
    
    var zwx: Vector3f { return Vector3f(z, w, x) }
    
}

// RGBA Color
extension Vector4f {
    
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
