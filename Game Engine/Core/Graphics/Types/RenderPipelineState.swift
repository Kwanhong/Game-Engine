//
//  RenderPipelineState.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

class RenderPipelineState: NSObject {
    
    var name: String
    var state: MTLRenderPipelineState
    
    init(name: String, type: RenderPipelineDescriptorType) {
        
        self.name = name
        
        var renderPipelineState: MTLRenderPipelineState!
        
        do {
            renderPipelineState = try Engine.device.makeRenderPipelineState(
                descriptor: Graphics.Desc.renderPipeline[type]!
            )
            
        } catch {
            print("Error, Make render pipelineState: \(name), \(error)")
        }
        
        self.state = renderPipelineState
        
    }
    
}
