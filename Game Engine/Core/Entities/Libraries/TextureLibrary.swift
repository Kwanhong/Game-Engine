//
//  TextureLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/20.
//

import MetalKit

enum TextureType: String {
    case modelTexture = "modelTexture"
    case woodenBox = "wooden_box"
    case grass = "grass"
    case sky = "sky"
    case f16t = "F16t"
    case f16s = "F16s"
    case none = "none"
}

class TextureLibrary: GenericLibrary<TextureType, Texture> {
    
    var textures: [TextureType: MTLTexture] = [:]
    
    override func initialize() {
        
        updateLibrary(type: .woodenBox)
        updateLibrary(type: .grass)
        updateLibrary(type: .sky)
        updateLibrary(type: .f16t, ext: "bmp", origin: .bottomLeft)
        updateLibrary(type: .f16s, ext: "bmp", origin: .bottomLeft)
        
    }
    
    func updateLibrary(type: TextureType, ext: String = "png", origin: MTKTextureLoader.Origin = .topLeft) {
        
        let texture = Texture(name: type.rawValue, ext: ext, origin: origin)
        
        library.updateValue(texture, forKey: type)
        textures.updateValue(texture.texture, forKey: type)
        
    }
    
}

class TextureLoader {
    
    static func loadFromBundle(name: String, ext: String, origin: MTKTextureLoader.Origin)->MTLTexture? {
        
        let textureLoader = MTKTextureLoader(device: Engine.device)
        let options: [MTKTextureLoader.Option: Any] = [.origin: origin, .generateMipmaps: true]
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
