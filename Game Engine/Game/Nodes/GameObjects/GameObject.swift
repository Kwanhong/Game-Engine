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
    private var textureType: TextureType = .woodenBox
    private var mesh: Mesh!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(name: String = "Game Object", meshType: MeshType = .quadCustom) {
        super.init(name: name)
        self.mesh = Entities.Lib.mesh[meshType]
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
        
        renderCommandEncoder?.setRenderPipelineState(Graphics.State.renderPipeline[.basic]!)
        
        renderCommandEncoder?.setDepthStencilState(Graphics.State.depthStencil[.less])
        
        renderCommandEncoder?.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        
        renderCommandEncoder?.setFragmentTexture(Entities.Res.texture[textureType], index: 0)
        
        renderCommandEncoder?.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        renderCommandEncoder?.setFragmentSamplerState(Graphics.State.sampler[.linear], index: 0)
        
        mesh.drawPrimitives(renderCommandEncoder)
    }
    
}

extension GameObject {
    
    public func setColor(_ color: Vector4f) {
        self.material.color = color
        self.material.useMaterialColor = true
        self.material.useTexture = false
    }
    
    public func setTexture(_ type: TextureType) {
        self.textureType = type
        self.material.useTexture = true
        self.material.useMaterialColor = false
    }
    
}
