//
//  VertexDescriptiorLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

enum VertexDescriptorType {
    case basic
}

class VertexDescriptorLibrary {
    
    private static var vertexDescriptors: [VertexDescriptorType: VertexDescriptor] = [:]
    
    static func initialize() {
        createDefaultVertexDescriptors()
    }
    
    private static func createDefaultVertexDescriptors() {
        vertexDescriptors.updateValue(BasicVertexDescriptor(), forKey: .basic)
    }
    
    static func getVertexDescriptor(_ type: VertexDescriptorType)->MTLVertexDescriptor {
        return vertexDescriptors[type]!.vertexDescriptor
    }
}

protocol VertexDescriptor {
    
    var name: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
    
}

struct BasicVertexDescriptor: VertexDescriptor {
    
    var name: String = "BasicVertexDescriptor"
    var vertexDescriptor: MTLVertexDescriptor
    
    init() {
        
        vertexDescriptor = MTLVertexDescriptor()
        
        // Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        // Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = simd_float3.size()
        
        vertexDescriptor.layouts[0].stride = Vertex.stride()
    }
    
}
