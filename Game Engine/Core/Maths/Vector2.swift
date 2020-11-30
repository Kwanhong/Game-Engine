//
//  Vector.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/15.
//

import Foundation
import MetalKit

extension Vector2f {
    
    var asCGPoint: CGPoint {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    
    var asVector3f: Vector3f {
        return Vector3f(self.x, self.y, .zero)
    }
    
    func asVector3f(z: Float)->Vector3f {
        return Vector3f(x, y, z)
    }
    
    var angle: Float {
        return Math.getAngle(of: self)
    }
    
    var magnitude: Float {
        return Math.getMagnitude(of: self)
    }
    
    var normalized: Vector2f {
        return Math.getNormalized(vector: self)
    }
    
    mutating func setMagnitude(to magnitude: Float) {
        Math.setMagnitude(magnitude, to: &self)
    }
    
    mutating func normalize() {
        Math.normalize(&self)
    }
    
    mutating func rotate(to theta: Float) {
        Math.rotate(vector: &self, to: theta)
    }
    
    func rotated(to theta: Float)->Vector2f {
        return Math.getRotated(vector: self, to: theta)
    }
    
}
