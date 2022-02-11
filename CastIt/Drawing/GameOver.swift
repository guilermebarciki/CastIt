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
    lazy var continueButton: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: "gem0")
        button.size = CGSize(width: 100, height: 100)
        button.position = CGPoint(x: parent.frame.width/2, y: parent.frame.height * 1/6)
        button.scene?.backgroundColor = .purple
        return button
    }()
    
    lazy var menuButton: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: "gem1")
        button.size = CGSize(width: 100, height: 100)
        button.position = CGPoint(x: parent.frame.width/3, y: parent.frame.height * 1/6)
        button.scene?.backgroundColor = .purple
        return button
    }()
    
    lazy var leaderBoardButton: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: "gem2")
        button.size = CGSize(width: 100, height: 100)
        button.position = CGPoint(x: parent.frame.width * 2/3, y: parent.frame.height * 1/6)
        button.scene?.backgroundColor = .purple
        return button
    }()
    private var scoreLabel: SKLabelNode
    let formatter = NumberFormatter()
    var canTryAgain: Bool = true
    
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
        node.addChild(continueButton)
        node.addChild(menuButton)
        node.addChild(leaderBoardButton)
        node.addChild(sprite)
        node.addChild(scoreLabel)
    }
    
    func didTouch(touch: CGPoint) {
        guard let parent = parent as? GameScene else {
            print("GameOver didTouch() not working")
            return
        }
        if continueButton.contains(touch) {
            if canTryAgain {
            parent.gameVC.showRewardedAD()
            }
            canTryAgain = false
        }
        
        if menuButton.contains(touch) {
            canTryAgain = true
            parent.reset()
            parent.gameVC.dismiss(animated: true, completion: nil)
        }
        
        if leaderBoardButton.contains(touch) {
            parent.magicTouch.removeSparkBug() // nao funciona
            LeaderboardManager.shared.navigateToLeaderboard(presentingVC: parent.gameVC)
        }
        
    }
}
