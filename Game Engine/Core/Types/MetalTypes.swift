//
//  MetalTypes.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/28.
//

import simd

typealias Vector2f = simd_float2
typealias Vector3f = simd_float3
typealias Vector4f = simd_float4
typealias Matrix4x4f = matrix_float4x4

protocol Sizable {
    static func size(_ count: Int)->Int
    static func stride(_ count: Int)->Int
}

extension Bool: Sizable { }

extension Float: Sizable { }

extension Vector3f: Sizable { }

extension Sizable {
    static func size(_ count: Int = 1)->Int {
        return MemoryLayout<Self>.size * count
    }
    static func stride(_ count: Int = 1)->Int {
        return MemoryLayout<Self>.stride * count
    }
    static var size: Int {
        return size()
    }
    static var stride: Int {
        return stride()
    }
}

// Shader Constants

struct Vertex: Sizable {
    var position: Vector3f
    var color: Vector4f
}

struct SceneConstants: Sizable {
    var viewMatrix: Matrix4x4f = .identity
    var projectionMatrix: Matrix4x4f = .identity
}

struct ModelConstants: Sizable {
    var modelMatrix: Matrix4x4f = .identity
}

struct Material: Sizable {
    var color: Vector4f = .init(0.8, 0.8, 0.8, 1)
    var useMaterialColor: Bool = false
}
