//
//  Keyboard.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/07.
//

import Foundation

class Keyboard {
    
    private static var keyCount: Int = 256
    private static var keys: [Bool] = .init(repeating: false, count: keyCount)
    
    public static func setKeyPressed(_ keyCode: UInt16, isOn: Bool) {
        keys[Int(keyCode)] = isOn
    }
    
    public static func isKeyPressed(_ keyCode: KeyCode)->Bool {
        return keys[Int(keyCode.rawValue)]
    }
    
}
