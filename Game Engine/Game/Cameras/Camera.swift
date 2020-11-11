//
//  Camera.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit

enum CameraType {
    case debug
}

protocol Camera {
    var cameraType: CameraType { get }
    var position: Vector3f { get set }
    func update(deltaTime: Float)
}

extension Camera {
    
    var viewMatrix: Matrix4x4f {
        var viewMatrix: Matrix4x4f = .identity
        viewMatrix.translate(direction: -position)
        return viewMatrix
    }
    
}
