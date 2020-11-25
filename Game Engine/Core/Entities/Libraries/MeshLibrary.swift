//
//  MeshLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

enum MeshType {
    case empty
    case builtInTriangle
    case builtInQuad
    case builtInCube
    case f16
}

class MeshLibrary: GenericLibrary<MeshType, Mesh> {
    
    override internal func initialize() {
        
        library.updateValue(EmptyMesh(), forKey: .empty)
        library.updateValue(TriangleBuiltInMesh(), forKey: .builtInTriangle)
        library.updateValue(QuadBuiltInMesh(), forKey: .builtInQuad)
        library.updateValue(CubeBuiltInMesh(), forKey: .builtInCube)
        library.updateValue(ModelMesh(name: "f16"), forKey: .f16)
        
    }
    
}
