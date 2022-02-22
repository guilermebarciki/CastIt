//
//  EnemyController.swift
//  Enemy Spawn
//
//  Created by Paulo Tadashi Tokikawa on 27/01/22.
//

import Foundation
import SpriteKit

class EnemySpawner {
    var projetile = SKSpriteNode(imageNamed: "1_0")
    let enemiesSprites:[SKSpriteNode] = [
        SKSpriteNode(imageNamed: "normal1"),
        SKSpriteNode(imageNamed: "elite1.png"),
        SKSpriteNode(imageNamed: "4boss1.png")
    ]
    var bossTextures: [SKTexture] = []
    var eliteTextures: [SKTexture] = []
    var normalTextures: [SKTexture] = []
    
   
    private var parent: SKNode
    private var gameScene: GameScene
    
    var nextEnemy:TimeInterval     = 0
    
    var nextDificulty:TimeInterval = 1
    let dificultyRate:TimeInterval = 1
    
    
    var spawnRate:TimeInterval     = 2
    var spawnBalancer  = Balancer(start: 2, range: 1, time: 1200, ascending: false, startFast: true)
    
    var normalPercentage:Double = 70
    var elitePercentage:Double = 20
    var bossPercentage:Double = 10
    var normalBalancer = Balancer(start: 70, range: 30, time: 1200, ascending: false, startFast: true)
    var eliteBalancer  = Balancer(start: 20, range: 10, time: 1200, ascending: true, startFast: true)
    var bossBalancer   = Balancer(start: 10, range: 20, time: 1200, ascending: true, startFast: true)

    
    var twoPercentage:Double = 90
    var threePercentage:Double = 5
    var fourPercentage:Double = 3
    var fivePercentage:Double = 2
    var twoBalancer    = Balancer(start: 60, range: 50, time: 1200, ascending: false, startFast: true)
    var threeBalancer  = Balancer(start: 20, range: 10, time: 1200, ascending: true, startFast: true)
    var fourBalancer   = Balancer(start: 10, range: 10, time: 1200, ascending: true, startFast: true)
    var fiveBalancer   = Balancer(start: 10, range: 30, time: 1200, ascending: true, startFast: true)
    
    let lanes = 4
    var lanePos:[CGPoint] = []
    var cLane:[Bool] = [false,false,false,false]
    
    var pos = CGPoint(x: 0, y: 0)
    var zPos:CGFloat = 0
    
    var enemySpawned:[Enemy] = []
    
    init (parent: SKNode, gameScene: GameScene) {
        // setting monsters textures
        for i in 1...8 {
            bossTextures.append(SKTexture(imageNamed: "4boss\(i).png"))
        }
        for i in 1...8 {
            eliteTextures.append(SKTexture(imageNamed: "elite\(i).png"))
        }
        for i in 1...8 {
            normalTextures.append(SKTexture(imageNamed: "normal\(i).png"))
        }
        //
        self.parent = parent
        self.gameScene = gameScene
        for i in 0..<lanes{
            let yPos = (parent.frame.height/CGFloat(lanes+3) * CGFloat(i)) + 150
            
            lanePos.append(CGPoint(x: -33, y: yPos))// x=-33
        }
    }
    
    func update(dTime: TimeInterval){
        nextEnemy -= dTime
        nextDificulty -= dTime
        if nextDificulty <= 0 {
            raiseDificulty()
            nextDificulty = dificultyRate
            print(nextDificulty)
        }
        if nextEnemy <= 0{
            nextEnemy = spawnRate
            let randomEnemy = Double.random(in: 0...100)
            var new:SKSpriteNode
            var level:Int
            var speed:Double
            if randomEnemy < normalPercentage {
                new = enemiesSprites[0].copy() as! SKSpriteNode
                level = 0
                speed = 100
            }
            else if randomEnemy < elitePercentage+normalPercentage {
                new = enemiesSprites[1].copy() as! SKSpriteNode
                level = 1
                speed = 50
            }
            else {
                new = enemiesSprites[2].copy() as! SKSpriteNode
                level = 2
                speed = 30
            }
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
//            new.zPosition = zPos
            speed += Double.random(in: -5...5)
            print("Speed: \(speed)")
            enemySpawned.append(Enemy(sprite: new, lane: randomLane, level: level, speed: speed, controller: self))
            zPos += 1
            parent.addChild(new)
            setBoosAnimation(sprite:new, level: level)
        }
        if !enemySpawned.isEmpty {
            for enemy in enemySpawned {
                enemy.sprite.position.x += dTime * enemy.speed
            }
        }
    }
    
    func reset(){
        spawnBalancer.reset()
        normalBalancer.reset()
        eliteBalancer.reset()
        bossBalancer.reset()
        twoBalancer.reset()
        threeBalancer.reset()
        fourBalancer.reset()
        fiveBalancer.reset()
        
        normalPercentage = 90
        elitePercentage = 8
        bossPercentage = 2
        twoPercentage = 90
        threePercentage = 5
        fourPercentage = 3
        fivePercentage = 2
        
        nextEnemy = 0
        
        nextDificulty = 1
        
        spawnRate = 2
        zPos = 0
        for spawn in enemySpawned {
            spawn.sprite.removeFromParent()
        }
        enemySpawned.removeAll()
    }
    
    func raiseDificulty(){
        spawnRate        = spawnBalancer.nextStep()
        normalPercentage = normalBalancer.nextStep()
        elitePercentage  = eliteBalancer.nextStep()
        bossPercentage   = bossBalancer.nextStep()
        twoPercentage    = twoBalancer.nextStep()
        threePercentage  = threeBalancer.nextStep()
        fourPercentage   = fourBalancer.nextStep()
        fivePercentage   = fiveBalancer.nextStep()
    }
    
    func castMagic(magic: [Int]) -> Enemy?{
        var deadGuy: Enemy?
        var deadGuyIndex:Int?
        for (index, enemy) in enemySpawned.enumerated() {
            if enemy.deathArray == magic || enemy.deathArray == magic.reversed()
            {
                gameScene.audioManager.playProjetileSound()
                gameScene.audioManager.playImpactSound()
                
                if let dGuy = deadGuy {
                    if dGuy.sprite.position.x < enemy.sprite.position.x {
                        deadGuy = enemy
                        deadGuyIndex = index
                    }
                }
                else {
                    projetile.size = CGSize(width: 200, height: 200)
                    projetile.zRotation = .pi
                    var tempProjetile = projetile.copy() as? SKSpriteNode
                    tempProjetile?.zPosition = 0
                    tempProjetile?.position = CGPoint(x: (parent.scene!.frame.width * 4)/5, y: parent.scene!.frame.height / 2)
                    tempProjetile?.anchorPoint = CGPoint(x: 0, y: 0.5)
                    
                    
                    parent.addChild(tempProjetile as! SKNode)
                    let moveAction = SKAction.move(to: CGPoint(x: enemy.sprite.position.x, y: enemy.sprite.position.y), duration: 0.3)
                    tempProjetile?.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                    
                    deadGuy = enemy
                    deadGuyIndex = index
                }
            }
        }
        if deadGuy != nil {
            if let dGuyIndex = deadGuyIndex {
                if enemySpawned[dGuyIndex].level>0{
                    enemySpawned[dGuyIndex].newDeathArray()
                    enemySpawned[dGuyIndex].level -= 1
                    return nil
                }
                else{
                    kill(enemyInxex: dGuyIndex)
                    return deadGuy
                }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let e = self.enemySpawned.remove(at: enemyInxex)
            self.gameScene.audioManager.playDyingSound()
            e.sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0), SKAction.removeFromParent()]))
        }
    }
    
    func setBoosAnimation(sprite: SKSpriteNode, level: Int) {
        var animation = SKAction()
       //TODO SWITCH CASE
        if level == 0{
            animation = SKAction.animate(with: normalTextures, timePerFrame: 0.3)
            
            sprite.run(SKAction.repeatForever(animation))
        }
        if level == 1{
            animation = SKAction.animate(with: eliteTextures, timePerFrame: 0.3)
            
            sprite.run(SKAction.repeatForever(animation))
        }
        if level == 2{
            animation = SKAction.animate(with: bossTextures, timePerFrame: 0.3)
            
            sprite.run(SKAction.repeatForever(animation))
        }
    }
}

class Enemy {
    let sprite:SKNode
    var pentagonNode:SKNode = SKNode()
    var pentagonArray:[CGPoint] = []
    var deathArray:[Int] = []
    let lane:Int
    var level:Int
    let speed:Double
    let controller:EnemySpawner
    let size:Double = 20
    
    init(sprite: SKNode, lane: Int, level: Int, speed:Double, controller:EnemySpawner){
        self.sprite = sprite
        self.lane = lane
        self.level = level
        self.speed = speed
        self.controller = controller
        
        self.sprite.zPosition = controller.zPos + CGFloat(abs(lane - 3) * 1000)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.contactTestBitMask = 2
        sprite.physicsBody?.affectedByGravity = false
        setupDeathArray()
        drawPentagon()
        newDeathArray()
        sprite.addChild(pentagonNode)
    }
    
    func newDeathArray(){
        deathArray.removeAll()
        setupDeathArray()
        if let child = pentagonNode.childNode(withName: "trace"){
            child.removeFromParent()
        }
        drawArray()
    }
    
    private func setupDeathArray(){
        var points:Int
        let randomPoint = Double.random(in: 0...100)
        if randomPoint < controller.twoPercentage {
            points = 2
        }
        else if randomPoint < controller.twoPercentage + controller.threePercentage {
            points = 3
        }
        else if randomPoint < controller.twoPercentage + controller.threePercentage + controller.fourPercentage{
            points = 4
        }
        else {
            points = 5
        }
        
        if level == 0 {
            if points > 2 {
                points -= 1
            }
        }
        else if level == 1 {
            if points < 5 {
                points += 1
            }
        }
        else if level == 2 {
            if points < 4 {
                points += 2
            }
        }
        
        while deathArray.count < points {
            let point = Int.random(in: 0...4)
            if !deathArray.contains(point) {
                deathArray.append(point)
            }
        }
    }
    
    private func drawArray(){
        let path = UIBezierPath()
        path.move(to: pentagonArray[deathArray[0]])
        for i in 1..<deathArray.count{
            path.addLine(to: pentagonArray[deathArray[i]])
        }
        let line = SKShapeNode(path: path.cgPath)
        line.strokeColor = .white
        line.lineWidth = size/5
        line.lineJoin = .round
        line.lineCap = .round
        line.name = "trace"
        line.zPosition = sprite.zPosition + 3
        pentagonNode.addChild(line)
    }
    
    
    private func drawPentagon(){
        pentagonArray = Pentagon.draw(size: size, center: CGPoint(x: 0, y: 100))
        
        for point in pentagonArray{
            let child = SKShapeNode(circleOfRadius: size/5)
            child.position = point
            child.fillColor = .red
            child.strokeColor = .red
            child.zPosition = sprite.zPosition + 2
            pentagonNode.addChild(child)
        }
        let bg = SKShapeNode(circleOfRadius: size * 1.5)
        bg.position = pentagonNode.position
        bg.position.y += 100
    
        bg.fillColor = .black
        bg.strokeColor = .black
        bg.alpha = 0.5
        bg.zPosition = sprite.zPosition + 1
        pentagonNode.addChild(bg)
        
    }
    
}

