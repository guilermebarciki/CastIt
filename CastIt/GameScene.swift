//
//  GameScene.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var currentPlayTime = TimeInterval(0)
    var castMisses = 0
    
    var lastUpdate = TimeInterval(0)
    var dTime = TimeInterval(0)
    
    weak var gameVC: GameViewController!
    
    var playTimeForAD = TimeInterval(0)
    let timeForAD = TimeInterval(60)
    
    var score: Double = 0.0
    
    var status: GameStatus = .intro {
        didSet {
            changeStatus()
        }
    }
    //Controller Nodes
    var enemy: EnemySpawner!
    var spellManager: SpellManager!
    var scoreControler: ScoreController!
    
    
    //Drawing Nodes
    var backgroundNode: Background!
    var magicGems: MagicGems!
    var introNode: Intro!
    var gameOverNode: GameOver!
    var magicTouch: SparkTouch!
    var lineNode: Line!
//    var startPoint: CGPoint?


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
            AnalyticsManager.shared.log(event: .levelStart)
            lineNode.show()
            scoreControler.show()
            backgroundNode.show()
            magicGems.show()
//            gameVC.showRewardedAD()
        case .gameOver:
            clearScreen()
            AnalyticsManager.shared.log(event: .levelEnd)
            AnalyticsManager.shared.log(event: .levelScore(score))
            AnalyticsManager.shared.log(event: .levelCastMisses(castMisses))
            AnalyticsManager.shared.log(event: .levelScorePerSecond(score/currentPlayTime))
            AnalyticsManager.shared.log(event: .levelTime(currentPlayTime))
            reset()
            gameOverNode.show(score: score)
            if playTimeForAD >= timeForAD {
                gameVC.showInterstitialAD()
                playTimeForAD = 0
            }
            LeaderboardManager.shared.updateScore(with: Int(score * 10)) //TODO fix * 10
        }
    }
    
    func reset(){
        scoreControler.resetScore()
        enemy.reset()
        currentPlayTime = 0
        castMisses = 0
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
            spellManager.checkSpell(touches: touches, magicGems: magicGems, dTime: dTime)
        case .gameOver:
            status = .intro
        }
        magicTouch.touchesBegan(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        spellManager.checkSpell(touches: touches, magicGems: magicGems, dTime: dTime)
        magicTouch.touchesMoved(touches: touches)
        lineNode.update(touches, spellManager: spellManager)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .playing {
            let deadGuy = enemy.castMagic(magic: spellManager.getGemArray())
            
            if let deadGuy = deadGuy {
                scoreControler.score(enemy: deadGuy)
                AnalyticsManager.shared.log(event: .castTimePerEnemy(spellManager.castingTime))
            }
            else {
                castMisses += 1
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
        dTime = currentTime - lastUpdate
        
        if status == .playing {
            currentPlayTime += dTime
            scoreControler.update(dTime: dTime)
            enemy.update(dTime: dTime)
            playTimeForAD += dTime
            print(playTimeForAD)
        }
        score = scoreControler.showScore() //TODO
        lastUpdate = currentTime
    }
    
    func getReward(){
        
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}

