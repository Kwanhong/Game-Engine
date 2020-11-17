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
    var time: Float = .zero
    
    var cubeCollection: CubeCollection = .init(instanceCount: 234)
    
    override func start() {
        
        self.addCamera(camera)
        self.cubeCollection.position.z = -3
        self.addChild(cubeCollection)
        
        let skybox = CubeObject()
        skybox.scale = .init(repeating: 5)
        skybox.position.z = -3
        self.addChild(skybox)
        
    }
    
    override func update() {
        
        time += deltaTime * timeScale
        
        let rads: Float = 25
        let yTol: Float = 0.25
        let xTol: Float = 0.25
        
        var index = 0
        
        cubeCollection.rotation.y = time
        
        for i in stride(from: Float(-1), to: Float(1.001), by: yTol) {
            
            let r = sqrt(1 - i * i) * rads
            
            for j in stride(from: Float.zero, to: Float.tau, by: xTol) {
                
                cubeCollection.nodes[index].position.x = cos(j + time) * r
                cubeCollection.nodes[index].position.z = sin(j + time) * r
                cubeCollection.nodes[index].position.y = -tan(i + time) * rads
                
                cubeCollection.nodes[index].rotation.x = sin(time) * .tau + j
                cubeCollection.nodes[index].rotation.y = cos(time) * .tau + j
                
                index += 1
            }
            
        }
        
    }
    
}
