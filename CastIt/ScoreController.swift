//
//  ScoreController.swift
//  CastIt
//
//  Created by Paulo Tadashi Tokikawa on 01/02/22.
//

import Foundation
import SpriteKit



class ScoreController {
    var scoreLabel:SKLabelNode
    
    var nextScore:TimeInterval = 0
    let scoreRate:TimeInterval = 1
    
    let formatter = NumberFormatter()
    
    private var parent: SKNode
    
    var scoreNumber:Double = 0
    
    var multiplier:Double = 1
    var multiplierBalancer = Balancer(start: 1, range: 5, time: 1200, ascending: true, startFast: true)
    
    
    init(parent: SKNode){
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        self.parent = parent
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: parent.frame.width * 3 / 4, y: parent.frame.height * 4 / 5)
        scoreLabel.zPosition = CGFloat.infinity
        parent.addChild(scoreLabel)
    }
    
    func update(dTime: TimeInterval){
        if nextScore <= 0{
            multiplier = multiplierBalancer.nextStep()
            nextScore = scoreRate
        }
        nextScore -= dTime
        
        scoreNumber += dTime * multiplier
        
        updateScore()
    }
    
    let base:Double = 10
    func score(enemy: Enemy){
        var score:Double = 0
        
        if enemy.deathArray.count == 2{
            score = 2 * base
        }
        else if enemy.deathArray.count == 3{
            score = 3 * base
        }
        else if enemy.deathArray.count == 4{
            score = 4 * base
        }
        else {
            score = 5 * base
        }
        
        if enemy.level == 0 {
            score += 1 * base
        }
        else if enemy.level == 1 {
            score += 5 * base
        }
        else {
            score += 10 * base
        }
        
        scoreNumber += score
        updateScore()
    }
    func updateScore(){
        
        scoreLabel.text = formatter.string(from: scoreNumber as NSNumber)
    }
}
