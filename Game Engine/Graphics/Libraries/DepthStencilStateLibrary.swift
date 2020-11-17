//
//  DepthStencilStateLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit

class DepthStencilStateLibrary {
    
    private static var depthStencilStates: [DepthStencilStateType: DepthStencilState] = [:]
    
    public static func initialize() {
        createDefaultDepthStencilStates()
    }
    
    private static func createDefaultDepthStencilStates() {
        depthStencilStates.updateValue(LessDepthStencilState(), forKey: .less)
    }
    
    public static func getDepthStencilState(
        _ type: DepthStencilStateType
    )->MTLDepthStencilState? {
        return depthStencilStates[type]?.depthStencilState
    }
    
}

protocol DepthStencilState {
    var depthStencilState: MTLDepthStencilState! { get }
}

class LessDepthStencilState: DepthStencilState {
    
    var depthStencilState: MTLDepthStencilState!
    
    init() {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.isDepthWriteEnabled = true
        descriptor.depthCompareFunction = .less
        depthStencilState = Engine.device.makeDepthStencilState(descriptor: descriptor)
    }
    
}
