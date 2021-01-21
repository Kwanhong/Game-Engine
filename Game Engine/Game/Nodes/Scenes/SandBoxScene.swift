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
    
    let colorChangeDuration: Float = 3
    var lastColorChangedTime: Int = -1
    
    var nextColors: [Vector4f] = .init(repeating: .white, count: 3)
    var lastColors: [Vector4f] = .init(repeating: .white, count: 3)
    
    var camera: GameCamera = .init(projectionMode: .perspective)
    
    override func start() {
        
        Keyboard.delegate = self
        
        // Camera
        camera.setPosition(x: 1.5, y: -1, z: 6)
        camera.lookAt(.zero)
        self.addCamera(camera)
        
        // Light Objects
        for _ in 0..<lightCount {
            
            let light = LightObject(meshType: .f16)
            let randomColor = Vector3f.random.normalized.asVector4f(w: 1) * 1.25
            light.setUserMaterial(material: .init(color: randomColor, isLit: false))
            light.setScale(equalTo: 0.5)
            light.setRotation(y: Float(-90).toRadians)
            light.lightColor = randomColor.xyz
            
            self.lights.append(light)
            self.addLight(object: light)
            
        }
        
        // Sky Box
        let skybox = GameObject(meshType: .builtInSkyBox)
        skybox.setScale(equalTo: 10)
        skybox.setPosition(y: 8)
        skybox.setUserMaterial(material: .init(color: .gray))
        self.addChild(skybox)
        
        // Game Object
        let f16 = LightObject(meshType: .f16)
        f16.setScale(equalTo: 3)
        f16.setUserTexture(type: .modelDefault)
        f16.lightColor = .red
        f16.lightData.specularIntensity = 2
        f16.lightData.ambientIntensity = 0
        f16.setRotation(y: Float(-90).toRadians)
        self.addLight(object: f16)
        
    }

    override func update() {
        
        spinLights()
        setRandomLightColor()
        
    }
    
    func spinLights() {
        
        time += deltaTime * timeScale
        
        let radius: Float = 6
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
    
    func setRandomLightColor() {
        let intTime = Int(time)
        if intTime != lastColorChangedTime, intTime % Int(colorChangeDuration) == 0 {
            lastColorChangedTime = intTime
            for i in 0..<nextColors.count {
                lastColors[i] = lights[i].material?.color ?? .white
                nextColors[i] = Vector3f.random.normalized.asVector4f(w: 1) * 1.25
            }
        }
        for i in 0..<lights.count {
            let start = Float(lastColorChangedTime)
            let end = start + colorChangeDuration
            let r = Math.map(time, start1: start, stop1: end, start2: lastColors[i].x, stop2: nextColors[i].x)
            let g = Math.map(time, start1: start, stop1: end, start2: lastColors[i].y, stop2: nextColors[i].y)
            let b = Math.map(time, start1: start, stop1: end, start2: lastColors[i].z, stop2: nextColors[i].z)
            let a = Math.map(time, start1: start, stop1: end, start2: lastColors[i].w, stop2: nextColors[i].w)
            lights[i].setUserColor(color: .init(r, g, b, a))
            lights[i].lightColor = .init(r, g, b)
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
                light.setUserColor(color: randomColor)
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
