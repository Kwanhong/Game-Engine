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
    case triangleCustom
    case quadCustom
    case cube
    case plane
    case f16
}

class MeshLibrary: GenericLibrary<MeshType, Mesh> {
    
    override internal func initialize() {
        
        library.updateValue(EmptyMesh(), forKey: .empty)
        library.updateValue(TriangleMesh(), forKey: .triangleCustom)
        library.updateValue(QuadMesh(), forKey: .quadCustom)
        library.updateValue(ModelMesh(name: "plane"), forKey: .plane)
        library.updateValue(ModelMesh(name: "cube"), forKey: .cube)
        library.updateValue(ModelMesh(name: "f16"), forKey: .f16)
        
    }
    
}
