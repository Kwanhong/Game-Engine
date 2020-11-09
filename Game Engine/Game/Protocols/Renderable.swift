//
//  Renderable.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation
import MetalKit

protocol Renderable {
    
    func doRender(_ renderCommandEncoder:MTLRenderCommandEncoder?)
    
}
