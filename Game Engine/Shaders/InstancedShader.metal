//
//  InstancedShader.metal
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

#include <metal_stdlib>
#include "Shared.metal"
using namespace metal;

vertex RasterizerData instanced_vertex_shader(
    const VertexIn vertexIn [[stage_in]],
    constant SceneConstants &sceneConsts [[buffer(1)]],
    constant ModelConstants *modelConsts [[buffer(2)]],
    uint instanceId [[instance_id]]
) {
    
    RasterizerData data;
    
    data.texcoord = vertexIn.texcoord;
    
    data.color = vertexIn.color;
    
    data.position = (
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        modelConsts[instanceId].modelMatrix *
        float4(vertexIn.position, 1)
    );
    
    return data;
}
