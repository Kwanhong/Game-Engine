//
//  DebugCamera.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/11.
//

import Foundation
import MetalKit
import AppKit

class DebugCamera: Camera {
    
    let mouseSensitivity: Float = 1
    let movingSpeed: Float = 5
    
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
    
    func lookAtMousePoint() {
        
        let hype = settings.farValue / cos(settings.fovDegrees.toRadians)
        let farWidth = sqrt((hype * hype) - (settings.farValue * settings.farValue)) * 2
        
        let mouse = Mouse.getMouseViewportPosition() * farWidth
        let target = -mouse.asVector3f(z: settings.farValue - position.z)
        
        var delta = Matrix4x4f.identity
        delta.lookat(from: .zero, to: target, up: Math.yAxis)
        rotation += delta.getRotation() * mouseSensitivity
        
    }
    
    func setMousePosToCenter() {
        
        CGEvent(
            mouseEventSource: nil,
            mouseType: .mouseMoved,
            mouseCursorPosition: Renderer.screenCenter.asCGPoint,
            mouseButton: .left
        )?.post(tap: .cgSessionEventTap)
        
    }
    
    func moveWhenKeyPressed(_ deltaTime: Float) {
        
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
