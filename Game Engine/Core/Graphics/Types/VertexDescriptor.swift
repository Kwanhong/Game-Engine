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
    var texcoord: VertexDescriptorAttributesConfig
    var normal: VertexDescriptorAttributesConfig
    var tangent: VertexDescriptorAttributesConfig
    var bitangent: VertexDescriptorAttributesConfig
    
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
        
        // Texture Coordinates
        descriptor.attributes[2].format = config.texcoord.format
        descriptor.attributes[2].bufferIndex = config.texcoord.bufferIndex
        descriptor.attributes[2].offset = config.texcoord.offset
        
        // Normal
        descriptor.attributes[3].format = config.normal.format
        descriptor.attributes[3].bufferIndex = config.normal.bufferIndex
        descriptor.attributes[3].offset = config.normal.offset
        
        // Tangent
        descriptor.attributes[4].format = config.tangent.format
        descriptor.attributes[4].bufferIndex = config.tangent.bufferIndex
        descriptor.attributes[4].offset = config.tangent.offset
        
        // Bitangent
        descriptor.attributes[5].format = config.bitangent.format
        descriptor.attributes[5].bufferIndex = config.bitangent.bufferIndex
        descriptor.attributes[5].offset = config.bitangent.offset
        
        descriptor.layouts[0].stride = Vertex.stride
        
    }
    
}

extension MDLVertexDescriptor {
    
    func setAttributeName(_ name: String, atIndex index: Int) {
        (attributes[index] as? MDLVertexAttribute)?.name = name
    }
    
}
