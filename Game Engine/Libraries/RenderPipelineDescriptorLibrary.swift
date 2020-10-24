//
//  RenderPiplineDescriptor.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

enum RenderPipelineDescriptorType {
    case basic
}

class RenderPipelineDescriptorLibrary {
    
    private static var renderPipelineDescriptors: [RenderPipelineDescriptorType: RenderPipelineDescriptor] = [:]
    
    static func initialize() {
        createDefaultRenderPipelineDescriptors()
    }
    
    private static func createDefaultRenderPipelineDescriptors() {
        renderPipelineDescriptors.updateValue(BasicRenderPipelineDescriptor(), forKey: .basic)
    }
    
    static func getRenderPipelineDescriptor(_ type: RenderPipelineDescriptorType)->MTLRenderPipelineDescriptor {
        return renderPipelineDescriptors[type]!.renderPipelineDescriptor
    }
}

protocol RenderPipelineDescriptor {
    var name: String { get }
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor { get }
}

struct BasicRenderPipelineDescriptor : RenderPipelineDescriptor {
    var name: String = "BasicRenderPipelineDescriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor {
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = Preferences.mainPixelFormat
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.getVertexFunction(.basic)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.getFragmentFunction(.basic)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.getVertexDescriptor(.basic)
        
        return renderPipelineDescriptor
    }
}

