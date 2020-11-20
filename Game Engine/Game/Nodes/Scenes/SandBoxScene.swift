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
    
    var cubeCollection: CubeCollection!
    
    override func start() {
        
        self.addCamera(camera)
        
        let box = CubeObject()
        box.position.z = -4
        box.setTexture(.woodenBox)
        self.addChild(box)
        
    }

}
