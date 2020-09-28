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

vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[stage_in]]) {
    
    RasterizerData data;
    data.position = float4(vertexIn.position, 1);
    data.color = vertexIn.color;
    
    return data;
}

fragment half4 basic_fragment_shader(RasterizerData data[[stage_in]]) {
    
    float4 color = data.color;
    return half4(color.r, color.g, color.b, color.a);
}
