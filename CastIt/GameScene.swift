//
//  GameScene.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var lastUpdate = TimeInterval(0)
    var enemy:EnemySpawner!
    var magicGems: MagicGems?
    var spellManager: SpellManager?
    private var sparkTouch: SKEmitterNode = SKEmitterNode(fileNamed: "sparkTouch")!
    private var currentEmiter: SKEmitterNode?
    var status: GameStatus = .gameOver
    var introNode: Intro?
    var gameOverNode: GameOver?
    
    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = false
        setGame()
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        currentEmiter = sparkTouch.copy() as? SKEmitterNode
        guard let currentEmiter = currentEmiter else {
            return
        }

        currentEmiter.position = pos
        currentEmiter.targetNode = scene

        addChild(currentEmiter)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        currentEmiter?.position = pos

    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let currentEmiter = currentEmiter {

            currentEmiter.targetNode = nil
            currentEmiter.run(SKAction.sequence([ SKAction.fadeOut(withDuration: 0.5),
                                                     SKAction.removeFromParent()]))


                print("remove")

        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            reset()
            start()
        case .playing:
            spellManager?.checkSpell(touches: touches, magicGems: magicGems)
        case .gameOver:
            reset()
            
        }
        
        
       
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches.first
        spellManager?.checkSpell(touches: touches, magicGems: magicGems)

        
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let spellManager = spellManager else {
            return
        }
        if status == .playing {
            enemy.castMagic(magic: spellManager.checkSpell(touches: touches, magicGems: magicGems))
        }
        
        print(spellManager.checkSpell(touches: touches, magicGems: magicGems))
        spellManager.clearSpell()
        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        let deltaTime = currentTime - lastUpdate
        
        if status == .playing {
            
            guard let enemy = enemy else { return }
            enemy.update(dTime: deltaTime)
        }
        
        lastUpdate = currentTime
    }
    
    func reset() {
        scene?.removeAllChildren()
        status = .intro
        setGame()
        guard let introNode = introNode as? SKNode else {
            return
        }
        addChild(introNode)
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
    }
    
    func setGame() {
        sparkTouch.particleLifetime = 0.5
        sparkTouch.particleBirthRate = 500
        spellManager = SpellManager(parent: self)
        
        
        switch status {
        case .intro:
            introNode = Intro(parent: self)
        case .playing:
            introNode?.removeFromParent()
            enemy = EnemySpawner(parent: self)
            magicGems = MagicGems(parent: self, gemPosition: Pentagon.draw(size: 130, center: CGPoint(x: (frame.width * 4)/5, y: frame.height * 3/5 )) )
        case .gameOver:
            gameOverNode = GameOver(parent: self)
        }
    }
}



enum GameStatus {
    case intro
    case playing
    case gameOver
}
