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
    
    init(meshType: MeshType) {
        super.init()
        mesh = MeshLibrary.mesh(meshType)
        start()
    }
    
    override func update(deltaTime: Float) {
        update()
        updateModelConstants()
        lateUpdate()
    }
    
    private func updateModelConstants() {
        modelConstants.modelMatrix = self.modelMatrix
    }
    
    func start() { }
    
    func update() { }
    
    func lateUpdate() { }
    
}

extension GameObject: Renderable {
    
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        renderCommandEncoder?.setVertexBytes(&modelConstants, length: ModelConstants.stride(), index: 1)
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.getRenderPipelineState(.basic))
        renderCommandEncoder?.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: mesh.vertexCount
        )
        
    }
    
}
