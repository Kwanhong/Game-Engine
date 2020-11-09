//
//  Engine.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

class Engine {
    
    public static var device: MTLDevice!
    public static var commandQueue: MTLCommandQueue!
    
    public static func Ignite(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        
        ShaderLibrary.initialize()
        VertexDescriptorLibrary.initialize()
        RenderPipelineDescriptorLibrary.initialize()
        RenderPipelineStateLibrary.initialize()
        MeshLibrary.initialize()
        SceneManager.initialize(Preferences.startingSceneType)
    }
    
}
