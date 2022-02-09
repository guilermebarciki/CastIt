//
//  Line.swift
//  CastIt
//
//  Created by Paulo Tadashi Tokikawa on 08/02/22.
//

import Foundation
import SpriteKit

class Line: CustomScene {
    
    var line = SKShapeNode()
    var arrayCGPoint: [CGPoint] = []
    
    override init(parent: SKScene) {
        super.init(parent: parent)
        line.lineWidth = 10 //
        line.strokeColor = .white//
        line.alpha = 0.4
        
    }
    
    override func show(){
        node.addChild(line)
        super.show()
    }
    
    
    func update(_ touches: Set<UITouch>, spellManager: SpellManager){
        let endPoint = (touches.first!.location(in: parent))
        let path = CGMutablePath()
        if spellManager.arrayCGPoint.isEmpty {
            return
        } else {
            if node.children.isEmpty {
                node.addChild(line)
            }
            path.move(to: spellManager.getLinePoints().first!)
            arrayCGPoint = spellManager.getLinePoints()
            print(arrayCGPoint)
            for point in arrayCGPoint {
                path.addLine(to: point)
            }
            path.addLine(to: endPoint)
            line.path = path
        }
    }
    
    func clear(){
        arrayCGPoint = []
        node.removeAllChildren()
    }
}
