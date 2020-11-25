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
    
    float4 worldPosition = (
        modelConsts[instanceId].modelMatrix *
        float4(vertexIn.position, 1)
    );
    
    RasterizerData data;
    
    data.texcoord = vertexIn.texcoord;
    
    data.color = vertexIn.color;
    
    data.worldPosition = worldPosition.xyz;
    
    data.toCameraVector = sceneConsts.cameraPosition - worldPosition.xyz;
    
    data.surfaceNormal = (
        modelConsts[instanceId].modelMatrix *
        float4(vertexIn.normal, 1)
    ).xyz;
    
    data.position = (
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        worldPosition
    );
    
    return data;
}
