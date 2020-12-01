//
//  Shared.metal
//  Game Engine
//
//  Created by 박관홍 on 2020/11/19.
//

#ifndef SHARED_METAL
#define SHARED_METAL

#import <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position[[attribute(0)]];
    float4 color[[attribute(1)]];
    float2 texcoord[[attribute(2)]];
    float3 normal[[attribute(3)]];
    float3 tangent[[attribute(4)]];
    float3 bitangent[[attribute(5)]];
};

struct RasterizerData {
    float4 position[[position]];
    float4 color;
    float2 texcoord;
    float3 worldPosition;
    float3 toCameraVector;
    float3 surfaceNormal;
    float3 surfaceTangent;
    float3 surfaceBitangent;
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
    float3 cameraPosition;
};

struct ModelConstants {
    float4x4 modelMatrix;
};

struct Material {
    float4 color;
    float3 ambient;
    float3 diffuse;
    float3 specular;
    float shininess;
    bool isLit;
};

struct LightData {
    float3 color;
    float3 position;
    float brightness;
    float ambientIntensity;
    float diffuseIntensity;
    float specularIntensity;
};

#endif
