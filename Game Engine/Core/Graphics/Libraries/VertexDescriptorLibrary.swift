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
        
        let positionAttributes = VertexDescriptorAttributesConfig(
            format: .float3, bufferIndex: .zero, offset: .zero
        )
        let colorAttributes = VertexDescriptorAttributesConfig(
            format: .float4, bufferIndex: .zero, offset: Vector3f.size
        )
        let uvMapAttributes = VertexDescriptorAttributesConfig(
            format: .float2, bufferIndex: .zero, offset: Vector3f.size + Vector4f.size
        )
        
        let basicConfig = VertexDescriptorConfig(
            position: positionAttributes, color: colorAttributes, uvMap: uvMapAttributes
        )
        
        let basicDescriptor = VertexDescriptor(
            name: "Basic Vertex Descriptor",
            config: basicConfig
        )
        
        library.updateValue(basicDescriptor, forKey: .basic)
        descriptors.updateValue(basicDescriptor.descriptor, forKey: .basic)
        
    }
    
}
