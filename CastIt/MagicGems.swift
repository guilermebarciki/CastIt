//
//  MagicGems.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import Foundation
import SpriteKit

class MagicGems {
    let gemsSprites: [SKSpriteNode] = [
        SKSpriteNode(imageNamed: "gem0"),
        SKSpriteNode(imageNamed: "gem1"),
        SKSpriteNode(imageNamed: "gem2"),
        SKSpriteNode(imageNamed: "gem3"),
        SKSpriteNode(imageNamed: "gem4")]
    private var parent: SKNode
    var gemPositions: [CGPoint]
    
    init(parent: SKNode, gemPosition: [CGPoint]) {
        self.gemPositions = gemPosition
        self.parent = parent
        
        if gemPosition.count == gemsSprites.count {
            for i in 0..<gemPosition.count {
                
                gemsSprites[i].position = gemPosition[i]
                configureSprites(sprite: gemsSprites[i])
                parent.addChild(gemsSprites[i])
            }
        }
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 700))
        gemsSprites[1].physicsBody = body
        gemsSprites[1].physicsBody?.affectedByGravity = false
        gemsSprites[1].physicsBody?.contactTestBitMask = 3
        
    }
    
    func configureSprites(sprite: SKSpriteNode) {
        sprite.size = CGSize(width: 70, height: 70)
    }
    
}
