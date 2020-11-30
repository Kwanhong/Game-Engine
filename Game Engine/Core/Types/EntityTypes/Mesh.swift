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
            
            asset.loadTextures()
            
            var mtkmeshes: [MTKMesh] = []
            var mdlmeshes: [MDLMesh] = []
            
            do {
                let meshes = try MTKMesh.newMeshes(asset: asset, device: Engine.device)
                mtkmeshes = meshes.metalKitMeshes
                mdlmeshes = meshes.modelIOMeshes
            } catch {
                print("Error, Load mesh failed, \(name), \(error)")
            }
            
            if let mtkmesh = mtkmeshes.first,
               let mdlmesh = mdlmeshes.first {
                
                self.vertexBuffer = mtkmesh.vertexBuffers.first?.buffer
                self.vertexCount = mtkmesh.vertexCount
                
                for i in 0..<mtkmesh.submeshes.count {
                    let mtksubmesh = mtkmesh.submeshes[i]
                    let mdlsubmesh = mdlmesh.submeshes![i] as! MDLSubmesh
                    self.addSubmesh(Submesh(mtkSubmesh: mtksubmesh, mdlSubmesh: mdlsubmesh))
                }
                
            }
            
        } else {
            print("Error, Load mesh failed, \(name), There's no obj resource")
        }
        
    }
    
    internal func addSubmesh(_ submesh: Submesh) {
        submeshes.append(submesh)
    }
    
    public func drawPrimitives(
        _ renderCommandEncoder: MTLRenderCommandEncoder?,
        baseTextureType: TextureType = .none,
        baseMaterial: Material? = nil
    ) {
        
        if vertexCount <= 0 { return }
        
        renderCommandEncoder?.setVertexBuffer(
            vertexBuffer,
            offset: 0, index: 0
        )
        
        if submeshes.count > 0 {
            
            for submesh in submeshes {
                
                if submesh.indexCount <= 0 { continue }
                
                submesh.applyTexture(
                    renderCommandEncoder: renderCommandEncoder,
                    textureType: baseTextureType
                )
                
                submesh.applyMaterial(
                    renderCommandEncoder: renderCommandEncoder,
                    material: baseMaterial
                )
                
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

    private var material = Material()
    private var baseColorTexture: MTLTexture!
    
    init(indices: [UInt32]) {
        self.indices = indices
        createIndexBuffer()
    }
    
    init(mtkSubmesh: MTKSubmesh, mdlSubmesh: MDLSubmesh) {
        indexBufferContainer = mtkSubmesh.indexBuffer.buffer
        indexBufferOffsetContainer = mtkSubmesh.indexBuffer.offset
        indexCount = mtkSubmesh.indexCount
        indexTypeContainer = mtkSubmesh.indexType
        primitiveTypeContainer = mtkSubmesh.primitiveType
        createTexture(mdlSubmesh.material!)
        createMaterial(mdlSubmesh.material!)
    }
    
    private func setIndexCount(_ count: Int) {
        self.indexCount = count
    }
    
    private func createIndexBuffer() {
        
        if indexCount > 0 {
            indexBufferContainer = Engine.device.makeBuffer(
                bytes: indices,
                length: UInt32.stride(indexCount),
                options: []
            )
        }
        
    }
    
    private func getTexture(
        for semantic: MDLMaterialSemantic,
        in material: MDLMaterial,
        textureOrigin: MTKTextureLoader.Origin
    )->MTLTexture? {
        
        let textureLoader = MTKTextureLoader(device: Engine.device)
        guard let materialProperty = material.property(with: semantic),
              let sourceTexture = materialProperty.textureSamplerValue?.texture else {
            return nil
        }
        
        let options: [MTKTextureLoader.Option: Any] = [
            .origin: textureOrigin as Any,
            .generateMipmaps: true
        ]
        
        let tex = try? textureLoader.newTexture(texture: sourceTexture, options: options)
        return tex
        
    }
    
    private func createTexture(_ material: MDLMaterial) {
        
        baseColorTexture = getTexture(for: .baseColor, in: material, textureOrigin: .bottomLeft)
        
    }
    
    private func createMaterial(_ material: MDLMaterial) {
        
        if let ambient = material.property(with: .emission)?.float3Value {
            self.material.ambient = ambient
        }
        if let diffuse = material.property(with: .baseColor)?.float3Value {
            self.material.diffuse = diffuse
        }
        if let specular = material.property(with: .specular)?.float3Value {
            self.material.specular = specular
        }
        if let shininess = material.property(with: .specularExponent)?.floatValue {
            self.material.shininess = shininess
        }
        
    }
    
    func applyTexture(renderCommandEncoder: MTLRenderCommandEncoder?, textureType: TextureType) {
        
        let baseColorTex = textureType == .modelTexture ? baseColorTexture : Entities.Res.texture[textureType]
        renderCommandEncoder?.setFragmentSamplerState(Graphics.State.sampler[.linear], index: .zero)
        renderCommandEncoder?.setFragmentTexture(baseColorTex, index: .zero)
        
    }
    
    func applyMaterial(renderCommandEncoder: MTLRenderCommandEncoder?, material userCustomManterial: Material?) {
        
        var material = userCustomManterial ?? self.material
        renderCommandEncoder?.setFragmentBytes(&material, length: Material.stride, index: 1)
        
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

