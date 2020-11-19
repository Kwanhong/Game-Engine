//
//  Graphics.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/18.
//

import Foundation
import MetalKit

enum GraphicLibraryType {
    case vertexShader
    case fragmentShader
    case vertexDescriptor
    case depthStencilState
    case renderPipelineDescriptor
    case renderPipelineState
    case none
}

class Graphics {
    
    static private var shared: Graphics!
    
    private var libraries: [GraphicLibraryType: Library] = [:]
    
    static func initialize() {
        
        shared = .init()
        shared.libraries.updateValue(VertexShaderLibrary(), forKey: .vertexShader)
        shared.libraries.updateValue(FragmentShaderLibrary(), forKey: .fragmentShader)
        shared.libraries.updateValue(VertexDescriptorLibrary(), forKey: .vertexDescriptor)
        shared.libraries.updateValue(DepthStencilStateLibrary(), forKey: .depthStencilState)
        shared.libraries.updateValue(RenderPipelineDescriptorLibrary(), forKey: .renderPipelineDescriptor)
        shared.libraries.updateValue(RenderPipelineStateLibrary(), forKey: .renderPipelineState)
        shared.libraries.updateValue(EmptyLibrary(), forKey: .none)
        
    }
    
    static private func libraries<T: Library>(_ type: T.Type)->T {
        return shared.libraries[getType(of: T.self)]! as! T
    }
    
    private static func getType<T: Library>(of type: T.Type)->GraphicLibraryType {
        
        if type == VertexShaderLibrary.self {
            return .vertexShader
        } else if type == FragmentShaderLibrary.self {
            return .fragmentShader
        } else if type == VertexDescriptorLibrary.self {
            return .vertexDescriptor
        } else if type == DepthStencilStateLibrary.self {
            return .depthStencilState
        } else if type == RenderPipelineDescriptorLibrary.self {
            return .renderPipelineDescriptor
        } else if type == RenderPipelineStateLibrary.self {
            return .renderPipelineState
        } else { return .none }
        
    }
    
}

extension Graphics {
    
    class Desc {
        
        static var vertex: [VertexDescriptorType: MTLVertexDescriptor] {
            return Lib.vertexDescriptor.descriptors
        }
        
        static var renderPipeline: [RenderPipelineDescriptorType: MTLRenderPipelineDescriptor] {
            return Lib.renderPipelineDescriptor.descriptors
        }
        
    }
    
}

extension Graphics {
    
    class State {
        
        static var depthStencil: [DepthStencilStateType: MTLDepthStencilState] {
            return Lib.depthStencilState.states
        }
        
        static var renderPipeline: [RenderPipelineStateType: MTLRenderPipelineState] {
            return Lib.renderPipelineState.states
        }
        
    }
    
}

extension Graphics {
    
    class Func {
        
        static var vertexShader: [VertexShaderType: MTLFunction] {
            return Lib.vertexShader.functions
        }
        
        static var fragmentShader: [FragmentShaderType: MTLFunction] {
            return Lib.fragmentShader.functions
        }
        
    }
    
}

extension Graphics {
    
    class Lib {
        
        static var vertexShader: VertexShaderLibrary {
            return libraries(VertexShaderLibrary.self)
        }
        
        static var fragmentShader: FragmentShaderLibrary {
            return libraries(FragmentShaderLibrary.self)
        }
        
        static var vertexDescriptor: VertexDescriptorLibrary {
            return libraries(VertexDescriptorLibrary.self)
        }
        
        static var depthStencilState: DepthStencilStateLibrary {
            return libraries(DepthStencilStateLibrary.self)
        }
        
        static var renderPipelineDescriptor: RenderPipelineDescriptorLibrary {
            return libraries(RenderPipelineDescriptorLibrary.self)
        }
        
        static var renderPipelineState: RenderPipelineStateLibrary {
            return libraries(RenderPipelineStateLibrary.self)
        }
        
    }
    
}
