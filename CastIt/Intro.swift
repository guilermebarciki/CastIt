//
//  Intro.swift
//  CastIt
//
//  Created by Guilerme Barciki on 01/02/22.
//

import Foundation
import SpriteKit

class Intro {
    let sprite = SKSpriteNode(imageNamed: "introTemp")
    private var parent: SKNode
    
    
    init(parent: SKNode) {
        
        self.parent = parent
        sprite.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height/2)
        sprite.setScale(CGFloat(5)) // TODO
        parent.addChild(sprite)
        }
        
    
    
    func configureSprites(sprite: SKSpriteNode) {
        sprite.size = CGSize(width: 70, height: 70)
    }
    
    func removeFromParent() {
        sprite.removeFromParent()
    }
    
}
