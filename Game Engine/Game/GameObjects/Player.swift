//
//  Player.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/24.
//

import Foundation

class Player: GameObject {
    
    override func start() {
        self.scale = .init(repeating: 0.07)
    }
    
}
