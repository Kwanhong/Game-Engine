//
//  Mesh.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

class Mesh: NSObject {
    
    var instanceCount: Int = 1
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) { }
    
}

class ModelMesh: Mesh {
    
    var meshes: [MTKMesh] = []
    
    init(name: String) {
        super.init()
        loadModel(name: name)
    }
    
    func loadModel(name: String) {
        
        if let url = Bundle.main.url(forResource: name, withExtension: "obj") {
            
            let descriptor = MTKModelIOVertexDescriptorFromMetal(Graphics.Desc.vertex[.basic]!)
            
            descriptor.setAttributeName(MDLVertexAttributePosition, atIndex: 0)
            descriptor.setAttributeName(MDLVertexAttributeColor, atIndex: 1)
            descriptor.setAttributeName(MDLVertexAttributeTextureCoordinate, atIndex: 2)
            descriptor.setAttributeName(MDLVertexAttributeNormal, atIndex: 3)
            
            let bufferAlocator = MTKMeshBufferAllocator(device: Engine.device)
            let asset: MDLAsset = MDLAsset(
                url: url,
                vertexDescriptor: descriptor,
                bufferAllocator: bufferAlocator
            )
            
            do {
                self.meshes = try MTKMesh.newMeshes(asset: asset, device: Engine.device).metalKitMeshes
            } catch {
                print("Error, Load mesh failed, \(name), \(error)")
            }
            
        } else {
            print("Error, Load mesh failed, \(name), There's no obj resource")
        }
        
    }
    
    override func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        for mesh in meshes {
            
            for vertexBuffer in mesh.vertexBuffers {
                
                renderCommandEncoder?.setVertexBuffer(
                    vertexBuffer.buffer,
                    offset: vertexBuffer.offset,
                    index: .zero
                )
                
                for submesh in mesh.submeshes {
                    
                    renderCommandEncoder?.drawIndexedPrimitives(
                        type: submesh.primitiveType,
                        indexCount: submesh.indexCount,
                        indexType: submesh.indexType,
                        indexBuffer: submesh.indexBuffer.buffer,
                        indexBufferOffset: submesh.indexBuffer.offset,
                        instanceCount: instanceCount
                    )
                    
                }
                
            }
            
        }
        
    }
    
}

class BuiltInMesh: Mesh {
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
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
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(0.5, 0.0), normal: .init( 0, 1, 0)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0), normal: .init(-1,-1, 0)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 1,-1, 0))
        ]
        
    }
    
    func createBuffers() {
        
        vertexBuffer = Engine.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride(vertices.count),
            options: []
        )
        
    }
    
    override func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
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

class EmptyMesh: BuiltInMesh {
    
    override func createBuffers() { }
    override func createVertices() { self.vertices = [] }
    override func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) { }
    
}

class TriangleBuiltInMesh: BuiltInMesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(0.5, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0), normal: .init(0, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init(0, 0, 1))
        ]
        
    }
    
}

class QuadBuiltInMesh: BuiltInMesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1, 1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init(0, 0, 1)),
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init(0, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init(0, 0, 1))
        ]
        
    }
    
}

class CubeBuiltInMesh: BuiltInMesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init(-1, 0, 0)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init(-1, 0, 0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init(-1, 0, 0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0,-1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 0,-1)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 0,-1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 0,-1, 0)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 1.0), normal: .init( 0,-1, 0)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0), normal: .init( 0,-1, 0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0,-1)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 0.0), normal: .init( 0, 0,-1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 0,-1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init(-1, 0, 0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init(-1, 0, 0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init(-1, 0, 0)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 0,-1, 0)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0,-1, 0)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 1.0), normal: .init( 0,-1, 0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0, 1)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(0.0, 0.0), normal: .init( 0, 0, 1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 0, 1)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 1, 0, 0)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(1.0, 0.0), normal: .init( 1, 0, 0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 1, 0, 0)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(1.0, 0.0), normal: .init( 1, 0, 0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 1, 0, 0)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 1, 0, 0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 1, 0)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 1, 0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 1, 0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 1, 0)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 1, 0)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 0.0), normal: .init( 0, 1, 0)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 0, 1)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0, 1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 0, 1)),
        ]
        
    }
    
}

