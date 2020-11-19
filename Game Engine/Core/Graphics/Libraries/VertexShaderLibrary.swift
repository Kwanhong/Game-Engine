//
//  ShaderLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

enum VertexShaderType {
    case basic
    case instanced
}

class VertexShaderLibrary: GenericLibrary<VertexShaderType, Shader> {
    
    var functions: [VertexShaderType: MTLFunction] = [:]
    
    override internal func initialize() {
    
        let basicShader = Shader(
            name: "Basic Vertex Shader",
            functionName: "basic_vertex_shader"
        )
        
        library.updateValue(basicShader, forKey: .basic)
        functions.updateValue(basicShader.function, forKey: .basic)
        
        let instancedShader = Shader(
            name: "Instanced Vertex Shader",
            functionName: "instanced_vertex_shader"
        )
        
        library.updateValue(instancedShader, forKey: .instanced)
        functions.updateValue(instancedShader.function, forKey: .instanced)
        
    }
    
}
