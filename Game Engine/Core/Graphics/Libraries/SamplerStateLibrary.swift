//
//  SamplerStateLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/20.
//

import MetalKit

enum SamplerStateType {
    
    case linear
    
}

class SamplerStateLibrary: GenericLibrary<SamplerStateType, SamplerState> {
    
    var states: [SamplerStateType: MTLSamplerState] = [:]
    
    override func initialize() {
        
        let linearState = SamplerState(
            name: "Linear Sampler State",
            min: .linear, max: .linear
        )
        
        library.updateValue(linearState, forKey: .linear)
        states.updateValue(linearState.state, forKey: .linear)
        
    }
    
}

class SamplerState: NSObject {
    
    var name: String
    var state: MTLSamplerState
    
    init(name: String, min: MTLSamplerMinMagFilter, max: MTLSamplerMinMagFilter) {
        self.name = name
        
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = min
        descriptor.magFilter = max
        descriptor.label = name
        self.state = Engine.device.makeSamplerState(descriptor: descriptor)!
        
    }
    
}
