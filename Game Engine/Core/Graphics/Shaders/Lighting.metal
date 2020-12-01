//
//  Lighting.metal
//  Game Engine
//
//  Created by 박관홍 on 2020/12/01.
//

#ifndef LIGHTING_METAL
#define LIGHTING_METAL

#include <metal_stdlib>
#include "Shared.metal"
using namespace metal;

class Lighting {
    
public: static float3 PhongSader(
        constant Material &material,
        constant LightData *lightDatas,
        int lightCount,
        float3 worldPosition,
        float3 unitNormal,
        float3 unitToCameraVector
    ) {
        
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
                    unitNormal,
                    normalize(lightData.position - worldPosition)
                ), 0.0)
            ), 0.0, 1.0);
            
            totalSpecular += clamp((
                (material.specular * lightData.specularIntensity) *
                (lightData.color * lightData.brightness) *
                pow(max(dot( // Refection normal dot product
                    normalize(unitToCameraVector),
                    normalize(reflect((
                        worldPosition -
                        lightData.position
                    ), unitNormal))
                ), 0.0), material.shininess)
            ), 0.0, 1.0);
            
        }
        
        return totalAmbient + totalDiffuse + totalSpecular;
        
    }

};

#endif
