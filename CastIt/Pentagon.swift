//
//  Pentagon.swift
//  Enemy Spawn
//
//  Created by Paulo Tadashi Tokikawa on 28/01/22.
//

import Foundation
import SpriteKit

class Pentagon {
    static func draw(size: Double, center: CGPoint) -> [CGPoint]{
        var star:[CGPoint] = []
        for i in 0...4{
            let cons = 2 * Double.pi * Double(i) / 5 + Double.pi/2
            let calcCos = cos(cons)
            let calcSin = sin(cons)
            let x = size * calcCos + center.x
            let y = size * calcSin + center.y
            star.append(CGPoint(x: x, y: y))
        }
        return star
    }
}
