//
//  AudioManager.swift
//  CastIt
//
//  Created by Guilerme Barciki on 20/02/22.
//

import Foundation
import SpriteKit
import AVFAudio

class AudioManager {
    
    let parent: SKScene
    var audioPlayer: AVAudioPlayer!
    
    // soundFX assets
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
    
    func playingStatusMusic() {
        stopMusic()
        if let bundle = Bundle.main.path(forResource: "cast it - playing", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1 // for infinite times
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func gameoverStatusMusic() {
        stopMusic()
        if let bundle = Bundle.main.path(forResource: "cast it - game over", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1 // for infinite times
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func introStatusMusic() {
        stopMusic()
        if let bundle = Bundle.main.path(forResource: "cast it - intro", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1 // for infinite times
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopMusic() {
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
        }
    }
}
