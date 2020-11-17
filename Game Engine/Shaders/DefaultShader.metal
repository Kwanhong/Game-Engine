//
//  DefaultShader.metal
//  Game Engine
//
//  Created by 박관홍 on 2020/09/28.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position[[attribute(0)]];
    float4 color[[attribute(1)]];
};

struct RasterizerData {
    float4 position[[position]];
    float4 color;
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct ModelConstants {
    float4x4 modelMatrix;
};

struct Material {
    float4 color;
    bool useMaterialColor;
};

vertex RasterizerData basic_vertex_shader(
    const VertexIn vertexIn [[stage_in]],
    constant SceneConstants &sceneConsts [[buffer(1)]],
    constant ModelConstants &modelConsts [[buffer(2)]]
) {
    
    RasterizerData data;
    
    data.color = vertexIn.color;
    
    data.position =
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        modelConsts.modelMatrix *
        float4(vertexIn.position, 1)
    ;
    
    return data;
}

fragment half4 basic_fragment_shader(
    RasterizerData data[[stage_in]],
    constant Material &material [[buffer(1)]]
) {
    
    float4 color = material.useMaterialColor ? material.color : data.color;
    
    return half4(color.r, color.g, color.b, color.a);
}

vertex RasterizerData instanced_vertex_shader(
    const VertexIn vertexIn [[stage_in]],
    constant SceneConstants &sceneConsts [[buffer(1)]],
    constant ModelConstants *modelConsts [[buffer(2)]],
    uint instanceId [[instance_id]]
) {
    
    RasterizerData data;
    
    data.color = vertexIn.color;
    
    data.position =
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        modelConsts[instanceId].modelMatrix *
        float4(vertexIn.position, 1)
    ;
    
    return data;
}
