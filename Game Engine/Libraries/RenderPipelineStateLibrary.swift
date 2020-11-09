//
//  RenderPipelineStateLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

enum RenderPipelineStateType {
    case basic
}

class RenderPipelineStateLibrary {
    
    private static var renderPipelineStates: [RenderPipelineStateType: RenderPipelineState] = [:]
    
    static func initialize() {
        createDefaultRenderPipelineStates()
    }
    
    private static func createDefaultRenderPipelineStates() {
        renderPipelineStates.updateValue(BasicRenderPipelineState(), forKey: .basic)
    }
    
    static func getRenderPipelineState(_ type: RenderPipelineStateType)->MTLRenderPipelineState {
        return renderPipelineStates[type]!.renderPipelineState
    }
}

protocol RenderPipelineState {
    var name: String { get }
    var renderPipelineState: MTLRenderPipelineState { get }
}

struct BasicRenderPipelineState: RenderPipelineState {
    var name: String = "BasicRenderPipelineState"
    var renderPipelineState: MTLRenderPipelineState
    
    init() {
        
        var renderPipelineState: MTLRenderPipelineState!
        
        do {
            renderPipelineState = try Engine.device.makeRenderPipelineState(
                descriptor: RenderPipelineDescriptorLibrary.getRenderPipelineDescriptor(.basic)
            )
        } catch {
            print("Error, Make Render pipelineState: \(name), \(error)")
        }
        
        self.renderPipelineState = renderPipelineState
    }
}

