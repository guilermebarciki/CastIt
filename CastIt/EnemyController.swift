//
//  EnemyController.swift
//  Enemy Spawn
//
//  Created by Paulo Tadashi Tokikawa on 27/01/22.
//

import Foundation
import SpriteKit

class EnemySpawner {
    let enemiesSprites:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "normal.png"),
        SKSpriteNode(imageNamed: "elite.png"),
        SKSpriteNode(imageNamed: "boss.png")
    ]
    private var parent: SKNode
    
    var nextEnemy:TimeInterval     = 0
    let spawnRate:TimeInterval     = 3
    
    var dificulty:Double           = 1
    let dificultySum:Double        = 0.1
    let dificultyRate:TimeInterval = 15
    
    let lanes = 4
    var lanePos:[CGPoint] = []
    var cLane:[Bool] = [false,false,false,false]
    
    var pos = CGPoint(x: 0, y: 0)
    var zPos:CGFloat = 0
    
    var enemySpawned:[Enemy] = []
    
    init (parent: SKNode) {
        self.parent = parent
        for i in 0..<lanes{
            let yPos = (parent.frame.height/CGFloat(lanes+3) * CGFloat(i)) + 150
            
            lanePos.append(CGPoint(x: 100, y: yPos))// x=-33
        }
    }
    
    func update(dTime: TimeInterval){
        nextEnemy -= dTime
        if nextEnemy <= 0{
            nextEnemy = spawnRate
            let randomEnemy = Int.random(in: 0..<enemiesSprites.count)
            let new = enemiesSprites[randomEnemy].copy() as! SKNode
            var randomLane = Int.random(in: 0..<lanes)
            while cLane[randomLane] {
                randomLane = Int.random(in: 0..<lanes)
            }
            for i in 0..<cLane.count {
                if i == randomLane{
                    cLane[i] = true
                }
                else{
                    cLane[i] = false
                }
            }
            new.position = lanePos[randomLane]
            new.zPosition = zPos
            enemySpawned.append(Enemy(sprite: new, lane: randomLane, level: randomEnemy, speed: 50))
            zPos += 1
            parent.addChild(new)
        }
        if !enemySpawned.isEmpty {
            for enemy in enemySpawned {
                enemy.sprite.position.x += dTime * enemy.speed
            }
        }
    }
    
    func castMagic(magic: [Int]) -> Enemy?{
        var deadGuy: Enemy?
        var deadGuyIndex:Int?
        for (index, enemy) in enemySpawned.enumerated() {
            if enemy.deathArray == magic {
                if let dGuy = deadGuy {
                    if dGuy.sprite.position.x < enemy.sprite.position.x{
                        deadGuy = enemy
                        deadGuyIndex = index
                    }
                }
                else {
                    deadGuy = enemy
                    deadGuyIndex = index
                }
            }
        }
        if deadGuy != nil {
            if let dGuyIndex = deadGuyIndex {
                kill(enemyInxex: dGuyIndex)
                return deadGuy
            }
            else{
                fatalError()
            }
        }
        else{
            return nil
            
        }
    }
    
    func kill(enemyInxex: Int){
        let e = enemySpawned.remove(at: enemyInxex)
        e.sprite.removeFromParent()
    }
}

class Enemy {
    let sprite:SKNode
    var pentagonNode:SKNode = SKNode()
    var pentagonArray:[CGPoint] = []
    var deathArray:[Int] = []
    let lane:Int
    let level:Int
    let speed:Double
    
    init(sprite: SKNode, lane: Int, level: Int, speed:Double){
        self.sprite = sprite
        self.lane = lane
        self.level = level
        self.speed = speed
        setupDeathArray()
        drawPentagon()
        sprite.addChild(pentagonNode)
    }
    
    private func setupDeathArray(){
        let points = Int.random(in: 2...5)
        
        while deathArray.count < points {
            let point = Int.random(in: 0...4)
            if !deathArray.contains(point) {
                deathArray.append(point)
            }
        }
        

    }
    
    private func drawPentagon(){
        pentagonArray = Pentagon.draw(size: 50, center: CGPoint(x: 0, y: 120))
        
        for point in pentagonArray{
            let child = SKShapeNode(circleOfRadius: 10)
            child.position = point
            child.fillColor = .red
            child.zPosition = sprite.zPosition + 1
            pentagonNode.addChild(child)
        }
        
        
        let path = UIBezierPath()
        path.move(to: pentagonArray[deathArray[0]])
        for i in 1..<deathArray.count{
            path.addLine(to: pentagonArray[deathArray[i]])
        }
        let line = SKShapeNode(path: path.cgPath)
        line.strokeColor = .white
        line.lineWidth = 10
        line.lineJoin = .round
        line.lineCap = .round
        
        line.zPosition = sprite.zPosition + 2
        pentagonNode.addChild(line)
    }
    
}

