//
//  Node.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class Node {
    
    var name: String = "Node"
    var id: String = UUID().uuidString
    
    var position = Vector3f(repeating: 0)
    var scale = Vector3f(repeating: 1)
    var rotation = Vector3f(repeating: 0)
    var parent: Node?
    var children: [Node] = []
    
    var modelMatrix: Matrix4x4f {
        
        let parentModelMatrix = parent?.modelMatrix ?? .identity
        var modelMatrix: Matrix4x4f = .identity
        
        modelMatrix.translate(direction: position)
        modelMatrix.scale(axis: scale)
        modelMatrix.rotate(rotation: rotation)
        
        return .mutliply(parentModelMatrix, with: modelMatrix)
        
    }
    
    init(name: String = "Node") {
        self.name = name
    }
    
    internal func update(deltaTime: Float) {
        
        for child in children {
            child.update(deltaTime: deltaTime)
        }
        
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
        
        for child in children {
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        
    }
    
    func addChild(_ child: Node) {
        
        child.parent = self
        children.append(child)
        
    }
    
}
