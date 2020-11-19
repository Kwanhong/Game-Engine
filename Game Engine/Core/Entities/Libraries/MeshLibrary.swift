//
//  MeshLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

enum MeshType {
    case triangleCustom
    case quadCustom
    case cubeCustom
}

class MeshLibrary: GenericLibrary<MeshType, Mesh> {
    
    override internal func initialize() {
        
        library.updateValue(TriangleMesh(), forKey: .triangleCustom)
        library.updateValue(QuadMesh(), forKey: .quadCustom)
        library.updateValue(CubeMesh(), forKey: .cubeCustom)
        
    }
    
}
