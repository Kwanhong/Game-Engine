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
    
    public static var currentScene: Scene {
        return currentSceneContainer
    }
    
    private static var currentSceneContainer: Scene!
    
    public static func initialize(_ sceneType: SceneType) {
        setScene(sceneType)
    }
    
    public static func setScene(_ sceneType: SceneType) {
        switch sceneType {
            case .sandBox:
                currentSceneContainer = SandBoxScene()
        }
    }
    
    public static func tickScene(renderCommandEncoder: MTLRenderCommandEncoder?, deltaTime: Float) {
        
        currentSceneContainer.updateCameras(deltaTime: deltaTime)
        currentSceneContainer.update(deltaTime: deltaTime)
        currentSceneContainer.render(renderCommandEncoder: renderCommandEncoder)
        
    }
    
}
