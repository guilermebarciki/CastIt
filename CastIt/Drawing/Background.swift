//
//  Background.swift
//  CastIt
//
//  Created by Paulo Tadashi Tokikawa on 08/02/22.
//

import Foundation
import SpriteKit

class Background: CustomScene {
    let sprite = SKSpriteNode(imageNamed: "moon-background")
    var particles: SKEmitterNode = SKEmitterNode(fileNamed: "MagicParticles")!
    
    
    override init(parent: SKScene) {
        super.init(parent: parent)
        setBackground()
        node.addChild(sprite)
    }
    
    func setBackground() {
        sprite.position = CGPoint(x: parent.frame.size.width / 2, y: parent.frame.size.height / 2)
        sprite.zPosition = -3
        let sizeCoef = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: parent.size.width, height: parent.size.width * sizeCoef)
        
        let scene = parent as? GameScene
        if scene?.deviceType == .Iphone {
            sprite.position = CGPoint(x: parent.frame.size.width / 2, y: parent.frame.size.height * 3 / 4)
        }
        
        
        particles.zPosition = -2
        particles.position = sprite.position
        particles.position.y -= 250
        node.addChild(particles)
        
    }
}
