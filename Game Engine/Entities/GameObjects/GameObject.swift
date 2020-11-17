//
//  GameObject.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class GameObject: Node {
    
    private var modelConstants = ModelConstants()
    private var material = Material()
    private var mesh: Mesh!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(meshType: MeshType = .quadCustom) {
        super.init()
        self.mesh = MeshLibrary.getMesh(meshType)
        self.start()
    }
    
    internal override func update(deltaTime: Float) {
        self.deltaTimeContainer = deltaTime
        self.update()
        self.updateModelConstants()
        super.update(deltaTime: deltaTime)
        self.lateUpdate()
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
        
        renderCommandEncoder?.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        
        renderCommandEncoder?.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        mesh.drawPrimitives(renderCommandEncoder)
    }
    
}

extension GameObject {
    
    public func setColor(_ color: Vector4f) {
        self.material.color = color
        self.material.useMaterialColor = true
    }
    
}
