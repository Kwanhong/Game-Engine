//
//  GameObject.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class GameObject: Node {
    
    private var baseMaterial: Material? = .standard
    private var baseTextureType: TextureType = .none
    
    private var mesh: Mesh!
    private var modelConstants = ModelConstants()
    
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
        
        renderCommandEncoder?.setFragmentSamplerState(Graphics.State.sampler[.linear], index: 0)
        
        renderCommandEncoder?.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        
        mesh.drawPrimitives(renderCommandEncoder, baseTextureType: baseTextureType, baseMaterial: baseMaterial)
    }
    
}

extension GameObject {
    
    func setUserTexture(type: TextureType) {
        self.baseTextureType = type
    }
    
    func setUserMaterial(material: Material?) {
        self.baseMaterial = material
    }
    
    func useModelGraphics() {
        self.setUserTexture(type: .modelTexture)
        self.setUserMaterial(material: .modelMaterial)
    }
    
    var material: Material? {
        return self.baseMaterial
    }
    
    var textureType: TextureType {
        return self.baseTextureType
    }
    
    var isLit: Bool {
        set { self.baseMaterial?.isLit = newValue }
        get { return self.baseMaterial?.isLit ?? false }
    }
    
}
