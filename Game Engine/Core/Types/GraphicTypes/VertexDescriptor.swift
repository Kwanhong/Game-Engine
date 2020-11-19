//
//  VertexDescriptor.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

struct VertexDescriptorAttributesConfig {
    
    var format: MTLVertexFormat
    var bufferIndex: Int
    var offset: Int
    
}

struct VertexDescriptorConfig {
    
    var position: VertexDescriptorAttributesConfig
    var color: VertexDescriptorAttributesConfig
    var uvMap: VertexDescriptorAttributesConfig
    
}

class VertexDescriptor: NSObject {
    
    var name: String
    var descriptor: MTLVertexDescriptor
    
    init(name: String, config: VertexDescriptorConfig) {
        
        self.name = name
        self.descriptor = MTLVertexDescriptor()
        
        // Position
        descriptor.attributes[0].format = config.position.format
        descriptor.attributes[0].bufferIndex = config.position.bufferIndex
        descriptor.attributes[0].offset = config.position.offset
        
        // Color
        descriptor.attributes[1].format = config.color.format
        descriptor.attributes[1].bufferIndex = config.color.bufferIndex
        descriptor.attributes[1].offset = config.color.offset
        
        // UVMap
        descriptor.attributes[2].format = config.uvMap.format
        descriptor.attributes[2].bufferIndex = config.uvMap.bufferIndex
        descriptor.attributes[2].offset = config.uvMap.offset
        
        descriptor.layouts[0].stride = Vertex.stride
        
    }
    
}