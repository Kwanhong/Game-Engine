//
//  Mouse.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/07.
//

import Foundation
import MetalKit

class Mouse {
    
    public static var isOnWindow: Bool = false
    
    private static var mouseButtonCount: Int = 12
    private static var mouseButtons: [Bool] = .init(repeating: false, count: mouseButtonCount)
    
    private static var overallMousePosition: Vector2f = .zero
    private static var mouseDeltaPosition: Vector2f = .zero
    
    private static var scrollWheelPosition: Float = .zero
    private static var lastWheelPosition: Float = .zero
    private static var scrollWheelChange: Float = .zero
    
    public static func lateUpdate() {
        mouseDeltaPosition = .zero
    }
    
    public static func setMouseButtonPressed(button: Int, isOn: Bool) {
        mouseButtons[button] = isOn
    }
    
    public static func isMouseButtonPressed(button: mouseButtonCode)->Bool {
        return mouseButtons[Int(button.rawValue)]
    }
    
    public static func setOverallMousePosition(position: Vector2f) {
        overallMousePosition = position
    }
    
    public static func setMousePositionChange(overallPosition: Vector2f, deltaPosition: Vector2f) {
        overallMousePosition = overallPosition
        mouseDeltaPosition = deltaPosition
    }
    
    public static func scrollMouse(deltaY: Float) {
        scrollWheelPosition += deltaY
        scrollWheelChange += deltaY
    }
    
    public static func getWeelDeltaPosition()->Float {
        let result = scrollWheelChange
        scrollWheelChange = .zero
        return result
    }
    
    public static func getMouseViewportDeltaPosition()->Vector2f {
        let position = mouseDeltaPosition
        let screenSize = Renderer.screenSize
        let x = Math.map(
            position.x,
            start1: -screenSize.x * 0.5, stop1: screenSize.x * 0.5,
            start2: -1, stop2: 1
        )
        let y = Math.map(
            position.y,
            start1: screenSize.y * 0.5, stop1: -screenSize.y * 0.5,
            start2: -1, stop2: 1
        )
        return Vector2f(x, y)
    }
    
    public static func getMouseWindowPosition()->Vector2f {
        return overallMousePosition
    }
    
    public static func getMouseViewportPosition()->Vector2f {
        let position = overallMousePosition
        let screenSize = Renderer.screenSize
        let x = Math.map(position.x, start1: .zero, stop1: screenSize.x, start2: -1, stop2: 1)
        let y = Math.map(position.y, start1: .zero, stop1: screenSize.y, start2: -1, stop2: 1)
        return Vector2f(x, y)
    }
    
    public static func getMouseCameraPosition(camera: Camera)->Vector2f {
        return camera.position.xy - getMouseViewportPosition()
    }
    
    public static func getMouseCameraDeltaPosition(camera: Camera)->Vector2f {
        return camera.position.xy - getMouseViewportDeltaPosition()
    }
    
}
