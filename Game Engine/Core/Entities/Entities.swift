//
//  Entities.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/18.
//

import MetalKit

enum EntityLibraryType {
    case mesh
    case texture
    case none
}

class Entities {
    
    static private var shared: Entities!
    
    private var libraries: [EntityLibraryType: Library] = [:]
    
    static func initialize() {
        
        shared = .init()
        shared.libraries.updateValue(MeshLibrary(), forKey: .mesh)
        shared.libraries.updateValue(TextureLibrary(), forKey: .texture)
        shared.libraries.updateValue(EmptyLibrary(), forKey: .none)
        
    }
    
    static private func libraries<T: Library>(_ type: T.Type)->T {
        return shared.libraries[getType(of: T.self)]! as! T
    }
    
    private static func getType<T: Library>(of type: T.Type)->EntityLibraryType {
        
        if type == MeshLibrary.self {
            return .mesh
        } else if type == TextureLibrary.self {
            return .texture
        } else {
            return .none
        }
        
    }
    
}

extension Entities {
    
    class Res {
        
        static var texture: [TextureType: MTLTexture] {
            return Lib.texture.textures
        }
        
    }
    
}

extension Entities {
    
    class Lib {
        
        static var mesh: MeshLibrary {
            return libraries(MeshLibrary.self)
        }
        
        static var texture: TextureLibrary {
            return libraries(TextureLibrary.self)
        }
        
    }
    
}
