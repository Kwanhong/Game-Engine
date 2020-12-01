//
//  InstancedGameObject.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/14.
//

import Foundation
import MetalKit

class InstancedGameObject: Node {
    
    var nodes: [Node] = []
    
    private var baseMaterial: Material? = .standard
    private var baseTextureType: TextureType = .none
    private var baseNormalMapType: TextureType = .none
    
    private var mesh: Mesh!
    private var modelConstantsBuffer: MTLBuffer!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(name: String = "Instanced Game Object", meshType: MeshType, instanceCount count: Int) {
        super.init(name: name)
        self.mesh = Entities.Lib.mesh[meshType]
        self.mesh.setInstanceCount(count)
        self.generateInstances(count: count)
        self.createBuffers(count: count)
        self.start()
    }
    
    private func generateInstances(count: Int) {
        for _ in .zero..<count {
            self.nodes.append(Node(name: "\(name) (Instanced Node)"))
        }
    }
    
    private func createBuffers(count: Int) {
        modelConstantsBuffer = Engine.device.makeBuffer(
            length: ModelConstants.stride(count), options: []
        )
    }
    
    private func updateModelConstantsBuffer() {
        
        var pointer = modelConstantsBuffer.contents().bindMemory(
            to: ModelConstants.self, capacity: nodes.count
        )
        
        for node in nodes {
            pointer.pointee.modelMatrix = .mutliply(modelMatrix, with: node.modelMatrix)
            pointer = pointer.advanced(by: 1)
        }
        
    }
    
    override func update(deltaTime: Float) {
        self.deltaTimeContainer = deltaTime
        self.update()
        self.updateModelConstantsBuffer()
        super.update(deltaTime: deltaTime)
        self.lateUpdate()
    }
    
    internal func start() { }
    
    internal func update() { }
    
    internal func lateUpdate() { }
    
}

extension InstancedGameObject: Renderable {
    
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        renderCommandEncoder?.setRenderPipelineState(Graphics.State.renderPipeline[.instanced]!)
        
        renderCommandEncoder?.setDepthStencilState(Graphics.State.depthStencil[.less])
        
        renderCommandEncoder?.setVertexBuffer(modelConstantsBuffer, offset: 0, index: 2)
        
        renderCommandEncoder?.setFragmentSamplerState(Graphics.State.sampler[.linear], index: 0)
        
        mesh.drawPrimitives(
            renderCommandEncoder,
            baseTextureType: baseTextureType,
            baseNormalMapType: baseNormalMapType,
            baseMaterial: baseMaterial
        )
        
    }
    
}

extension InstancedGameObject {
    
    func setUserTexture(type: TextureType) {
        self.baseTextureType = type
    }
    
    func setUserMaterial(material: Material?) {
        self.baseMaterial = material
    }
    
    func setUserNormalMap(type: TextureType) {
        self.baseNormalMapType = type
    }
    
    func useModelGraphics() {
        self.setUserTexture(type: .modelDefault)
        self.setUserNormalMap(type: .modelDefault)
        self.setUserMaterial(material: .modelMaterial)
    }
    
    var material: Material? {
        return self.baseMaterial
    }
    
    var textureType: TextureType {
        return self.baseTextureType
    }
    
    var normalMapType: TextureType {
        return self.baseNormalMapType
    }
    
    var isLit: Bool {
        set { self.baseMaterial?.isLit = newValue }
        get { return self.baseMaterial?.isLit ?? false }
    }
    
}
