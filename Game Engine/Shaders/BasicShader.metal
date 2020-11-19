//
//  BasicShader.metal
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

#include <metal_stdlib>
#include "Shared.metal"
using namespace metal;

vertex RasterizerData basic_vertex_shader(
    const VertexIn vertexIn [[stage_in]],
    constant SceneConstants &sceneConsts [[buffer(1)]],
    constant ModelConstants &modelConsts [[buffer(2)]]
) {
    
    RasterizerData data;
    
    data.texcoord = vertexIn.texcoord;
    
    data.color = vertexIn.color;
    
    data.position = (
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        modelConsts.modelMatrix *
        float4(vertexIn.position, 1)
    );
    
    return data;
}

fragment half4 basic_fragment_shader(
    RasterizerData data[[stage_in]],
    constant Material &material [[buffer(1)]]
) {
    
    float4 color = material.useMaterialColor ? material.color : data.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
