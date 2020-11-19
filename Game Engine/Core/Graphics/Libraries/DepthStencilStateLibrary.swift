//
//  DepthStencilStateLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit

enum DepthStencilStateType {
    case less
}

class DepthStencilStateLibrary: GenericLibrary<DepthStencilStateType, DepthStencilState> {
    
    var states: [DepthStencilStateType: MTLDepthStencilState] = [:]
    
    override internal func initialize() {
        
        let config = DepthStencilStateConfig(
            isDepthWriteEnabled: true,
            depthCompareFunction: .less
        )
        
        let lessState = DepthStencilState(
            name: "Less Depth Stencil State",
            config: config
        )
        
        library.updateValue(lessState, forKey: .less)
        states.updateValue(lessState.state!, forKey: .less)
        
    }

}
