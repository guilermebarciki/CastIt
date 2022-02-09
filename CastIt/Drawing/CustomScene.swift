//
//  CustomScene.swift
//  CastIt
//
//  Created by Paulo Tadashi Tokikawa on 08/02/22.
//

import Foundation
import SpriteKit


class CustomScene {
    var parent: SKScene!
    var node = SKNode()

    init(parent: SKScene){
        self.parent = parent
    }
    
    func show() {
        parent.addChild(node)
    }
    func hide() {
        node.removeFromParent()
    }
    
}
