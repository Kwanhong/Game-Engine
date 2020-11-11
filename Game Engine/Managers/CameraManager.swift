//
//  CameraManager.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit

class CameraManager {
    
    private var cameras: [CameraType: Camera] = [:]
    
    public var currentCamera: Camera!
    
    public func registerCamera(_ camera: Camera) {
        self.cameras.updateValue(camera, forKey: camera.cameraType)
    }
    
    public func setCamera(type: CameraType) {
        if let camera = cameras[type] {
            self.currentCamera = camera
        }
    }
    
    internal func update(deltaTime: Float) {
        for camera in cameras.values {
            camera.update(deltaTime: deltaTime)
        }
    }
    
}
