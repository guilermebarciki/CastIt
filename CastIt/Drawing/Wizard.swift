//
//  Wizard.swift
//  CastIt
//
//  Created by Guilerme Barciki on 22/02/22.
//

import Foundation

import SpriteKit

class Wizard: CustomScene {
    let wizard = SKSpriteNode(imageNamed: "Mage1")
    var wizardTextures: [SKTexture] = []
    
    var position: CGPoint
    
    init(parent: SKScene, position: CGPoint) {
        self.position = position
        super.init(parent: parent)
        
        for i in 1...8 {
            wizardTextures.append(SKTexture(imageNamed: "Mage\(i).png"))
        }
        var animation = SKAction()
        animation = SKAction.animate(with: wizardTextures, timePerFrame: 0.150)
            wizard.run(SKAction.repeatForever(animation))
        wizard.position = position
        wizard.zPosition = 3
        node.addChild(wizard)
        
        
    }
    
    func configureSprites(sprite: SKSpriteNode) {
        sprite.alpha = 1
        sprite.size = CGSize(width: 120, height: 120)
    }
    
}
