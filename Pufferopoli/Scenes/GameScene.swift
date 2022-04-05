//
//  GameScene.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 21/03/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Enemy: UInt32 = 0b1 // 1
    static let Ally: UInt32 = 0b10 // 2
    static let Bullet: UInt32 = 0b100 // 3
    static let Wall: UInt32 = 0b1000 // 4
    static let Dog: UInt32 = 0b10000 // 8
    static let Carrot: UInt32 = 0b100000 // 16
}

let randomNumber = arc4random_uniform(2)
let x: CGFloat = randomNumber == 0 ? 1 : -1

class GameScene: SKScene, SKPhysicsContactDelegate {
    var sceneManagerDelegate: SceneManagerDelegate?
    var gameScore = 0 {
        didSet{
            scoreLabel.text = "SCORE: \(gameScore)"
        }
    }
    var worldNode = SKNode()
    var puffer = Puffer()
    var scoreLabel: SKLabelNode!
    var mod = 1500
    var carrotSpawned = false
    var controlling = false
    var carrotTaken = false
    var nodePosition = CGPoint()
    var startTouch = CGPoint()
    var enemies:[SKSpriteNode] = []
    var newEnemy = SKSpriteNode()
    var newEnemy2 = SKSpriteNode()
    var newEnemy3 = SKSpriteNode()
    var pufferState : Int = 0
    let background = SKSpriteNode(imageNamed: "Background")
    let banner = SKSpriteNode(imageNamed: "Banner")
    let carrot = SKSpriteNode(imageNamed: "Carrot")
    let blackBox = SKSpriteNode(imageNamed: "BlackBox")
    let noHit = SKTexture(imageNamed: "Puffer")
    let oneHit = SKTexture(imageNamed: "PufferBig")
    let twoHit = SKTexture(imageNamed: "PufferBigger")
    let enemyPositions: [CGPoint] = [CGPoint(x:-160, y:288),CGPoint(x:160, y:288),CGPoint(x:160, y:-288),CGPoint(x:-160, y:-288)]
    let smallEnemyPositions: [CGPoint] = [CGPoint(x:0, y:288),CGPoint(x:0, y:-288),CGPoint(x:180, y:0),CGPoint(x:-180, y:0)]
    let thirdEnemyPositions: [CGPoint] = [CGPoint(x: -140, y:330),CGPoint(x:140, y:300),CGPoint(x:-140, y:-330),CGPoint(x:140, y:300)]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlling = true
        let touch = touches.first
        if let location = touch?.location(in: self){
            startTouch = location
            nodePosition = puffer.position
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if controlling {
            let touch = touches.first
            if let location = touch?.location(in: self){
                puffer.run(SKAction.move(to: CGPoint(x:  nodePosition.x + location.x - startTouch.x, y: nodePosition.y + location.y - startTouch.y), duration: 0.1))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlling = false
    }
    
    func gameOver(){
        SKTAudio.sharedInstance().playSoundEffect("Hit3.mp3")
        SKTAudio.sharedInstance().backgroundMusicPlayer?.stop()
        worldNode.isPaused = true
        controlling = false
        userScore = gameScore
        blackBox.run(SKAction.fadeAlpha(to: 1.0, duration: 1.0))
        let gameScene = GameOver(fileNamed: "GameOver")
        print("moving to gameplay")
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    func spawnCarrot(){
        if !carrotSpawned{
            carrot.isHidden = false
            SKTAudio.sharedInstance().playSoundEffect("CarrotSpawn.mp3")
            carrot.run(SKAction.sequence([(SKAction.run{self.carrotSpawned = true}), (SKAction.wait(forDuration: 4.5)), (SKAction.run{
                if !self.carrotTaken{
                    self.carrot.isHidden = true}
            }),
                                          SKAction.run{self.carrotSpawned = false}])) //Carrot spawns, waits for 5 secs then bye bye and gets ready to spawn again
        }
    }
    
    func carrotTime(){
        carrot.isHidden = true
        carrotTaken = true
        SKTAudio.sharedInstance().playSoundEffect("Carrot.mp3")
        let puffAlpha = SKAction.fadeAlpha(to: 0.5, duration: 0.50)
        let wait = SKAction.wait(forDuration: 0.25)
        let puffAlpha2 = SKAction.fadeAlpha(to: 1.0, duration: 0.50)
        puffer.damageable = false
        if pufferState == 0 {
            puffer.createAnimation()
            puffer.run(puffer.idleAnimation)
            puffer.setScale(0.25)
            puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.run{self.puffer.damageable = true}, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
            carrotSpawned = false
        }
        
        if pufferState > 0 {
            pufferState -= 1
            if pufferState == 0 {
                puffer.createAnimation()
                puffer.run(puffer.idleAnimation)
                puffer.setScale(0.25)
                puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.run{self.puffer.damageable = true}, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
                carrotSpawned = false
            }
            if pufferState == 1 {
                puffer.createFutwoAnimation()
                puffer.run(puffer.futwoAction)
                puffer.setScale(0.65)
                puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.run{self.puffer.damageable = true}, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
                carrotSpawned = false
            }
            else if pufferState == 2 {
                puffer.createFatguAnimation()
                puffer.run(puffer.fatguAction)
                puffer.setScale(0.80)
                puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.run{self.puffer.damageable = true}, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
                carrotSpawned = false
            }
            else if pufferState == 3 {
                gameOver()
            }
            
        }
    }
    
    func bulletHit(){
        print("hit by bubble")
        pufferState += 1
        puffer.damageable = false
        let puffAlpha = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.2)
        let puffAlpha2 = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait, SKAction.run{self.puffer.damageable = true}]))
        if pufferState == 1 {
            SKTAudio.sharedInstance().playSoundEffect("Hit1.mp3")
            puffer.createFutwoAnimation()
            puffer.run(puffer.futwoAction)
            puffer.setScale(0.60)
        }
        
        else if pufferState == 2 {
            SKTAudio.sharedInstance().playSoundEffect("Hit2.mp3")
            puffer.createFatguAnimation()
            puffer.run(puffer.fatguAction)
            puffer.setScale(0.80)
        }
        
        else if pufferState == 3 {
            gameOver()
        }
    }
    
    func enemyHit(){
        print("touched enemy")
        pufferState = 3
        if pufferState == 1 {
            puffer.createFutwoAnimation()
            puffer.run(puffer.futwoAction)
            puffer.setScale(0.65)
        }
        else if pufferState == 2 {
            puffer.createFatguAnimation()
            puffer.run(puffer.fatguAction)
            puffer.setScale(0.80)
        }
        else if pufferState == 3 {
            gameOver()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        //        let contactPoint = contact.contactPoint
        if puffer.damageable {
            if collision == PhysicsCategory.Bullet | PhysicsCategory.Ally {
                bulletHit()
            }
            if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
                enemyHit()
            }
            if collision == PhysicsCategory.Ally | PhysicsCategory.Enemy {
                enemyHit()
            }
        }
        if collision == PhysicsCategory.Ally | PhysicsCategory.Carrot {
            if !carrot.isHidden{
                carrotTime()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
//        Your code here
    }
    
    func spawnBullet3(enemy:SKSpriteNode){
        let Bullet = SKSpriteNode(imageNamed: "bubble")
        let bulletPop = SKTexture(imageNamed: "bubblepop")
        Bullet.zPosition = 1
        Bullet.setScale(1.0)
        Bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y)
        
        let action = SKAction.move(to: puffer.position, duration: 1.3)
        let actionDone = SKAction.sequence([SKAction.setTexture(bulletPop), SKAction.wait(forDuration: 0.1), SKAction.removeFromParent()])
        Bullet.run(SKAction.sequence([action, actionDone]))
        Bullet.physicsBody = SKPhysicsBody(circleOfRadius: Bullet.size.height/7)
        Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        Bullet.physicsBody!.collisionBitMask = PhysicsCategory.None
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = false
        worldNode.addChild(Bullet)
    }
    
    func spawnEnemy() {
        createEnemyAnimation()
        newEnemy2 = SKSpriteNode(texture: idleFrames[0])
        enemies.append(newEnemy2)
        newEnemy2.setScale(0.5)
        newEnemy2.zPosition = 1
        newEnemy2.position = enemyPositions.randomElement()!
        newEnemy2.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy2.size.height/4)
        newEnemy2.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        newEnemy2.physicsBody!.collisionBitMask = PhysicsCategory.None
        newEnemy2.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        newEnemy2.physicsBody?.affectedByGravity = false
        newEnemy2.physicsBody?.isDynamic = false
        worldNode.addChild(newEnemy2)
        newEnemy2.run(enemyAnimation)
        newEnemy2.run(SKAction.sequence([(SKAction.wait(forDuration: 2.0)), (SKAction.removeFromParent())]))
        for e in enemies
        {
            let wait = SKAction.wait(forDuration: 1.5)
            let run = SKAction.run {
                self.spawnBullet3(enemy: e)
            }
            e.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
        }
        //        enemies.removeAll()
    }
    
    func spawnLilEnemy() {
        createMaleniaAnimation()
        newEnemy = SKSpriteNode(texture: idleMalenia[0])
        enemies.append(newEnemy)
        newEnemy.setScale(0.5)
        newEnemy.zPosition = 1
        newEnemy.position = smallEnemyPositions.randomElement()!
        newEnemy.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy.size.height/5)
        newEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        newEnemy.physicsBody!.collisionBitMask = PhysicsCategory.None
        newEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        newEnemy.physicsBody?.affectedByGravity = false
        newEnemy.physicsBody?.isDynamic = false
        worldNode.addChild(newEnemy)
        newEnemy.run(maleniaAction)
        newEnemy.run(SKAction.sequence([(SKAction.wait(forDuration: 2.0)), (SKAction.removeFromParent())]))
        for e in enemies
        {
            let wait = SKAction.wait(forDuration: 0.5)
            let run = SKAction.run {
                self.spawnBullet3(enemy: e)
            }
            e.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
        }
    }
    
    //    func spawnThirdEnemy() {
    //        createEnemyAnimation()
    //
    //        newEnemy3 = SKSpriteNode(texture: idleFrames[0])
    //        newEnemy3.setScale(0.5)
    //        enemies.append(newEnemy3)
    //        newEnemy3.zPosition = 0
    //        newEnemy3.position = thirdEnemyPositions.randomElement()!
    //        newEnemy3.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy3.size.height/3)
    //        newEnemy3.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
    //        newEnemy3.physicsBody!.collisionBitMask = PhysicsCategory.None
    //        newEnemy3.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
    //        newEnemy3.physicsBody?.affectedByGravity = false
    //        newEnemy3.physicsBody?.isDynamic = false
    //        worldNode.addChild(newEnemy3)
    //        newEnemy3.run(enemyAnimation)
    //        newEnemy3.run(SKAction.sequence([(SKAction.wait(forDuration: 1.0)), (SKAction.removeFromParent())]))
    //        for e in enemies
    //        {
    //            let wait = SKAction.wait(forDuration: 0.5)
    //            let run = SKAction.run {
    //                self.spawnBullet3(enemy: e)
    //            }
    //            e.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
    //        }
    //    }
    
    override func update(_ currentTime: TimeInterval = 50000.0) {
        if pufferState == 0 {
            gameScore += 1
        }
        else if pufferState == 1 {
            gameScore += 3
        }
        else if pufferState == 2 {
            gameScore += 6
        }
        
        if gameScore >= mod {
            mod = mod + 1500
            spawnCarrot()
        }
    }
    
    override func didMove(to view: SKView) {
        let xRange = SKRange(lowerLimit:-self.frame.width, upperLimit:self.frame.width)
        let yRange = SKRange(lowerLimit:-self.frame.height, upperLimit:self.frame.height)
        puffer.constraints = [SKConstraint.positionX(xRange, y: yRange)] // This is to prevent Fugu from going into the endless abyss that awaits outside the phone screen.
        SKTAudio.sharedInstance().playBackgroundMusic("Fugu.mp3") // This starts playing our music
        self.scaleMode = .aspectFill
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // Removing gravity so we can freely swim into the sea
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame) //imposta la scena intera come bordo
        self.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        self.physicsBody?.pinned = true
        self.physicsBody?.isDynamic = false
        self.physicsBody!.restitution = 0
        view.ignoresSiblingOrder = true
        view.showsPhysics = false
        view.showsFPS = false
        view.showsNodeCount = false
        addChild(worldNode)
        physicsWorld.contactDelegate = self
        puffer.position = CGPoint(x:0, y:0)
        puffer.physicsBody?.affectedByGravity = false
        puffer.physicsBody?.isDynamic = false
        puffer.damageable = true
        puffer.setScale(0.25)
        puffer.zPosition = 1
        puffer.physicsBody = SKPhysicsBody(circleOfRadius: puffer.size.height/5)
        puffer.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        puffer.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        puffer.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Enemy | PhysicsCategory.Carrot | PhysicsCategory.Dog | PhysicsCategory.Wall
        addChild(puffer)
        
        scoreLabel = SKLabelNode(fontNamed: "Free Pixel")
        scoreLabel.text = "SCORE  0"
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height/2 - 70)
        scoreLabel.zPosition = 2
        worldNode.addChild(scoreLabel)
        
        carrot.position = CGPoint(x:0, y:0)
        carrot.zPosition = 3
        carrot.setScale(0.5)
        carrot.physicsBody = SKPhysicsBody(circleOfRadius: carrot.size.height/3)
        carrot.physicsBody?.pinned = true
        carrot.physicsBody?.categoryBitMask = PhysicsCategory.Carrot
        carrot.physicsBody?.collisionBitMask = PhysicsCategory.None
        carrot.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        carrot.isHidden = true
        worldNode.addChild(carrot)
        
        blackBox.position = CGPoint(x: 0, y:0)
        blackBox.alpha = 0.0
        blackBox.zPosition = 2
        addChild(blackBox)
        
        banner.size.height = self.frame.height/9
        banner.size.width = self.frame.width
        banner.position = CGPoint(x: 0, y: self.frame.height/2 - 45)
        banner.zPosition = 0
        addChild(banner)
        
        background.size = self.frame.size
        background.position = CGPoint(x:0, y:0)
        background.zPosition = -3
        addChild(background)
        
        if !worldNode.isPaused {
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnEnemy()}, SKAction.wait(forDuration: 2.5)])))
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnLilEnemy()}, SKAction.wait(forDuration: 2.0)])))
            //            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnThirdEnemy()}, SKAction.wait(forDuration: 2.5)])))
        }
    }
}

