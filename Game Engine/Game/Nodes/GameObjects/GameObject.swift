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
    private var textureType: TextureType = .none
    private var mesh: Mesh!
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    init(name: String = "Game Object", meshType: MeshType = .builtInQuad) {
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
