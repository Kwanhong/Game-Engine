//
//  MeshLibrary.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

class MeshLibrary {
    
    private static var meshes: [MeshType:Mesh] = [:]
    
    public static func initialize() {
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes() {
        meshes.updateValue(TriangleCustomMesh(), forKey: .triangleCustom)
        meshes.updateValue(QuadCustomMesh(), forKey: .quadCustom)
        meshes.updateValue(CubeCustomMesh(), forKey: .cubeCustom)
    }
    
    public static func getMesh(_ meshType: MeshType)->Mesh {
        if let mesh = meshes[meshType] {
            return mesh
        } else {
            print("Error, There's no corresponding mesh of type: \(meshType)")
            return TriangleCustomMesh()
        }
    }
}

protocol Mesh {
    
    var vertexCount: Int! { get }
    var vertexBuffer: MTLBuffer! { get }
    var instanceCount: Int { get set }
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?)
    
}

class CustomMesh: Mesh {
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    var instanceCount: Int = 1
    var vertexCount: Int! {
        return vertices.count
    }
    
    init() {
        
        createVertices()
        createBuffers()
        
    }
    
    func createVertices() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1))
        ]
        
    }
    
    func createBuffers() {
        
        vertexBuffer = Engine.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride(vertices.count),
            options: []
        )
        
    }
    
    func drawPrimitives(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        renderCommandEncoder?.setVertexBuffer(
            vertexBuffer,
            offset: 0, index: 0
        )
        
        renderCommandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: .zero,
            vertexCount: vertexCount,
            instanceCount: instanceCount
        )
        
    }
    
}

class TriangleCustomMesh: CustomMesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init( 0, 1, 0), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 1, 0, 1)),
            .init(position: .init( 1,-1, 0), color: .init(0, 0, 1, 1))
        ]
        
    }
    
}

class QuadCustomMesh: CustomMesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1, 1, 0), color: .init(0, 1, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1)),
            .init(position: .init( 1, 1, 0), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1,-1, 0), color: .init(0, 0, 1, 1)),
            .init(position: .init( 1,-1, 0), color: .init(1, 0, 1, 1))
        ]
        
    }
    
}

class CubeCustomMesh: CustomMesh {
    
    override func createVertices() {
        
        vertices = [
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1)),
            
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1)),
            
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1)),
            .init(position: .init(-1,-1,-1), color: .init(1, 0, 0, 1)),
            
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1)),
            .init(position: .init(-1,-1, 1), color: .init(1, 1, 0, 1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1)),
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1)),
            
            .init(position: .init( 1,-1,-1), color: .init(1,1,0.5, 1)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1)),
            .init(position: .init( 1, 1,-1), color: .init(0, 1, 1, 1)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1)),
            
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1)),
            .init(position: .init(-1, 1,-1), color: .init(0, 0, 1, 1)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1)),
            .init(position: .init( 1, 1, 1), color: .init(1, 0, 1, 1)),
            .init(position: .init(-1, 1, 1), color: .init(0, 1, 0, 1)),
            .init(position: .init( 1,-1, 1), color: .init(0,0.5,1, 1)),
        ]
        
    }
    
}

