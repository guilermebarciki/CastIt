//
//  SparkTouch.swift
//  CastIt
//
//  Created by Guilerme Barciki on 03/02/22.
//

import Foundation
import SpriteKit

class SparkTouch {
    
    private var sparkTouch: SKEmitterNode = SKEmitterNode(fileNamed: "sparkTouch")!
    private var currentEmiter: SKEmitterNode?
    private var parent: SKNode
    
    init(parent: SKNode){
        sparkTouch.particleLifetime = 0.5
        sparkTouch.particleBirthRate = 500
        self.parent = parent
    }
    
    private func touchDown(atPoint pos : CGPoint) {
        currentEmiter = sparkTouch.copy() as? SKEmitterNode
        guard let currentEmiter = currentEmiter else {
            return
        }
        
        currentEmiter.position = pos
        currentEmiter.targetNode = parent.scene
        
        parent.addChild(currentEmiter)
    }
    
    private func touchMoved(toPoint pos : CGPoint) {
        currentEmiter?.position = pos
        
    }
//    private func touchUp(atPoint pos : CGPoint) {
//    }
    
    func clear(){
        if let currentEmiter = currentEmiter {
            currentEmiter.targetNode = nil
            currentEmiter.run(SKAction.sequence([ SKAction.fadeOut(withDuration: 0.5),
                                                  SKAction.removeFromParent()]))
        }
    }
    
    func touchesMoved( touches: Set<UITouch>) {
        for t in touches { self.touchMoved(toPoint: t.location(in: parent)) }
    }
    
    func touchesBegan( touches: Set<UITouch>) {
        for t in touches { self.touchDown(atPoint: t.location(in: parent)) }
    }
//    func touchesEnded( touches: Set<UITouch>) {
//        for t in touches { self.touchUp(atPoint: t.location(in: parent)) }
//    }
}
