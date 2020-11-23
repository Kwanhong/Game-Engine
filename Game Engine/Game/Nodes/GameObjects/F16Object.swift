//
//  F16Object.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/20.
//

import MetalKit

class F16Object: GameObject {
    
    init() {
        super.init(name: "F16 Object", meshType: .f16)
        self.materialTextureType = .f16s
        self.scale = Vector3f(repeating: 3)
    }
    
}
