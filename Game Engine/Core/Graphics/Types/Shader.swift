//
//  Shader.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/18.
//

import Foundation
import Metal

class Shader: NSObject {
    
    var name: String
    var functionName: String
    var function: MTLFunction
    
    init(name: String, functionName: String) {
        self.name = name
        self.functionName = functionName
        self.function = Engine.shaderLibrary.makeFunction(
            name: functionName
        )!
    }
    
}

