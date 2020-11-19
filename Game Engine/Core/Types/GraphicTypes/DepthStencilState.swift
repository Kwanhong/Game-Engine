//
//  DepthStencilState.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

struct DepthStencilStateConfig {
    
    var isDepthWriteEnabled: Bool
    var depthCompareFunction: MTLCompareFunction
    
}

class DepthStencilState: NSObject {
    
    var name: String
    var state: MTLDepthStencilState?
    
    init(name: String, config: DepthStencilStateConfig) {
        
        self.name = name
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.isDepthWriteEnabled = config.isDepthWriteEnabled
        descriptor.depthCompareFunction = config.depthCompareFunction
        state = Engine.device.makeDepthStencilState(descriptor: descriptor)
        
    }
}
