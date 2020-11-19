//
//  RenderPipelineDescriptor.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

class RenderPipelineDescriptor: NSObject {
    
    var name: String
    var descriptor: MTLRenderPipelineDescriptor
    
    init(name: String, vertexShaderType: VertexShaderType) {
        
        self.name = name
        
        descriptor = MTLRenderPipelineDescriptor()
        descriptor.colorAttachments[0].pixelFormat = Preferences.mainPixelFormat
        descriptor.depthAttachmentPixelFormat = Preferences.mainDepthPixelFormat
        
        descriptor.vertexFunction = Graphics.Func.vertexShader[vertexShaderType]
        descriptor.fragmentFunction = Graphics.Func.fragmentShader[.basic]
        descriptor.vertexDescriptor = Graphics.Desc.vertex[.basic]
    }
    
}
