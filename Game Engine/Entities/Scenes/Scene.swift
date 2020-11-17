//
//  Scene.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/25.
//

import MetalKit
import Foundation

class Scene: Node {
    
    var cameraManager = CameraManager()
    var sceneConstants = SceneConstants()
    
    private var deltaTimeContainer: Float = .zero
    var deltaTime: Float {
        return deltaTimeContainer
    }
    
    override init() {
        super.init()
        start()
    }
    
    func addCamera(_ camera: Camera, setItNow: Bool = true) {
        cameraManager.registerCamera(camera, setItNow: setItNow)
    }
    
    func updateSceneConstants() {
        if let camera = cameraManager.currentCamera {
            sceneConstants.viewMatrix = camera.viewMatrix
            sceneConstants.projectionMatrix = camera.projectionMatrix
        }
    }
    
    func updateCameras(deltaTime: Float) {
        cameraManager.update(deltaTime: deltaTime)
    }
    
    override func update(deltaTime: Float) {
        
        self.deltaTimeContainer = deltaTime
        self.updateSceneConstants()
        
        self.update()
        super.update(deltaTime: deltaTime)
        self.lateUpdate()
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        renderCommandEncoder?.setVertexBytes(
            &sceneConstants,
            length: SceneConstants.stride,
            index: 1
        )
        
        super.render(renderCommandEncoder: renderCommandEncoder)
        
    }
    
    func start() { }
    
    func update() { }
    
    func lateUpdate() { }
}
