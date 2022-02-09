//
//  Background.swift
//  CastIt
//
//  Created by Paulo Tadashi Tokikawa on 08/02/22.
//

import Foundation
import SpriteKit

class Background: CustomScene {
    let sprite = SKSpriteNode(imageNamed: "background1")
    
    override init(parent: SKScene) {
        super.init(parent: parent)
        sprite.position = CGPoint(x: parent.frame.size.width / 2, y: parent.frame.size.height / 2)
        sprite.zPosition = -3
        let sizeCoef = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: parent.size.width, height: parent.size.width * sizeCoef)
        node.addChild(sprite)
    }
    
    
}
