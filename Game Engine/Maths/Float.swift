//
//  Float.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/15.
//

import Foundation

extension Float {
    
    var toDegrees: Float {
        return Math.getDegrees(of: self)
    }
    
    var toRadians: Float {
        return Math.getRadians(of: self)
    }
    
    static var tau: Float {
        return .pi * 2
    }
    
}
