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
    
    var mouseSensitivity: Float = 1
    var movingSpeed: Float = 5
    
    var cameraType: CameraType = .debug
    var settings: CameraSettings = .init()
    
    var rotation: Vector3f = .zero
    var position: Vector3f = .zero
    
    private var wasWindowFocused: Bool = false
    private var isWindowFocused: Bool {
        
        guard let window = NSApplication.shared.windows.first else {
            return false
        }
        
        if Math.getDistance(
            of: .zero, to: Mouse.getMouseViewportPosition()
        ) < 1, window.isKeyWindow {
            return true
        } else {
            return false
        }
        
    }
    
    func update(deltaTime: Float) {
        
        if !isWindowFocused {
            NSCursor.unhide()
            wasWindowFocused = false
            return
        }
        if !wasWindowFocused {
            NSCursor.hide()
            setMousePosToCenter()
            wasWindowFocused = true
        } else {
            lookAtMousePoint()
            setMousePosToCenter()
        }
        
        moveWhenKeyPressed(deltaTime)
        
    }
    
}

extension GameCamera {
    
    private func lookAtMousePoint() {
        
        let hype = settings.farValue / cos(settings.fovDegrees.toRadians)
        let farWidth = sqrt((hype * hype) - (settings.farValue * settings.farValue)) * 2
        
        let mouse = Mouse.getMouseViewportPosition() * farWidth
        let target = -mouse.asVector3f(z: settings.farValue - position.z)
        
        var delta = Matrix4x4f.identity
        delta.lookat(from: .zero, to: target, up: Math.yAxis)
        rotation += delta.getRotation() * mouseSensitivity
        
    }
    
    private func setMousePosToCenter() {
        
        CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: Renderer.screenCenter.asCGPoint,
            mouseButton: .left
        )?.post(tap: .cgSessionEventTap)
        
    }
    
    private func moveWhenKeyPressed(_ deltaTime: Float) {
        
        if Keyboard.isKeyPressed(.w) {
            self.position += Vector3f(.zero, .zero, -deltaTime * movingSpeed).rotated(by: rotation)
        } else if Keyboard.isKeyPressed(.s) {
            self.position += Vector3f(.zero, .zero, deltaTime * movingSpeed).rotated(by: rotation)
        }
        
        if Keyboard.isKeyPressed(.a) {
            self.position += Vector3f(-deltaTime * movingSpeed, .zero, .zero).rotated(by: rotation)
        } else if Keyboard.isKeyPressed(.d) {
            self.position += Vector3f(deltaTime * movingSpeed, .zero, .zero).rotated(by: rotation)
        }
        
        if Keyboard.isKeyPressed(.q) {
            self.position += Vector3f(.zero, -deltaTime * movingSpeed, .zero)
        } else if Keyboard.isKeyPressed(.e) {
            self.position += Vector3f(.zero, deltaTime * movingSpeed, .zero)
        }
        
    }
    
}

extension GameCamera {
    
    func lookAt(_ target: Vector3f) {
        var matrix: Matrix4x4f = .identity
        matrix.lookat(from: position, to: target, up: Math.yAxis)
        self.rotation = -matrix.getRotation()
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
