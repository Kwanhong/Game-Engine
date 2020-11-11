//
//  GameObject.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class GameObject: Node {
    
    var modelConstants = ModelConstants()
    var mesh: Mesh!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(meshType: MeshType = .quadCustom) {
        super.init()
        mesh = MeshLibrary.mesh(meshType)
        start()
    }
    
    internal override func update(deltaTime: Float) {
        deltaTimeContainer = deltaTime
        update()
        updateModelConstants()
        lateUpdate()
    }
    
    private func updateModelConstants() {
        modelConstants.modelMatrix = self.modelMatrix
    }
    
    internal func start() { }
    
    internal func update() { }
    
    internal func lateUpdate() { }
    
}

extension GameObject: Renderable {
    
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.getRenderPipelineState(.basic))
        renderCommandEncoder?.setDepthStencilState(DepthStencilStateLibrary.getDepthStencilState(.less))
        renderCommandEncoder?.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.setVertexBytes(&modelConstants, length: ModelConstants.stride(), index: 2)
        renderCommandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: mesh.vertexCount
        )
        
    }
    
}
