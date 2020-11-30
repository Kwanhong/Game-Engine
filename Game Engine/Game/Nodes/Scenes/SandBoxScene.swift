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
        let camera = GameCamera()
        camera.setPosition(x: 10, y: 2, z: 10)
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
        skybox.setUserMaterial(material: .init(color: .white))
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
                y: light.position.zx.angle + .pi,
                z: sin(time + offset) * radius
            )
            
            offset += tolerance
            
        }
        
    }
    
}

extension SandBoxScene: KeyboardDelegate {
    
    func onKeyPressed(keyCode: KeyCode) { }
    
    func onKeyReleased(keyCode: KeyCode) {
        
        if keyCode == .space {
            
            for light in lights {
                let randomColor = Vector3f.random.normalized.asVector4f(w: 1) * 1.25
                light.setUserMaterial(material: .init(color: randomColor, isLit: false))
                light.lightColor = randomColor.xyz
            }
            
        }
        
    }
    
}
