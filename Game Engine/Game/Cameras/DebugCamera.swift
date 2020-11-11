//
//  DebugCamera.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit

class DebugCamera: Camera {
    
    var cameraType: CameraType = .debug
    
    var position: Vector3f = .zero
    
    func update(deltaTime: Float) {
        
        if Keyboard.isKeyPressed(.leftArrow) {
            self.position.x -= deltaTime
        }
        if Keyboard.isKeyPressed(.rightArrow) {
            self.position.x += deltaTime
        }
        if Keyboard.isKeyPressed(.upArrow) {
            self.position.y += deltaTime
        }
        if Keyboard.isKeyPressed(.downArrow) {
            self.position.y -= deltaTime
        }
    }
    
    
}
