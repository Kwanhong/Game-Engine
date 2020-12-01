//
//  SandBoxScene.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/25.
//

import Foundation

class SandBoxScene: Scene {
    
    let timeScale: Float = 2
    let lightCount: Int = 3
    
    var lights : [LightObject] = []
    var time: Float = .zero
    
    override func start() {
        
        Keyboard.delegate = self
        
        // Camera
        let camera = GameCamera(projectionMode: .perspective)
        camera.setPosition(x: 8, y: 2, z: 8)
        camera.lookAt(.zero)
        self.addCamera(camera)
        
        // Light Objects
        for _ in 0..<lightCount {
            
            let light = LightObject(meshType: .f16)
            light.setScale(equalTo: 0.5)
            light.setRotation(y: Float(-90).toRadians)
            
            let randomColor = Vector3f.random.normalized.asVector4f(w: 1) * 1.25
            light.setUserMaterial(material: .init(color: randomColor, isLit: false))
            light.lightData.ambientIntensity = 0.5
            light.lightColor = randomColor.xyz
            
            self.lights.append(light)
            self.addLight(object: light)
            
        }
        
        // Sky Box
        let skybox = GameObject(meshType: .builtInSkyBox)
        skybox.setScale(equalTo: 10)
        skybox.setPosition(y: 8)
        skybox.setUserMaterial(material: .standard)
        self.addChild(skybox)
        
        // Game Object
        let f16 = F16Object()
        f16.setRotation(y: Float(-90).toRadians)
        self.addChild(f16)
        
    }

    override func update() {
        
        spinLights()
        
    }
    
    func spinLights() {
        
        time += deltaTime * timeScale
        
        let radius: Float = 7
        let tolerance: Float = .tau / Float(lights.count)
        var offset: Float = .zero
        
        for light in lights {
            
            light.setPosition(
                x: cos(time + offset) * radius,
                z: sin(time + offset) * radius
            )
            
            light.setRotation(
                y: light.position.zx.angle + .pi
            )
            
            offset += tolerance
            
        }
        
    }
    
}

extension SandBoxScene: KeyboardDelegate {
    
    func onKeyPressed(keyCode: KeyCode) { }
    
    func onKeyReleased(keyCode: KeyCode) {
        
        // Lights Color
        if keyCode == .x {
            
            for light in lights {
                let randomColor = Vector3f.random.normalized.asVector4f(w: 1) * 1.25
                light.setUserMaterial(material: .init(color: randomColor, isLit: false))
                light.lightColor = randomColor.xyz
            }
            
        }
        
        // Camera Mode
        if keyCode == .c {
            
            if cameraManager.currentCamera.settings.projectionMode == .perspective {
                cameraManager.currentCamera.settings.projectionMode = .orthographic
            } else {
                cameraManager.currentCamera.settings.projectionMode = .perspective
            }
            
        }
        
    }
    
}
