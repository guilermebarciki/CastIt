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
    
    override func didMove(to view: SKView) {
        
        sparkTouch.particleLifetime = 0.5
        sparkTouch.particleBirthRate = 500
        self.view?.isMultipleTouchEnabled = false
        spellManager = SpellManager(parent: self)
        
        magicGems = MagicGems(parent: self, gemPosition: Pentagon.draw(size: 100, center: CGPoint(x: (frame.width * 3)/4, y: frame.height/2)) )
        enemy = EnemySpawner(parent: self)
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
        spellManager?.checkSpell(touches: touches, magicGems: magicGems)
       
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
        
        enemy.castMagic(magic: spellManager.checkSpell(touches: touches, magicGems: magicGems))
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
        enemy.update(dTime: deltaTime)
        lastUpdate = currentTime
    }
}
