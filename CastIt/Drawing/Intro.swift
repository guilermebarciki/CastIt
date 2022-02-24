//
//  Intro.swift
//  CastIt
//
//  Created by Guilerme Barciki on 01/02/22.
//

import Foundation
import SpriteKit

class Intro: CustomScene {
    let sprite = SKSpriteNode(imageNamed: "tutorial-0")
    var spriteTexture = [SKTexture]()
    let videoNode = SKVideoNode(fileNamed: "tutorial video.mp4")
//    var spriteTexture = [SKTexture]()
    
    override init(parent: SKScene) {
        super.init(parent: parent)
        
        for i in 1...149 {
            spriteTexture.append(SKTexture(imageNamed: "tutorial-\(i)"))
        }
        let animation = SKAction.animate(with: spriteTexture, timePerFrame: 0.03)
        sprite.run(SKAction.repeatForever(animation))
        node.addChild(sprite)
        sprite.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height/2)
        

        let sizeCoef =  9.0/16.0
        sprite.size = CGSize(width: parent.frame.width ?? CGFloat(0),
                                height: (parent.frame.width ?? CGFloat(0)) * CGFloat(sizeCoef))
//        videoNode.inputView?.contentMode = .scaleAspectFit
//        node.addChild(videoNode)
////        videoNode.play()
//        let action = SKAction.repeatForever(SKAction.sequence([SKAction.play(), SKAction.wait(forDuration: 5)]))
//        videoNode.run(action)
        
        
    }
   
}
