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
    constant Material &material [[buffer(1)]],
    sampler sampler2d [[sampler(0)]],
    texture2d<float> texture [[texture(0)]]
) {
    
    float4 color;
    
    if (material.useTexture) {
        color = texture.sample(sampler2d, data.texcoord);
    } else if (material.useMaterialColor) {
        color = material.color;
    } else {
        color = data.color;
    }
    
    return half4(color.r, color.g, color.b, color.a);
}
