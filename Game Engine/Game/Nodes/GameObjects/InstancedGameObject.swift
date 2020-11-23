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
    
    private var material = Material()
    private var textureType: TextureType = .none
    private var mesh: Mesh!
    private var modelConstantsBuffer: MTLBuffer!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(name: String = "Instanced Game Object", meshType: MeshType, instanceCount count: Int) {
        super.init(name: name)
        self.mesh = Entities.Lib.mesh[meshType]
        self.mesh.instanceCount = count
        self.generateInstances(count: count)
        self.createBuffers(count: count)
        self.start()
    }
    
    private func generateInstances(count: Int) {
        for _ in .zero..<count {
            self.nodes.append(Node())
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
        
        renderCommandEncoder?.setFragmentTexture(Entities.Res.texture[textureType], index: 0)
        
        renderCommandEncoder?.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        renderCommandEncoder?.setFragmentSamplerState(Graphics.State.sampler[.linear], index: 0)
        
        mesh.drawPrimitives(renderCommandEncoder)
    }
    
}

extension InstancedGameObject {
    
    var materialColor: Vector4f {
        get { return self.material.color } set {
            self.material.color = newValue
            self.material.useMaterialColor = true
            self.material.useTexture = false
        }
    }
    
    var materialTextureType: TextureType {
        get { return self.textureType } set {
            self.textureType = newValue
            self.material.useTexture = true
            self.material.useMaterialColor = false
        }
    }
    
    var usePhongShader: Bool {
        set { self.material.usePhongShader = newValue }
        get { return self.material.usePhongShader }
    }
    
    var ambientColor: Vector3f {
        set { self.material.ambient = newValue }
        get { return self.material.ambient }
    }
    
}
