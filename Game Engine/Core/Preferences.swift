//
//  Preferences.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

public enum ClearColor {
    
    static let white = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let green = MTLClearColor(red: 0.22, green: 0.55, blue: 0.34, alpha: 1)
    static let gray = MTLClearColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    static let darkGray = MTLClearColor(red: 0.16, green: 0.15, blue: 0.17, alpha: 1)
    static let black = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    
}

class Preferences {
    
    static var clearColor = ClearColor.darkGray
    static var mainPixelFormat = MTLPixelFormat.bgra8Unorm
    static var mainDepthPixelFormat = MTLPixelFormat.depth32Float
    static var startingSceneType: SceneType = .sandBox
    
}
