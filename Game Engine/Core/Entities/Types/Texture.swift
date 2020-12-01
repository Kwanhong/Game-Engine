//
//  Texture.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/20.
//

import MetalKit

class Texture: NSObject {
    
    var texture: MTLTexture
    var name: String
    
    init(name: String, ext: String = "png", origin: MTKTextureLoader.Origin = .topLeft) {
        self.name = name
        self.texture = TextureLoader.loadFromBundle(name: name, ext: ext, origin: origin)!
    }
    
}
