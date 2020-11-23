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
    var yellowLight = LightObject(meshType: .f16)
    var blueLight = LightObject(meshType: .f16)
    var time: Float = .zero
    
    override func start() {
        
        camera.position.y = 2
        camera.position.z = 10
        self.addCamera(camera)
        
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
        
        let skybox = CubeObject()
        skybox.scale = Vector3f(repeating: 20)
        skybox.position.y = 15
        skybox.materialTextureType = .sky
        self.addChild(skybox)

        let dirts = CubeCollection(instanceCount: 100)
        dirts.scale = Vector3f(repeating: 2)
        dirts.position.y = -3
        dirts.materialTextureType = .grass
        self.addChild(dirts)

        var index = 0
        for x in -5..<5 {
            for z in -5..<5 {
                dirts.nodes[index].position.x = Float(x * 2) + 1
                dirts.nodes[index].position.z = Float(z * 2) + 1
                index += 1
            }
        }

        let f16 = F16Object()
        f16.position.x = -2
        f16.rotation.y = Float(-90).toRadians
        self.addChild(f16)
        
        let box = CubeObject()
        box.position.x = 2
        box.materialTextureType = .woodenBox
        self.addChild(box)
    }

    override func update() {
        time += deltaTime
        let radius = Float(7)
        blueLight.position.z = sin(time) * radius
        blueLight.position.x = cos(time) * radius
        blueLight.rotation.y = Math.getAngle(of: Vector2f(sin(time) * radius, cos(time) * radius)) + .pi
        yellowLight.position.z = -sin(time) * radius
        yellowLight.position.x = -cos(time) * radius
        yellowLight.rotation.y = Math.getAngle(of: Vector2f(-sin(time) * radius, -cos(time) * radius)) + .pi
    }
    
}
