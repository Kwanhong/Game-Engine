//
//  SceneManager.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/25.
//

import Foundation
import MetalKit

enum SceneType {
    case sandBox
}

class SceneManager {
    
    private static var currentScene: Scene!
    
    public static func initialize(_ sceneType: SceneType) {
        setScene(sceneType)
    }
    
    public static func setScene(_ sceneType: SceneType) {
        switch sceneType {
            case .sandBox:
                currentScene = SandBoxScene()
        }
    }
    
    public static func tickScene(renderCommandEncoder: MTLRenderCommandEncoder?, deltaTime: Float) {
        
        currentScene.update(deltaTime: deltaTime)
        currentScene.render(renderCommandEncoder: renderCommandEncoder)
        
    }
    
}
