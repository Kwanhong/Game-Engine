//
//  Mesh.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

import MetalKit

class Mesh: NSObject {
    
    internal var vertices: [Vertex] = []
    private var vertexCount: Int = .zero
    private var vertexBuffer: MTLBuffer!
    
    internal var submeshes: [Submesh] = []
    private var instanceCount: Int = 1
    
    override init() {
        super.init()
        createMesh()
        updateVertexCount()
        createBuffer()
    }
    
    init(name: String) {
        super.init()
        createFromModel(name)
    }
    
    public func setInstanceCount(_ count: Int) {
        instanceCount = count
    }
    
    private func updateVertexCount() {
        vertexCount = vertices.count
    }
    
    internal func createMesh() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(0.5, 0.0), normal: .init( 0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 0, 1))
        ]
        
        submeshes.append(.init(indices: [0, 1, 2]))
        
    }
    
    internal func createBuffer() {
        
        if vertexCount > 0 {
            
            vertexBuffer = Engine.device.makeBuffer(
                bytes: vertices,
                length: Vertex.stride(vertexCount),
                options: []
            )
            
        }
        
    }
    
    internal func createFromModel(_ name: String, ext: String = "obj") {
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            
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
            
            var meshes: [MTKMesh] = []
            
            do {
                meshes = try MTKMesh.newMeshes(asset: asset, device: Engine.device).metalKitMeshes
            } catch {
                print("Error, Load mesh failed, \(name), \(error)")
            }
            
            if let mesh = meshes.first {
                
                self.vertexBuffer = mesh.vertexBuffers.first?.buffer
                self.vertexCount = mesh.vertexCount
                
                for submesh in mesh.submeshes {
                    self.addSubmesh(Submesh(mtkSubmesh: submesh))
                }
                
            }
            
        } else {
            print("Error, Load mesh failed, \(name), There's no obj resource")
        }
        
    }
    
    internal func addSubmesh(_ submesh: Submesh) {
        submeshes.append(submesh)
    }
    
    public func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        if vertexCount <= 0 { return }
        
        renderCommandEncoder?.setVertexBuffer(
            vertexBuffer,
            offset: 0, index: 0
        )
        
        if submeshes.count > 0 {
            
            for submesh in submeshes {
                
                if submesh.indexCount <= 0 { continue }
                
                renderCommandEncoder?.drawIndexedPrimitives(
                    type: submesh.primitiveType,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer,
                    indexBufferOffset: submesh.indexBufferOffset
                )
            }
            
        } else {
            
            renderCommandEncoder?.drawPrimitives(
                type: .triangle,
                vertexStart: .zero,
                vertexCount: vertexCount,
                instanceCount: instanceCount
            )
            
        }
        
    }
    
    
}

class Submesh {
    
    private var indices: [UInt32] = []
    
    private var indexCountContainer: Int = .zero
    public var indexCount: Int {
        set {
            indexCountContainer = newValue
        }
        get {
            if indices.count == .zero {
                return indexCountContainer
            } else {
                return indices.count
            }
        }
    }
    
    private var indexBufferContainer: MTLBuffer!
    public var indexBuffer: MTLBuffer {
        return indexBufferContainer
    }
    
    private var primitiveTypeContainer: MTLPrimitiveType = .triangle
    public var primitiveType: MTLPrimitiveType {
        return primitiveTypeContainer
    }
    
    private var indexTypeContainer: MTLIndexType = .uint32
    public var indexType: MTLIndexType {
        return indexTypeContainer
    }
    
    private var indexBufferOffsetContainer: Int = .zero
    public var indexBufferOffset: Int {
        return indexBufferOffsetContainer
    }
    
    init(indices: [UInt32]) {
        self.indices = indices
        createIndexBuffer()
    }
    
    init(mtkSubmesh: MTKSubmesh) {
        indexBufferContainer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffsetContainer = mtkSubmesh.indexBuffer.offset
        indexCount = mtkSubmesh.indexCount
        indexTypeContainer = mtkSubmesh.indexType
        primitiveTypeContainer = mtkSubmesh.primitiveType
    }
    
    private func setIndexCount(_ count: Int) {
        self.indexCount = count
    }
    
    func createIndexBuffer() {
        
        if indexCount > 0 {
            indexBufferContainer = Engine.device.makeBuffer(
                bytes: indices,
                length: UInt32.stride(indexCount),
                options: []
            )
        }
        
    }
    
}

class EmptyMesh: Mesh { }

class TriangleBuiltInMesh: Mesh {
    
    override func createMesh() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(0.5, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 1.0), normal: .init(0, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init(0, 0, 1))
        ]
        
    }
    
}

class QuadBuiltInMesh: Mesh {
    
    override func createMesh() {
        
        vertices = [
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1), texcoord: .init(1.0, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1, 1, 0), color: .init(0, 1, 0, 1), texcoord: .init(0.0, 0.0), normal: .init(0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init(0, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(1, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init(0, 0, 1))
        ]
        
        submeshes.append(.init(indices: [
            0, 1, 2, 0, 2, 3
        ]))
        
    }
    
}

class CubeBuiltInMesh: Mesh {
    
    override func createMesh() {
        
        vertices = [
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init( 0, 0,-1)), // Back
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0,-1)), // Back
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 0,-1)), // Back
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 0,-1)), // Back
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0,-1)), // Back
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0,-1)), // Back
            
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0), normal: .init( 1, 0, 0)), // Right
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 1, 0, 0)), // Right
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 1, 0, 0)), // Right
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 1, 0, 0)), // Right
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 1, 0, 0)), // Right
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 1, 0, 0)), // Right
            
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 0, 0, 1)), // Front
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 0, 1)), // Front
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0, 1)), // Front
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 0, 1)), // Front
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0, 0, 1)), // Front
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 0, 1)), // Front
            
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init(-1, 0, 0)), // Left
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init(-1, 0, 0)), // Left
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init(-1, 0, 0)), // Left
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init(-1, 0, 0)), // Left
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init(-1, 0, 0)), // Left
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init(-1, 0, 0)), // Left
            
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 1, 0)), // Top
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 1, 0)), // Top
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 1, 0)), // Top
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init( 0, 1, 0)), // Top
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 1, 0)), // Top
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init( 0, 1, 0)), // Top
            
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0,-1, 0)), // Bottom
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 0,-1, 0)), // Bottom
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init( 0,-1, 0)), // Bottom
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init( 0,-1, 0)), // Bottom
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init( 0,-1, 0)), // Bottom
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0), normal: .init( 0,-1, 0))  // Bottom
        ]
        
    }
    
}

class SkyBoxBuiltInMesh: Mesh {
    
    override func createMesh() {
        
        vertices = [
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1), texcoord: .init(0.0, 0.0), normal: .init( 0.58, 0.58, 0.58)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1), texcoord: .init(0.0, 1.0), normal: .init(-0.58, 0.58, 0.58)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1), texcoord: .init(0.0, 1.0), normal: .init(-0.58,-0.58, 0.58)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1), texcoord: .init(1.0, 1.0), normal: .init( 0.58,-0.58, 0.58)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1), texcoord: .init(1.0, 0.0), normal: .init( 0.58, 0.58,-0.58)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1), texcoord: .init(0.0, 0.0), normal: .init(-0.58, 0.58,-0.58)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1), texcoord: .init(0.0, 1.0), normal: .init(-0.58,-0.58,-0.58)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1), texcoord: .init(1.0, 1.0), normal: .init( 0.58,-0.58,-0.58))
        ]
        
        submeshes.append(.init(indices: [
            0, 1, 3, 3, 1, 2,
            1, 5, 2, 2, 5, 6,
            5, 4, 6, 6, 4, 7,
            4, 0, 7, 7, 0, 3,
            3, 2, 7, 7, 2, 6,
            4, 5, 0, 0, 5, 1
        ]))
        
    }
    
}

