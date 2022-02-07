//
//  GameScene.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background = SKSpriteNode(imageNamed: "background1")
    var lastUpdate = TimeInterval(0)
    var enemy: EnemySpawner!
    var magicGems: MagicGems?
    var spellManager: SpellManager?
    var scoreControler: ScoreController!
    var score: Double = 0.0
    var status: GameStatus = .intro
    var introNode: Intro?
    var gameOverNode: GameOver?
    var magicTouch: SparkTouch?
    var line: SKShapeNode!//
    var startPoint: CGPoint?
    var arrayCGPoint: [CGPoint] = []
    
    override func didMove(to view: SKView) {
        
        
        
        magicTouch = SparkTouch(parent: self)
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = false
        setGame()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        reset()
        gameOver()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        line = SKShapeNode() //
        line.lineWidth = 10 //
        line.strokeColor = .white//
        line.alpha = 0.4
        
        addChild(line)
       print(arrayCGPoint)
        switch status {
        case .intro:
            reset()
            start()
        case .playing:
            spellManager?.checkSpell(touches: touches, magicGems: magicGems)
        case .gameOver:
            reset()
        }
        
        guard let magicTouch = magicTouch else {
            return
        }
        magicTouch.touchesBegan(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        spellManager?.checkSpell(touches: touches, magicGems: magicGems)
        guard let magicTouch = magicTouch else {
            return
        }
        magicTouch.touchesMoved(touches: touches)
        
        var endPoint = (touches.first!.location(in: self))
        var path = CGMutablePath()
        if let spellManager = spellManager {
            if spellManager.arrayCGPoint.isEmpty {
                return
            } else {
                path.move(to: spellManager.getLinePoints().first!)
                arrayCGPoint = spellManager.getLinePoints()
            for point in arrayCGPoint {
                path.addLine(to: point)
            }
            path.addLine(to: endPoint)
            line.path = path
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let spellManager = spellManager else {
            return
        }
        if status == .playing {
            let deadGuy = enemy.castMagic(magic: spellManager.getGemArray())
            
            if let deadGuy = deadGuy {
                scoreControler.score(enemy: deadGuy)
            }
        }
        spellManager.clearSpell()
        arrayCGPoint = []
        line.removeFromParent()
        guard let magicTouch = magicTouch else {
            return
        }
        magicTouch.touchesEnded(touches: touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        let deltaTime = currentTime - lastUpdate
        if status == .playing {
            guard let enemy = enemy else { return }
            scoreControler.update(dTime: deltaTime)
            enemy.update(dTime: deltaTime)
        }
        score = scoreControler.showScore() //TODO
        lastUpdate = currentTime
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}

extension GameScene {
    func reset() {
        scene?.removeAllChildren()
        if status == .playing {
            print("de playing para game over")
            status = .gameOver
        } else if status == .gameOver {
            print("de gameover para intro")
            status = .intro
        }
        setGame()
    }
    
    func start() {
        status = .playing
        setGame()
        guard let introNode = introNode as? SKNode else {
            return
        }
        introNode.removeFromParent()
        
    }
    
    func gameOver() {
        if status == .gameOver {
            return
        }
        guard let gameOverNode = gameOverNode as? SKNode else {
            return
        }
        
        addChild(gameOverNode)
        status = .gameOver
        setGame()
    }
    
    func setGame() {
        spellManager = SpellManager(parent: self)
        scoreControler = ScoreController(parent: self)
        switch status {
        case .intro:
            introNode = Intro(parent: self)
        case .playing:
            background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            background.zPosition = -3
            let sizeCoef = background.size.height / background.size.width
            background.size = CGSize(width: self.size.width, height: self.size.width * sizeCoef)
            addChild(background)
            introNode?.removeFromParent()
            enemy = EnemySpawner(parent: self)
            magicGems = MagicGems(parent: self, gemPosition: Pentagon.draw(size: 155, center: CGPoint(x: (frame.width * 4)/5, y: frame.height / 2 )) )
        case .gameOver:
            background.removeFromParent()
            gameOverNode = GameOver(parent: self, score: score )
        }
    }
}

