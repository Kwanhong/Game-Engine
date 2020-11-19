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
        
        let basicConfig = VertexDescriptorConfig(
            positionFormat: .float3,
            positionBufferIndex: .zero,
            positionOffset: .zero,
            colorFormat: .float4,
            colorBufferIndex: .zero,
            colorOffset: Vector3f.size
        )
        
        let basicDescriptor = VertexDescriptor(
            name: "Basic Vertex Descriptor",
            config: basicConfig
        )
        
        library.updateValue(basicDescriptor, forKey: .basic)
        descriptors.updateValue(basicDescriptor.descriptor, forKey: .basic)
    }
    
}
