//
//  FragmentShaderLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/18.
//

import Foundation
import MetalKit

enum FragmentShaderType {
    case basic
}

class FragmentShaderLibrary: GenericLibrary<FragmentShaderType, Shader> {
    
    var functions: [FragmentShaderType: MTLFunction] = [:]
    
    override internal func initialize() {
        
        let basicShader = Shader(
            name: "Basic Fragment Shader",
            functionName: "basic_fragment_shader"
        )
        
        library.updateValue(basicShader, forKey: .basic)
        functions.updateValue(basicShader.function, forKey: .basic)
        
    }
    
}
