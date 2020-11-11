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
    var time: Float = .zero
    
    override func start() {
        
        camera = DebugCamera()
        self.addCamera(camera)
        
        let playerCount = 10
        
        for _ in 0..<playerCount {
            let player = Player(meshType: .cubeCustom)
            self.addChild(player)
            players.append(player)
        }
    }
    
    override func update() {
        
        time += deltaTime * 0.1
        let zPos = Float(-3)
        let mousePos = Mouse.getMouseCameraPosition(camera: camera)
        var posPerPlayer = Vector3f(0, 0, zPos)
        
        let v1 = Math.getVector(direction: mousePos, withMagnitudeOf: 2)
        let v2 = Math.getVector(direction: players.last?.position.asVector2f ?? .zero, withMagnitudeOf: 1)
        let theta = Math.getAngle(of: v1 - v2)
        
        for player in players {
            player.rotation.x = sin(time) * .pi * 2
            player.rotation.z = theta
            player.position.x = posPerPlayer.x
            player.position.y = posPerPlayer.y
            player.position.z = posPerPlayer.z
            posPerPlayer.x += mousePos.x / Float(players.count - 1)
            posPerPlayer.y += mousePos.y / Float(players.count - 1)
            posPerPlayer.z -= (zPos) / Float(players.count - 1)
        }
    }
    
}
