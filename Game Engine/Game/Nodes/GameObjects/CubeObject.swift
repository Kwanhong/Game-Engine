//
//  CubeObject.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation

class CubeObject: GameObject {
    
    init() {
        super.init(name: "Cube Object", meshType: .cubeCustom)
    }
    
    override func start() {
        self.scale = .init(repeating: 0.01)
    }
    
}
