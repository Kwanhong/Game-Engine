//
//  Node.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class Node {
    
    var position = Vector3f(repeating: 0)
    var scale = Vector3f(repeating: 1)
    var rotation = Vector3f(repeating: 0)
    var children: [Node] = []
    
    var modelMatrix: Matrix4x4f {
        var modelMatrix: Matrix4x4f = .identity
        modelMatrix.translate(direction: position)
        modelMatrix.scale(axis: scale)
        modelMatrix.rotate(angle: rotation.x, axis: Math.xAxis)
        modelMatrix.rotate(angle: rotation.y, axis: Math.yAxis)
        modelMatrix.rotate(angle: rotation.z, axis: Math.zAxis)
        return modelMatrix
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
        
        children.append(child)
        
    }
    
}
