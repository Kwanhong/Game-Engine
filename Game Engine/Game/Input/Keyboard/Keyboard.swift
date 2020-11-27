//
//  Keyboard.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/11/07.
//

import Foundation

protocol KeyboardDelegate {
    
    func onKeyReleased(keyCode: KeyCode)
    func onKeyPressed(keyCode: KeyCode)
    
}

class Keyboard {
    
    public static var delegate: KeyboardDelegate?
    
    private static var keyCount: Int = 256
    private static var keys: [Bool] = .init(repeating: false, count: keyCount)
    
    public static func setKeyPressed(_ keyCode: UInt16, isOn: Bool) {
        keys[Int(keyCode)] = isOn
        
        if let keyCode = KeyCode.init(rawValue: keyCode) {
            if isOn {
                delegate?.onKeyPressed(keyCode: keyCode)
            } else {
                delegate?.onKeyReleased(keyCode: keyCode)
            }
        }
    }
    
    public static func isKeyPressed(_ keyCode: KeyCode)->Bool {
        return keys[Int(keyCode.rawValue)]
    }
    
}
