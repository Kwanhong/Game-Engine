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

enum CameraProjectionMode {
    case perspective
    case orthographic
}

struct CameraSettings {
    var projectionMode: CameraProjectionMode = .perspective
    var fovDegrees: Float = 90
    var nearValue: Float = 0.1
    var farValue: Float = 100
}

protocol Camera {
    var cameraType: CameraType { get }
    var settings: CameraSettings { get set }
    var position: Vector3f { get set }
    func update(deltaTime: Float)
}

extension Camera {
    
    var viewMatrix: Matrix4x4f {
        var viewMatrix: Matrix4x4f = .identity
        viewMatrix.translate(direction: -position)
        return viewMatrix
    }
    
    var projectionMatrix: Matrix4x4f {
        if settings.projectionMode == .perspective {
            return .perspective(
                degreesFov: settings.fovDegrees,
                aspectRatio: Renderer.aspectRatio,
                near: settings.nearValue,
                far: settings.farValue
            )
        } else {
            return .identity
        }
    }
}
