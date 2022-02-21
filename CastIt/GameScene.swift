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
    let timeForAD = TimeInterval(0)
    var score: Double = 0.0
    var canContinue = true
    var isGamePaused = false
    var deviceType: DeviceType = .iPad
    var status: GameStatus = .intro {
        didSet {
            changeStatus()
        }
    }

    //Controller Nodes
    var enemy: EnemySpawner!
    var spellManager: SpellManager!
    var scoreControler: ScoreController!
    public var audioManager: AudioManager!
    
    //Drawing Nodes
    var backgroundNode: Background!
    var magicGems: MagicGems!
    var introNode: Intro!
    
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
        audioManager = AudioManager(parent: self)
        magicTouch = SparkTouch(parent: self)
        spellManager = SpellManager(parent: self)
        scoreControler = ScoreController(parent: self)
        enemy = EnemySpawner(parent: self, gameScene: self)
        
        //As classes visuais
        
        introNode = Intro(parent: self)
//        introNode.show()
        backgroundNode = Background(parent: self)
        lineNode = Line(parent: self)
        magicGems = MagicGems(parent: self, gemPosition: Pentagon.draw(size: 155, center: CGPoint(x: (frame.width * 4)/5, y: frame.height / 2)))
        status = .intro
    }
    
    func changeStatus() {
        switch status{
        case .intro:
            unpauseGame()
            clearScreen()
            backgroundNode.show()
            magicGems.show()
            introNode.show()
            
        case .playing:
            lineNode.clear() // IMPEDE DE CRASHAR
            clearScreen()
            gameVC.showPauseButton()
            AnalyticsManager.shared.log(event: .levelStart)
            lineNode.show()
            scoreControler.show()
            backgroundNode.show()
            magicGems.show()
//            gameVC.showRewardedAD()
        
        case .wantContinue:
            gameVC.removePauseButton()
            if playTimeForAD >= timeForAD {
                gameVC.showInterstitialAD()
                playTimeForAD = 0
            }
            gameVC.addContinueScroll()
        
        case .gameOver:
            scoreControler.updateScore()
            gameVC.addGameOverScroll()
            //clearScreen()
            AnalyticsManager.shared.log(event: .levelEnd)
            AnalyticsManager.shared.log(event: .levelScore(score))
            AnalyticsManager.shared.log(event: .levelCastMisses(castMisses))
            AnalyticsManager.shared.log(event: .levelScorePerSecond(score/currentPlayTime))
            AnalyticsManager.shared.log(event: .levelTime(currentPlayTime))
            //reset()
            
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
        canContinue = true
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
        
        if status == .playing && canContinue {
            status = .wantContinue
        }
        if status == .playing && !canContinue {
            gameVC.removeContinueScroll()
            status = .gameOver
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self) else { return }
        
        switch status {
        case .intro:
            status = .playing
            magicTouch.touchesBegan(touches: touches)
        case .playing:
            spellManager.checkSpell(touches: touches, magicGems: magicGems, dTime: dTime)
            magicTouch.touchesBegan(touches: touches)
        case .wantContinue:
            break
        case .gameOver:
            magicTouch.touchesBegan(touches: touches)
            
        }
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
        lastUpdate = currentTime
        print("game is paused? \(currentTime) \(self.isPaused)")
        if (status == .playing && isGamePaused == false) {
            print("rolando \(lastUpdate)")
            currentPlayTime += dTime
            scoreControler.update(dTime: dTime)
            enemy.update(dTime: dTime)
            playTimeForAD += dTime
            print(playTimeForAD)
        }
        score = scoreControler.showScore() //TODO
        
        print("current time \(currentTime)")
        
    }
    
    func getReward(){
        print(" teste ** reward")
        if status == .wantContinue && canContinue {
            gameVC.removeContinueScroll()
            canContinue = false
            status = .playing
            print("** playing game")
            pauseGame()
        } 
    }
    
    func pauseGame() {
        print("** game paused")
        isGamePaused = true
    }
    
    func unpauseGame() {
        print("** game unpaused")
        isGamePaused = false
    }
    
}

enum GameStatus {
    case intro
    case playing
    case wantContinue
    case gameOver
}

enum DeviceType {
    case iPad
    case Iphone
}

