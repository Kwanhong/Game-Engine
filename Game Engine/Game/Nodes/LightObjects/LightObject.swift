//
//  LightObject.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/23.
//

import Foundation

class LightObject: GameObject {
    
    var lightData: LightData = .init()
    
    override init(name: String = "Light Object", meshType: MeshType = .empty) {
        super.init(name: name, meshType: meshType)
    }
    
    override func lateUpdate() {
        lightData.position = position
    }
    
}
