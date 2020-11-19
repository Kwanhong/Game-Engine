//
//  Mesh.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

class Mesh: NSObject {
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    var instanceCount: Int = 1
    var vertexCount: Int! {
        return vertices.count
    }
    
    override init() {
        
        super.init()
        self.createVertices()
        self.createBuffers()
        
    }
    
    func createVertices() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(0.5, 0.0)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0))
        ]
        
    }
    
    func createBuffers() {
        
        vertexBuffer = Engine.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride(vertices.count),
            options: []
        )
        
    }
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        renderCommandEncoder?.setVertexBuffer(
            vertexBuffer,
            offset: 0, index: 0
        )
        
        renderCommandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: .zero,
            vertexCount: vertexCount,
            instanceCount: instanceCount
        )
        
    }
    
}

class TriangleMesh: Mesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(0.5, 0.0)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0))
        ]
        
    }
    
}

class QuadMesh: Mesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init(-1, 1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1, 0), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 1.0))
        ]
        
    }
    
}

class CubeMesh: Mesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0)),
            
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 1.0)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0)),
        
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 1.0)),
        
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(1.0, 1.0)),
        
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(1.0, 1.0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0)),
        
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 0.0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 0.0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 1.0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(1.0, 0.0)),
        ]
        
    }
    
}

