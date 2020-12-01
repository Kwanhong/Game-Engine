//
//  BasicShader.metal
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

#include <metal_stdlib>
#include "Shared.metal"
#include "Lighting.metal"
using namespace metal;

vertex RasterizerData basic_vertex_shader(
    const VertexIn vertexIn [[stage_in]],
    constant SceneConstants &sceneConsts [[buffer(1)]],
    constant ModelConstants &modelConsts [[buffer(2)]]
) {
    
    float4 worldPosition = (
         modelConsts.modelMatrix *
         float4(vertexIn.position, 1)
     );
    
    RasterizerData data;
    
    data.texcoord = vertexIn.texcoord;
    
    data.color = vertexIn.color;
    
    data.worldPosition = worldPosition.xyz;
    
    data.toCameraVector = sceneConsts.cameraPosition - worldPosition.xyz;
    
    data.surfaceNormal = (
        modelConsts.modelMatrix *
        float4(vertexIn.normal, 1)
    ).xyz;
    
    data.surfaceTangent = (
        modelConsts.modelMatrix *
        float4(vertexIn.tangent, 1)
    ).xyz;
    
    data.surfaceBitangent = (
        modelConsts.modelMatrix *
        float4(vertexIn.bitangent, 1)
    ).xyz;
    
    data.position = (
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        worldPosition
    );
    
    return data;
}
 
fragment half4 basic_fragment_shader(
    RasterizerData data [[stage_in]],
    constant Material &material [[buffer(1)]],
    constant int &lightCount [[buffer(2)]],
    constant LightData *lightDatas [[buffer(3)]],
    sampler sampler2d [[sampler(0)]],
    texture2d<float> texture [[texture(0)]],
    texture2d<float> normalMap [[texture(1)]]
) {
    
    float4 color = material.color;
    
    if (!is_null_texture(texture)) {
        color = texture.sample(sampler2d, data.texcoord);
    }
    
    if (material.isLit) {
        
        float3 unitNormal = normalize(data.surfaceNormal);
        if (!is_null_texture(normalMap)) {
            float3 sampleNormal = texture.sample(sampler2d, data.texcoord).rgb * 2 - 1;
            float3x3 tbnMatrix = { data.surfaceTangent, data.surfaceBitangent, data.surfaceNormal };
            unitNormal = tbnMatrix * sampleNormal;
        }
        
        color *= float4(Lighting::PhongSader(
            material, lightDatas, lightCount,
            data.worldPosition, unitNormal, data.toCameraVector
        ), 1);
        
    }
    
    return half4(color.r, color.g, color.b, color.a);
}
