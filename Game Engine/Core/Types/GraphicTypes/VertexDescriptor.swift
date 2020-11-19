//
//  VertexDescriptor.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

struct VertexDescriptorConfig {
    
    var positionFormat: MTLVertexFormat
    var positionBufferIndex: Int
    var positionOffset: Int
    
    var colorFormat: MTLVertexFormat
    var colorBufferIndex: Int
    var colorOffset: Int
    
}

class VertexDescriptor: NSObject {
    
    var name: String
    var descriptor: MTLVertexDescriptor
    
    init(name: String, config: VertexDescriptorConfig) {
        
        self.name = name
        self.descriptor = MTLVertexDescriptor()
        
        // Position
        descriptor.attributes[0].format = config.positionFormat
        descriptor.attributes[0].bufferIndex = config.positionBufferIndex
        descriptor.attributes[0].offset = config.positionOffset
        
        // Color
        descriptor.attributes[1].format = config.colorFormat
        descriptor.attributes[1].bufferIndex = config.colorBufferIndex
        descriptor.attributes[1].offset = config.colorOffset
        
        descriptor.layouts[0].stride = Vertex.stride
        
    }
    
}
