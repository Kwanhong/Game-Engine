//
//  Renderer.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    
    public static var screenSize: Vector2f = .zero
    
    required init(_ view: MTKView) {
        super.init()
        self.updateScreenSize(view: view)
    }
    
}

extension Renderer: MTKViewDelegate {
    
    private func updateScreenSize(view: MTKView) {
        Renderer.screenSize = Vector2f(
            Float(view.bounds.width),
            Float(view.bounds.height)
        )
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateScreenSize(view: view)
    }
    
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = Engine.commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        SceneManager.tickScene(renderCommandEncoder: renderCommandEncoder, deltaTime: deltaTime)
        
        renderCommandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}
