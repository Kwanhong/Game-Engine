//
//  RenderPipelineStateLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

enum RenderPipelineStateType {
    case basic
    case instanced
}

class RenderPipelineStateLibrary: GenericLibrary<RenderPipelineStateType, RenderPipelineState> {
    
    var states: [RenderPipelineStateType: MTLRenderPipelineState] = [:]
    
    override internal func initialize() {
        
        let basicState = RenderPipelineState(
            name: "Basic Render Pipeline State",
            type: .basic
        )
        
        library.updateValue(basicState, forKey: .basic)
        states.updateValue(basicState.state, forKey: .basic)
        
        let instancedState = RenderPipelineState(
            name: "Instanced Render Pipeline State",
            type: .instanced
        )
        
        library.updateValue(instancedState, forKey: .instanced)
        states.updateValue(instancedState.state, forKey: .instanced)
        
    }
    
}
