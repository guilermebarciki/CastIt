//
//  AudioManager.swift
//  CastIt
//
//  Created by Guilerme Barciki on 20/02/22.
//

import Foundation
import SpriteKit

class AudioManager {
    
    let parent: SKScene
    
    // sound assets
    let projetile = SKAction.playSoundFileNamed("projetile.mp3", waitForCompletion: false)
    let impact = SKAction.playSoundFileNamed("impact.mp3", waitForCompletion: false)
    let dying = SKAction.playSoundFileNamed("dying.mp3", waitForCompletion: false)
    init(parent: SKScene) {
        self.parent = parent
    }
    func playProjetileSound() {
        print("running fx")
        parent.run(projetile)
    }
    
    func playImpactSound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.parent.run(self.impact)
        }
    }
    func playDyingSound() {
        print("running fx")
        parent.run(dying)
    }
}
