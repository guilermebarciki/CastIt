//
//  GameOver.swift
//  CastIt
//
//  Created by Guilerme Barciki on 01/02/22.
//

import Foundation
import SpriteKit

class GameOver {
    let sprite = SKSpriteNode(imageNamed: "gameOverTemp")
    private var parent: SKNode
    private var scoreLabel: SKLabelNode
    private var score: Double
    let formatter = NumberFormatter()
    
    
    init(parent: SKNode, score: Double) {
        self.parent = parent
        self.score = score
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        
        scoreLabel = SKLabelNode()
        scoreLabel.zPosition = CGFloat.infinity
        scoreLabel.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height * 2/3)
        scoreLabel.text = formatter.string(from: score as NSNumber)
        scoreLabel.fontSize = CGFloat(36)
        sprite.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height/2)
        sprite.setScale(CGFloat(5))// TODO
        addToTheScene()
        }
        
    
    
    func configureSprites(sprite: SKSpriteNode) {
        sprite.size = CGSize(width: 70, height: 70)
    }
    func addToTheScene(){
        parent.addChild(sprite)
        print("adicionando scorelavel \(scoreLabel.text)")
        parent.addChild(scoreLabel)
    }
}
