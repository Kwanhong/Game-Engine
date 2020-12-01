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

class VertexDescriptorLibrary: GenericLibrary<VertexDescriptorType, VertexDescriptor> {
    
    var descriptors: [VertexDescriptorType: MTLVertexDescriptor] = [:]
    
    override internal func initialize() {
        
        var offset = Int.zero
        let positionAttributes = VertexDescriptorAttributesConfig(
            format: .float3, bufferIndex: .zero, offset: offset
        ); offset += Vector3f.size
        let colorAttributes = VertexDescriptorAttributesConfig(
            format: .float4, bufferIndex: .zero, offset: offset
        ); offset += Vector4f.size
        let texcoordAttributes = VertexDescriptorAttributesConfig(
            format: .float2, bufferIndex: .zero, offset: offset
        ); offset += Vector3f.size
        let normalAttributes = VertexDescriptorAttributesConfig(
            format: .float3, bufferIndex: .zero, offset: offset
        ); offset += Vector3f.size
        let tangentAttributes = VertexDescriptorAttributesConfig(
            format: .float3, bufferIndex: .zero, offset: offset
        ); offset += Vector3f.size
        let bitangentAttributes = VertexDescriptorAttributesConfig(
            format: .float3, bufferIndex: .zero, offset: offset
        )
        
        let basicConfig = VertexDescriptorConfig(
            position: positionAttributes,
            color: colorAttributes,
            texcoord: texcoordAttributes,
            normal: normalAttributes,
            tangent: tangentAttributes,
            bitangent: bitangentAttributes
        )
        
        let basicDescriptor = VertexDescriptor(
            name: "Basic Vertex Descriptor",
            config: basicConfig
        )
        
        library.updateValue(basicDescriptor, forKey: .basic)
        descriptors.updateValue(basicDescriptor.descriptor, forKey: .basic)
        
    }
    
}
