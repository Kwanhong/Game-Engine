//
//  CubeCollection.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/17.
//

import Foundation

class CubeCollection: InstancedGameObject {
    
    init(instanceCount count: Int) {
        super.init(name: "Cube Collection", meshType: .cube, instanceCount: count)
    }
    
}
