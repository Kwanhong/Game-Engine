//
//  DebugCamera.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit
import AppKit

class GameCamera: Camera {
    
    var minUpTiltDegrees: Float = 90
    var mouseSensitivity: Float = 3
    var movingSpeed: Float = 7
    
    var cameraType: CameraType = .debug
    var settings: CameraSettings = .init()
    
    var rotation: Vector3f = .zero
    var position: Vector3f = .zero
    
    var fovConstant: Float {
        return 1 / pow(settings.perspective.fovDegrees / 45, 3.3)
    }
    
    private var isWindowFocused: Bool {
        
        let pos = Mouse.getMouseViewportPosition()
        guard let window = NSApplication.shared.windows.first else {
            return false
        }
        
        if abs(pos.x) < 0.8,
           abs(pos.y) < 0.8,
           window.isKeyWindow {
            return true
        } else {
            return false
        }
        
    }
    
    init(projectionMode: CameraProjectionMode = .perspective) {
        self.settings.projectionMode = projectionMode
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            
            if self.isWindowFocused {
                CGWarpMouseCursorPosition(
                    Renderer.screenCenter.asCGPoint
                )
            }
            
        }
        
    }
    
    func update(deltaTime: Float) {
        
        if !isWindowFocused {
            NSCursor.unhide()
            return
        }
        
        NSCursor.hide()
        moveWhenKeyPressed(deltaTime)
        lookAtMousePoint()
        
    }
    
}

extension GameCamera {
    
    private func lookAtMousePoint() {
        
        let mouse = Mouse.getMouseViewportDeltaPosition()
        
        self.rotation.y += mouse.x * mouseSensitivity
        self.rotation.x -= mouse.y * mouseSensitivity
        
    }
    
    private func moveWhenKeyPressed(_ deltaTime: Float) {
        
        let dash: Float = Keyboard.isKeyPressed(.space) ? 5 : 1
        
        if Keyboard.isKeyPressed(.w) {
            var dir = Vector2f(00,-1).rotated(to: rotation.y)
            dir.setMagnitude(to: deltaTime * movingSpeed * dash)
            move(direction: .init(dir.x, .zero, dir.y))
        } else if Keyboard.isKeyPressed(.s) {
            var dir = Vector2f(00,01).rotated(to: rotation.y)
            dir.setMagnitude(to: deltaTime * movingSpeed * dash)
            move(direction: .init(dir.x, .zero, dir.y))
        }
        
        if Keyboard.isKeyPressed(.a) {
            var dir = Vector2f(-1,00).rotated(to: rotation.y)
            dir.setMagnitude(to: deltaTime * movingSpeed * dash)
            move(direction: .init(dir.x, .zero, dir.y))
        } else if Keyboard.isKeyPressed(.d) {
            var dir = Vector2f(01,00).rotated(to: rotation.y)
            dir.setMagnitude(to: deltaTime * movingSpeed * dash)
            move(direction: .init(dir.x, .zero, dir.y))
        }
        
        if Keyboard.isKeyPressed(.q) {
            var dir = Vector3f(00,-1,00)
            dir.setMagnitude(to: deltaTime * movingSpeed * dash)
            move(direction: dir)
        } else if Keyboard.isKeyPressed(.e) {
            var dir = Vector3f(00,01,00)
            dir.setMagnitude(to: deltaTime * movingSpeed * dash)
            move(direction: dir)
        }
        
    }
    
}

extension GameCamera {
    
    func lookAt(_ target: Vector3f) {
        var matrix: Matrix4x4f = .identity
        matrix.lookat(from: position, to: target, up: .up)
        self.rotation = -matrix.getRotation()
    }
    
    func move(direction dir: Vector3f) {
        move(x: dir.x, y: dir.y, z: dir.z)
    }
    
    func move(x: Float? = nil, y: Float? = nil, z: Float? = nil) {
        if let x = x { self.position.x += x }
        if let y = y { self.position.y += y }
        if let z = z { self.position.z += z }
        if position.z == .zero {
            position.z = .leastNormalMagnitude
        }
    }
    
    func setRotation(x: Float? = nil, y: Float? = nil, z: Float? = nil) {
        if let x = x { self.rotation.x = x }
        if let y = y { self.rotation.y = y }
        if let z = z { self.rotation.z = z }
    }
    
    func setPosition(x: Float? = nil, y: Float? = nil, z: Float? = nil) {
        if let x = x { self.position.x = x }
        if let y = y { self.position.y = y }
        if let z = z { self.position.z = z }
    }
    
}
