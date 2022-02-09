//
//  GameScene.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var lastUpdate = TimeInterval(0)
    var enemy: EnemySpawner!
    var magicGems: MagicGems!
    var spellManager: SpellManager!
    var scoreControler: ScoreController!
    var backgroundNode: Background!
    var score: Double = 0.0
    var status: GameStatus = .intro {
        didSet {
            changeStatus()
        }
    }
    var introNode: Intro!
    var gameOverNode: GameOver!
    var magicTouch: SparkTouch!
    var lineNode: Line!
    var startPoint: CGPoint?


    override func didMove(to view: SKView) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appBackFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = false
        
        //Vamos criar um padrão, essas classes que precisam dessa classe como referencia, precisam ser declaradas só uma vez
        magicTouch = SparkTouch(parent: self)
        spellManager = SpellManager(parent: self)
        scoreControler = ScoreController(parent: self)
        enemy = EnemySpawner(parent: self)
        
        //As classes visuais
        gameOverNode = GameOver(parent: self)
        introNode = Intro(parent: self)
        introNode.show()
        backgroundNode = Background(parent: self)
        lineNode = Line(parent: self)
        magicGems = MagicGems(parent: self, gemPosition: Pentagon.draw(size: 155, center: CGPoint(x: (frame.width * 4)/5, y: frame.height / 2)))
    }
    
    func changeStatus() {
        switch status{
        case .intro:
            clearScreen()
            introNode.show()
        case .playing:
            clearScreen()
            lineNode.show()
            scoreControler.show()
            backgroundNode.show()
            magicGems.show()
        case .gameOver:
            clearScreen()
            gameOverNode.show(score: score)
            scoreControler.resetScore()
            //reseta inimigos
        }
    }
    
    func clearScreen(){
        self.removeAllChildren()
    }
    
    @objc func appMovedToBackground() {
        magicTouch.clear()
    }
    
    @objc func appBackFromBackground() {
    }
    
    // Colisão com inimigo com final do jogo
    func didBegin(_ contact: SKPhysicsContact) {
        status = .gameOver
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            status = .playing
        case .playing:
            spellManager.checkSpell(touches: touches, magicGems: magicGems)
        case .gameOver:
            status = .intro
        }
        magicTouch.touchesBegan(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        spellManager.checkSpell(touches: touches, magicGems: magicGems)
        magicTouch.touchesMoved(touches: touches)
        lineNode.update(touches, spellManager: spellManager)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .playing {
            let deadGuy = enemy.castMagic(magic: spellManager.getGemArray())
            
            if let deadGuy = deadGuy {
                scoreControler.score(enemy: deadGuy)
            }
        }
        spellManager.clearSpell()
        magicTouch.clear()
        lineNode.clear()
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

