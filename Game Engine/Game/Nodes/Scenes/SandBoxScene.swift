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
        
        let camera = DebugCamera()
        camera.position.y = 2
        camera.position.x = 10
        camera.position.z = 10
        camera.lookAt(.zero)
        self.addCamera(camera)
        
        for _ in 0..<lightCount {
            
            let light = LightObject(meshType: .f16)
            let randomColor = Vector3f.random.normalized.asVector4f * 1.25
            light.lightData.ambientIntensity = 0.5
            light.scale = .init(repeating: 0.5)
            light.usePhongShader = false
            light.rotation.y = Float(-90).toRadians
            light.materialColor = randomColor
            light.lightColor = randomColor.asVector3f
            self.lights.append(light)
            self.addLight(object: light)
        }
        
        let skybox = GameObject(meshType: .builtInSkyBox)
        skybox.scale = .init(repeating: 10)
        skybox.position.y = 8
        skybox.materialColor = .white
        self.addChild(skybox)
        
        let f16 = F16Object()
        f16.materialColor = .white
        f16.position.x = -2
        f16.rotation.y = Float(-90).toRadians
        self.addChild(f16)
        
        let box = CubeObject()
        box.position.x = 2
        box.materialColor = .white
        self.addChild(box)
    }

    override func update() {
        
        spinLights()
        
    }
    
    func spinLights() {
        
        time += deltaTime * 2
        let radius: Float = 7
        let tolerance: Float = .tau / Float(lights.count)
        var offset: Float = .zero
        
        for light in lights {
            light.position.z = sin(time + offset) * radius
            light.position.x = cos(time + offset) * radius
            light.rotation.y = Math.getAngle(of: Vector2f(
                light.position.z,
                light.position.x
            )) + .pi
            
            offset += tolerance
        }
        
    }
    
}

extension SandBoxScene: KeyboardDelegate {
    
    func onKeyPressed(keyCode: KeyCode) { }
    
    func onKeyReleased(keyCode: KeyCode) {
        
        if keyCode == .space {
            for light in lights {
                let randomColor = Vector3f.random.normalized.asVector4f * 1.25
                light.materialColor = randomColor
                light.lightColor = randomColor.asVector3f
            }
        }
        
    }
    
}
