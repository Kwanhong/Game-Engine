//
//  SandBoxScene.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/25.
//

import Foundation

class SandBoxScene: Scene {
    
    let timeScale: Float = 2
    var camera: Camera = DebugCamera()
    var magentaLight = LightObject(meshType: .f16)
    var yellowLight = LightObject(meshType: .f16)
    var blueLight = LightObject(meshType: .f16)
    var time: Float = .zero
    
    override func start() {
        
        camera.position.y = 2
        camera.position.z = 10
        self.addCamera(camera)
        
        magentaLight.scale = .init(repeating: 0.5)
        magentaLight.usePhongShader = false
        magentaLight.rotation.y = Float(-90).toRadians
        magentaLight.materialColor = .init(1, 0.25, 0.75, 1)
        magentaLight.lightColor = .init(1, 0.25, 0.75)
        self.addLight(object: magentaLight)
        
        yellowLight.scale = .init(repeating: 0.5)
        yellowLight.usePhongShader = false
        yellowLight.rotation.y = Float(-90).toRadians
        yellowLight.materialColor = .init(1, 0.75, 0.25, 1)
        yellowLight.lightColor = .init(1, 0.75, 0.25)
        self.addLight(object: yellowLight)
        
        blueLight.scale = .init(repeating: 0.5)
        blueLight.usePhongShader = false
        blueLight.rotation.y = Float(-90).toRadians
        blueLight.materialColor = .init(0.25, 0.75, 1, 1)
        blueLight.lightColor = .init(0.25, 0.75, 1)
        self.addLight(object: blueLight)
        
        let plane = GameObject(meshType: .builtInQuad)
        plane.scale = .init(repeating: 10)
        plane.position.y = -2
        plane.rotation.x = Float(-90).toRadians
        plane.materialColor = .one
        self.addChild(plane)
        
        let f16 = F16Object()
        f16.materialColor = .one
        f16.position.x = -2
        f16.rotation.y = Float(-90).toRadians
        self.addChild(f16)
        
        let box = CubeObject()
        box.position.x = 2
        box.materialColor = .one
        self.addChild(box)
    }

    override func update() {
        time += deltaTime * 2
        let radius = Float(7)
        blueLight.position.z = sin(time) * radius
        blueLight.position.x = cos(time) * radius
        blueLight.rotation.y = Math.getAngle(of: Vector2f(
            blueLight.position.z,
            blueLight.position.x
        )) + .pi
        
        yellowLight.position.z = sin(time + .pi * (2 / 3)) * radius
        yellowLight.position.x = cos(time + .pi * (2 / 3)) * radius
        yellowLight.rotation.y = Math.getAngle(of: Vector2f(
            yellowLight.position.z,
            yellowLight.position.x
        )) + .pi
        
        magentaLight.position.z = sin(time + .pi * (1 / 3 + 1)) * radius
        magentaLight.position.x = cos(time + .pi * (1 / 3 + 1)) * radius
        magentaLight.rotation.y = Math.getAngle(of: Vector2f(
            magentaLight.position.z,
            magentaLight.position.x
        )) + .pi
        
    }
    
}
