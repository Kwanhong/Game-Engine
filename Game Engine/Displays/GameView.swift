//
//  GameView.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/28.
//

import MetalKit

class GameView: MTKView {
    
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.clearColor = MTLClearColor(red: 0.17, green: 0.18, blue: 0.28, alpha: 1)
        self.colorPixelFormat = .bgra8Unorm
        
        self.commandQueue = device?.makeCommandQueue()
        createRenderPipelineState()
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
        
        vertexBuffer = device?.makeBuffer(
            bytes: vertices,
            length: Vertex.stride(vertices.count),
            options: []
        )
        
    }
    
    func createRenderPipelineState() {
        
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        // Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        // Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = simd_float3.size()
        
        vertexDescriptor.layouts[0].stride = Vertex.stride()
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        guard let drawable = self.currentDrawable,
              let renderPassDescriptor = self.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
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
