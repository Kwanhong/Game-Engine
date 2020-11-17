//
//  CubeCollection.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/17.
//

import Foundation

class CubeCollection: InstancedGameObject {
    
    init(instanceCount count: Int) {
        super.init(meshType: .cubeCustom, instanceCount: count)
    }
    
    override func start() {
        self.scale = .init(repeating: 0.02)
    }
    
}
