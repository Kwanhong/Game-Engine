//
//  TextureLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/20.
//

import MetalKit

enum TextureType: String {
    case woodenBox = "wooden_box"
    case none = "none"
}

class TextureLibrary: GenericLibrary<TextureType, Texture> {
    
    var textures: [TextureType: MTLTexture] = [:]
    
    override func initialize() {
        
        let texture = Texture(name: TextureType.woodenBox.rawValue)
        
        library.updateValue(texture, forKey: .woodenBox)
        textures.updateValue(texture.texture, forKey: .woodenBox)
        
    }
    
}

class TextureLoader {
    
    static func loadFromBundle(name: String, ext: String, origin: MTKTextureLoader.Origin)->MTLTexture? {
        
        let textureLoader = MTKTextureLoader(device: Engine.device)
        let options: [MTKTextureLoader.Option: Any] = [.origin: origin]
        var result: MTLTexture?
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                result = try textureLoader.newTexture(URL: url, options: options)
                result?.label = name
            } catch {
                print("Error, Load texture: \(name), \(error)")
            }
        } else {
            print("Error, Load texture: \(name), There's no texture resource")
        }
        
        return result
        
    }
    
}
