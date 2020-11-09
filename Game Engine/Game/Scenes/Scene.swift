//
//  Scene.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/25.
//

import Foundation

class Scene: Node {
    
    override init() {
        super.init()
        start()
    }
    
    
    override func update(deltaTime: Float) {
        self.update()
        super.update(deltaTime: deltaTime)
        self.lateUpdate()
    }
    
    func start() { }
    
    func update() { }
    
    func lateUpdate() { }
}
