//
//  LightManager.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/23.
//

import Foundation
import Metal

class LightManager {
    
    private var lightObjects: [LightObject] = []
    
    func addLight(object: LightObject) {
        lightObjects.append(object)
    }
    
    private func getLightData()->[LightData] {
        
        var datas: [LightData] = []
        for light in lightObjects {
            datas.append(light.lightData)
        }
        
        return datas
        
    }
    
    func setLightData(_ renderCommandEncoder: MTLRenderCommandEncoder?) {
        
        var lightData = getLightData()
        var lightCount = lightData.count
        
        renderCommandEncoder?.setFragmentBytes(
            &lightCount,
            length: Int32.size,
            index: 2
        )
        
        renderCommandEncoder?.setFragmentBytes(
            &lightData,
            length: LightData.stride(lightCount),
            index: 3
        )
        
    }
    
}

extension LightObject {
    
    var lightColor: Vector3f {
        set { self.lightData.color = newValue }
        get { return self.lightData.color }
    }
    
    var brightness: Float {
        set { self.lightData.brightness = newValue }
        get { return self.lightData.brightness }
    }
    
    var ambientIntensity: Float {
        set { self.lightData.ambientIntensity = newValue }
        get { return self.lightData.ambientIntensity }
    }
    
}
