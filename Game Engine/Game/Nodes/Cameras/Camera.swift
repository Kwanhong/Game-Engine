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

struct PerspectiveSettings {
    var fovDegrees: Float = 45
    var far: Float = 1000
    var near: Float = 0.1
}

struct OrthographicSettings {
    var left: Float = -5
    var right: Float = 5
    var bottom: Float = -5
    var top: Float = 5
    var far: Float = 1000
    var near: Float = -1000
}

struct CameraSettings {
    var projectionMode: CameraProjectionMode = .perspective
    var perspective = PerspectiveSettings()
    var orthographic = OrthographicSettings()
}

protocol Camera {
    var cameraType: CameraType { get }
    var settings: CameraSettings { get set }
    var position: Vector3f { get set }
    var rotation: Vector3f { get set }
    func update(deltaTime: Float)
}

extension Camera {
    
    var viewMatrix: Matrix4x4f {
        
        var viewMatrix: Matrix4x4f = .identity
        
        viewMatrix.rotate(rotation: rotation)
        viewMatrix.translate(direction: -position)
        
        return viewMatrix
        
    }
    
    var projectionMatrix: Matrix4x4f {
        
        if settings.projectionMode == .perspective {
            
            return .perspective(
                degreesFov: settings.perspective.fovDegrees,
                aspectRatio: Renderer.aspectRatio,
                near: settings.perspective.near,
                far: settings.perspective.far
            )
            
        } else {
            
            return .orthographic(
                left: settings.orthographic.left,
                right: settings.orthographic.right,
                bottom: settings.orthographic.bottom,
                top: settings.orthographic.top,
                near: settings.orthographic.near,
                far: settings.orthographic.far
            )
            
        }
        
    }
    
}
