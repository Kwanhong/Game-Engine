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
    
    data.position = (
        sceneConsts.projectionMatrix *
        sceneConsts.viewMatrix *
        worldPosition
    );
    
    return data;
}
 
fragment half4 basic_fragment_shader(
    RasterizerData data[[stage_in]],
    constant Material &material [[buffer(1)]],
    constant int &lightCount [[buffer(2)]],
    constant LightData *lightDatas [[buffer(3)]],
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
    
    if (material.usePhongShader) {
        
        float3 totalAmbient = float3(0, 0, 0);
        float3 totalDiffuse = float3(0, 0, 0);
        float3 totalSpecular = float3(0, 0, 0);
        
        for (int i = 0; i < lightCount; i++) {
            
            LightData lightData = lightDatas[i];
            
            totalAmbient += clamp((
                (material.ambient * lightData.ambientIntensity) *
                (lightData.color * lightData.brightness)
            ), 0.0, 1.0);
            
            totalDiffuse += clamp((
                (material.diffuse * lightData.diffuseIntensity) *
                (lightData.color * lightData.brightness) *
                max(dot( // Surface normal dot product
                    normalize(data.surfaceNormal),
                    normalize(lightData.position - data.worldPosition)
                ), 0.0)
            ), 0.0, 1.0);
            
            totalSpecular += clamp((
                (material.specular * lightData.specularIntensity) *
                (lightData.color * lightData.brightness) *
                pow(max(dot( // Refection normal dot product
                    normalize(data.toCameraVector),
                    normalize(reflect((
                        data.worldPosition -
                        lightData.position
                    ), data.surfaceNormal))
                ), 0.0), material.shininess)
            ), 0.0, 1.0);
            
        }
        
        float3 phong = totalAmbient + totalDiffuse + totalSpecular;
        
        color *= float4(phong, 1);
        
    }
    
    return half4(color.r, color.g, color.b, color.a);
}

