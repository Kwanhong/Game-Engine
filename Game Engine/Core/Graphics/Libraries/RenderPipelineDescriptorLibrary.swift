//
//  RenderPiplineDescriptor.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

enum RenderPipelineDescriptorType {
    case basic
    case instanced
}

class RenderPipelineDescriptorLibrary: GenericLibrary<RenderPipelineDescriptorType, RenderPipelineDescriptor> {
    
    var descriptors: [RenderPipelineDescriptorType: MTLRenderPipelineDescriptor] = [:]
    
    override internal func initialize() {
        
        let basicDescriptor = RenderPipelineDescriptor(
            name: "Basic Render Pipeline Descriptor",
            vertexShaderType: .basic
        )
        
        library.updateValue(basicDescriptor, forKey: .basic)
        descriptors.updateValue(basicDescriptor.descriptor, forKey: .basic)
        
        let instancedDescriptor = RenderPipelineDescriptor(
            name: "Instanced Render Pipeline Descriptor",
            vertexShaderType: .instanced
        )
        
        library.updateValue(instancedDescriptor, forKey: .instanced)
        descriptors.updateValue(instancedDescriptor.descriptor, forKey: .instanced)
        
    }
    
}
