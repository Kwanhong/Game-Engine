//
//  Renderer.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    
    public static var screenCenter: Vector2f = .zero
    public static var screenSize: Vector2f = .zero
    public static var aspectRatio: Float {
        return screenSize.x / screenSize.y
    }
    
    required init(_ view: MTKView) {
        super.init()
        self.updateScreenSize(view: view)
    }
    
}

extension Renderer: MTKViewDelegate {
    
    private func updateScreenCenter(view: MTKView) {
        if let frame = view.window?.frame,
           let height = NSScreen.main?.frame.height {
            
            Renderer.screenCenter = Vector2f(
                Float(frame.midX),
                Float(height - frame.minY) - Renderer.screenSize.y / 2
            )
        }
    }
    
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
        
        updateScreenCenter(view: view)
        
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = Engine.commandQueue.makeCommandBuffer()
        commandBuffer?.label = "Game Engine Command Buffer"
        
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )
        renderCommandEncoder?.label = "Game Engine Render Command Encoder"
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        SceneManager.tickScene(renderCommandEncoder: renderCommandEncoder, deltaTime: deltaTime)
        Mouse.lateUpdate()
        
        renderCommandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}
