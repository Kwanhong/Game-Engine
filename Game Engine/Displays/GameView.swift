//
//  GameView.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/28.
//

import MetalKit

class GameView: MTKView {
    
    var renderer: Renderer!
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        Engine.Ignite(device: device!)
        
        self.clearColor = Preferences.clearColor
        self.colorPixelFormat = Preferences.mainPixelFormat
        self.depthStencilPixelFormat = Preferences.mainDepthPixelFormat
        
        self.renderer = Renderer(self)
        self.delegate = renderer
        
    }
    
}

// Keyboard Input
extension GameView {
    
    override var acceptsFirstResponder: Bool { return true }
    
    override func keyDown(with event: NSEvent) {
        Keyboard.setKeyPressed(event.keyCode, isOn: true)
    }
    
    override func keyUp(with event: NSEvent) {
        Keyboard.setKeyPressed(event.keyCode, isOn: false)
    }
    
}

// Mouse Button Input
extension GameView {
    
    override func mouseDown(with event: NSEvent) {
        Mouse.setMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }
    
    override func mouseUp(with event: NSEvent) {
        Mouse.setMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        Mouse.setMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        Mouse.setMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }
    
    override func otherMouseDown(with event: NSEvent) {
        Mouse.setMouseButtonPressed(button: event.buttonNumber, isOn: true)
    }
    
    override func otherMouseUp(with event: NSEvent) {
        Mouse.setMouseButtonPressed(button: event.buttonNumber, isOn: false)
    }
    
}

// Mouse Movement Input
extension GameView {
    
    override func scrollWheel(with event: NSEvent) {
        Mouse.scrollMouse(deltaY: Float(event.deltaY))
    }
    
    override func mouseMoved(with event: NSEvent) {
        setMouseDeltaPosition(event: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        setMouseDeltaPosition(event: event)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        setMouseDeltaPosition(event: event)
    }
    
    override func otherMouseDragged(with event: NSEvent) {
        setMouseDeltaPosition(event: event)
    }
    
    override func updateTrackingAreas() {
        let area = NSTrackingArea(
            rect: self.bounds,
            options: [.activeAlways, .mouseMoved, .enabledDuringMouseDrag],
            owner: self, userInfo: nil
        )
        self.addTrackingArea(area)
    }
    
    private func setMouseDeltaPosition(event: NSEvent) {
        
        let overallLocation = Vector2f(
            Float(event.locationInWindow.x),
            Float(event.locationInWindow.y)
        )
        
        let deltaPosition = Vector2f(
            Float(event.deltaX),
            Float(event.deltaY)
        )
        
        Mouse.setMousePositionChange(
            overallPosition: overallLocation,
            deltaPosition: deltaPosition
        )
    }
    
}
