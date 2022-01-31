//
//  GameScene.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var lastUpdate = TimeInterval(0)
    var enemy:EnemySpawner!
    override func didMove(to view: SKView) {
        enemy = EnemySpawner(parent: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        let deltaTime = currentTime - lastUpdate
        enemy.update(dTime: deltaTime)
        lastUpdate = currentTime
    }
}
