//
//  ShaderLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/09/30.
//

import MetalKit

class ShaderLibrary {
    
    static var defaultLibrary: MTLLibrary!
    
    private static var vertexShaders: [VertexShaderType: Shader] = [:]
    private static var fragmentShaders: [FragmentShaderType: Shader] = [:]
    
    static func initialize() {
        defaultLibrary = Engine.device.makeDefaultLibrary()
        createDefaultShaders()
    }
    
    private static func createDefaultShaders() {
        
        // Vertex Shaders
        vertexShaders.updateValue(BasicVertexShader(), forKey: .basic)
        vertexShaders.updateValue(InstancedVertexShader(), forKey: .instanced)
        
        // Fragment Shaders
        fragmentShaders.updateValue(BasicFragmentShader(), forKey: .basic)
    }
    
    static func getVertexFunction(_ type: VertexShaderType)->MTLFunction {
        return vertexShaders[type]!.function
    }
    
    static func getFragmentFunction(_ type: FragmentShaderType)->MTLFunction {
        return fragmentShaders[type]!.function
    }
}

protocol Shader {
    var name: String { get  }
    var functionName: String { get }
    var function: MTLFunction { get }
}

class BasicVertexShader: Shader {
    let name: String = "Basic Vertex Shader"
    let functionName: String = "basic_vertex_shader"
    
    var function: MTLFunction
    
    init() {
        function = ShaderLibrary.defaultLibrary.makeFunction(name: functionName)!
        function.label = name
    }
}

class InstancedVertexShader: Shader {
    let name: String = "Instanced Vertex Shader"
    let functionName: String = "instanced_vertex_shader"
    
    var function: MTLFunction
    
    init() {
        function = ShaderLibrary.defaultLibrary.makeFunction(name: functionName)!
        function.label = name
    }
}

class BasicFragmentShader: Shader {
    var name: String = "Basic Fragment Shader"
    var functionName: String = "basic_fragment_shader"
    
    var function: MTLFunction
    
    init() {
        function = ShaderLibrary.defaultLibrary.makeFunction(name: functionName)!
        function.label = name
    }
}
