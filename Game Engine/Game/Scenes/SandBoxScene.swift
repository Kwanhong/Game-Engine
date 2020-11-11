//
//  SandBoxScene.swift
//  Game Engine
//
//  Created by 박관홍 on 2020/10/25.
//

import Foundation

class SandBoxScene: Scene {
    
    var players: [Player] = []
    var camera: Camera!
    
    override func start() {
        
        camera = DebugCamera()
        self.addCamera(camera)
        
        let playerCount = 10
        
        for _ in 0..<playerCount {
            let player = Player(meshType: .triangleCustom)
            self.addChild(player)
            players.append(player)
        }
    }
    
    override func update() {
        
        let mousePos = Mouse.getMouseCameraPosition(camera: camera)
        var posPerPlayer = mousePos
        
        let v1 = Math.getVector(mousePos, withMagnitudeOf: 2)
        let v2 = Math.getVector(players.first?.position.asVector2 ?? .zero, withMagnitudeOf: 1)
        let theta = Math.getAngle(of: v1 - v2) - .pi * 0.5
        
        for player in players {
            player.rotation.z = theta
            player.position.x = posPerPlayer.x
            player.position.y = posPerPlayer.y
            posPerPlayer.x -= mousePos.x / Float(players.count - 1)
            posPerPlayer.y -= mousePos.y / Float(players.count - 1)
        }
    }
    
}
