//
//  GameOver.swift
//  CastIt
//
//  Created by Guilerme Barciki on 01/02/22.
//

import Foundation
import SpriteKit

class GameOver: CustomScene {
    let sprite = SKSpriteNode(imageNamed: "gameOverTemp")
    private var scoreLabel: SKLabelNode
    let formatter = NumberFormatter()
    
    
    override init(parent: SKScene) {
        scoreLabel = SKLabelNode()
        super.init(parent: parent)
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        
        scoreLabel.zPosition = CGFloat.infinity
        scoreLabel.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height * 2/3)
        scoreLabel.fontSize = CGFloat(36)
        sprite.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height/2)
        sprite.setScale(CGFloat(5))// TODO
        addToTheScene()
    }
        
    func show(score: Double) {
        scoreLabel.text = formatter.string(from: score as NSNumber)
        AnalyticsManager.shared.log(event: .levelScore(score))
        
        super.show()
    }
    
    func addToTheScene(){
        node.addChild(sprite)
        node.addChild(scoreLabel)
    }
}
