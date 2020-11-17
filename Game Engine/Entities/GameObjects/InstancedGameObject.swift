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
    private var mesh: Mesh!
    private var modelConstantsBuffer: MTLBuffer!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(meshType: MeshType, instanceCount count: Int) {
        super.init()
        self.mesh = MeshLibrary.getMesh(meshType)
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
        
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.getRenderPipelineState(.instanced))
        
        renderCommandEncoder?.setDepthStencilState(DepthStencilStateLibrary.getDepthStencilState(.less))
        
        renderCommandEncoder?.setVertexBuffer(modelConstantsBuffer, offset: 0, index: 2)
        
        renderCommandEncoder?.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        mesh.drawPrimitives(renderCommandEncoder)
    }
    
}

extension InstancedGameObject {
    
    public func setColor(_ color: Vector4f) {
        self.material.color = color
        self.material.useMaterialColor = true
    }
    
}
