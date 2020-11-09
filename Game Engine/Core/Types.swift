//
//  Types.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/28.
//

import simd

protocol Sizable {
    static func size(_ count: Int)->Int
    static func stride(_ count: Int)->Int
}

extension Sizable {
    static func size(_ count: Int = 1)->Int {
        return MemoryLayout<Self>.size * count
    }
    static func stride(_ count: Int = 1)->Int {
        return MemoryLayout<Self>.size * count
    }
}

struct Vertex: Sizable {
    var position: simd_float3
    var color: simd_float4
}

struct ModelConstants: Sizable {
    var modelMatrix = matrix_identity_float4x4
}

extension simd_float3: Sizable { }
extension Float: Sizable { }
