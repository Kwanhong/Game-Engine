//
//  GameView.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/28.
//

import MetalKit

class GameView: MTKView {
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        Engine.Ignite(device: device!)
        
        self.clearColor = Preferences.clearColor
        self.colorPixelFormat = Preferences.mainPixelFormat
        
        createVertices()
        createBuffers()
        
    }
    
    func createVertices() {
        
        vertices = [
            .init(position: .init( 0,  1, 0), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1, -1, 0), color: .init(0, 1, 0, 1)),
            .init(position: .init( 1, -1, 0), color: .init(0, 0, 1, 1))
        ]
        
    }
    
    func createBuffers() {
        
        vertexBuffer = Engine.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride(vertices.count),
            options: []
        )
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        guard let drawable = self.currentDrawable,
              let renderPassDescriptor = self.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = Engine.commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )
        
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.getRenderPipelineState(.basic))
        
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: vertices.count
        )
        
        renderCommandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
}
