//
//  MagicGems.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import Foundation
import SpriteKit

class MagicGems:CustomScene {
    let gemsSprites: [SKSpriteNode] = [
        SKSpriteNode(imageNamed: "1stone1"),
        SKSpriteNode(imageNamed: "1stone1"),
        SKSpriteNode(imageNamed: "1stone1"),
        SKSpriteNode(imageNamed: "1stone1"),
        SKSpriteNode(imageNamed: "1stone1")]
    var gemTextures: [[SKTexture]] = []
    var gemPositions: [CGPoint]
    
    init(parent: SKScene, gemPosition: [CGPoint]) {
        self.gemPositions = gemPosition
        super.init(parent: parent)
        
        setGemTextures()
       
        
        var animation = SKAction()
        for i in 0..<gemsSprites.count {
            animation = SKAction.animate(with: gemTextures[i], timePerFrame: 0.1)
            gemsSprites[i].run(SKAction.repeatForever(animation))
        }
        
        if gemPosition.count == gemsSprites.count {
            for i in 0..<gemPosition.count {
                gemsSprites[i].position = gemPosition[i]
                configureSprites(sprite: gemsSprites[i])
                node.addChild(gemsSprites[i])
            }
        }
        
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 5000))
        gemsSprites[1].physicsBody = body
        gemsSprites[1].physicsBody?.affectedByGravity = false
        gemsSprites[1].physicsBody?.contactTestBitMask = 1
        gemsSprites[1].physicsBody?.categoryBitMask = 1
        gemsSprites[1].physicsBody?.node?.name = "chicken"

        
    }
    
    func configureSprites(sprite: SKSpriteNode) {
        sprite.alpha = 1
        sprite.size = CGSize(width: 120, height: 120)
    }
    func setGemTextures() {
        for j in 1...gemsSprites.count {
            var auxVec = [SKTexture]()
            for i in 1...60 {
                auxVec.append(SKTexture(imageNamed: "\(j)stone\(i).png"))
                print("gemtexture \(gemTextures)")
            }
            gemTextures.append(auxVec)
        }
    }
}
