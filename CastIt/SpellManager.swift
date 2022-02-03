//
//  SpellManager.swift
//  CastIt
//
//  Created by Guilerme Barciki on 31/01/22.
//

import Foundation
import SpriteKit

class SpellManager {
    private var gemArray: [Int] = []
    private let parent: SKNode
    var magicLine = SKShapeNode()
    var startPoint: CGPoint?
    var arrayCGPoint: [CGPoint] = []
    
    
    init(parent: SKNode){
        self.parent = parent
    }
    
    func checkSpell(touches: Set<UITouch>, magicGems: MagicGems?){
        
        guard let touch = touches.first else {
            return
        }
        
        guard let magicGems = magicGems else {
            return
            
        }
        
        
        
        for i in 0..<magicGems.gemsSprites.count {
            let gem = magicGems.gemsSprites[i]
            
            
            if gem.contains(touch.location(in: parent)) {
                
               
                if !(gemArray.contains(i) ) {
                    arrayCGPoint.append(gem.position)
                    gemArray.append(i)
                }
            }
        }
        
        
    }
    
    func clearSpell() {
        gemArray = []
        arrayCGPoint = []
    }
    
    func getGemArray() -> [Int] {
        print(gemArray)
        return gemArray
    }
    
    func getLinePoints() -> [CGPoint] {
        return arrayCGPoint
    }
}

