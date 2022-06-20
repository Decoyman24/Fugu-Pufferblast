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
    static let Letter: UInt32 = 0b10000 // 8
    static let Carrot: UInt32 = 0b100000 // 16
    static let Enemy2: UInt32 = 0b1000000 //3 2
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
    
    var multiLabel: SKLabelNode!
    var worldNode = SKNode()
    var puffer = Puffer()
    var scoreLabel: SKLabelNode!
    var mod = 1500
    var notHit = 992
    var letterCount = 3
    var carrotSpawned = false
    var controlling = false
    var carrotTaken = false
    var nodePosition = CGPoint()
    var startTouch = CGPoint()
    var enemies: [SKSpriteNode] = []
    var newEnemy = SKSpriteNode()
    var newEnemy2 = SKSpriteNode()
    var newEnemy3 = SKSpriteNode()
//    var pickup = SKSpriteNode()
    var letterSpawn = true
    var letter1 = SKSpriteNode(imageNamed: "F")
    var letter2 = SKSpriteNode(imageNamed: "U")
    var letter3 = SKSpriteNode(imageNamed: "G")
    var letter4 = SKSpriteNode(imageNamed: "U")
    var pufferState : Int = 0
    var letter = SKSpriteNode()
    let background = SKSpriteNode(imageNamed: "Background")
    let banner = SKSpriteNode(imageNamed: "Banner")
    let carrot = SKSpriteNode(imageNamed: "Carrot")
    let blackBox = SKSpriteNode(imageNamed: "BlackBox")
    let noHit = SKTexture(imageNamed: "Puffer")
    let oneHit = SKTexture(imageNamed: "PufferBig")
    let twoHit = SKTexture(imageNamed: "PufferBigger")
    let power = SKTextureAtlas(named: "PowerLetters")
    let pickUps = SKTextureAtlas(named: "LetterPick")
    var powerLetters: [SKTexture] = []
    var indicators: [SKTexture] = []
    let enemyPositions: [CGPoint] = [CGPoint(x:-160, y:288),CGPoint(x:160, y:288),CGPoint(x:160, y:-288),CGPoint(x:-160, y:-288)]
    let smallEnemyPositions: [CGPoint] = [CGPoint(x:0, y:288),CGPoint(x:0, y:-288),CGPoint(x:180, y:0),CGPoint(x:-180, y:0)]
    let thirdEnemyPositions: [CGPoint] = [CGPoint(x: -140, y:330),CGPoint(x:140, y:300),CGPoint(x:-140, y:-330),CGPoint(x:140, y:300)]
    let lettersPositions: [CGPoint] = [CGPoint(x: -60, y:60),CGPoint(x:60, y:-60),CGPoint(x:-60, y:-60),CGPoint(x:60, y:60)]
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
            if puffer.golden {
                let touch = touches.first
                if let location = touch?.location(in: self){
                    puffer.run(SKAction.move(to: CGPoint(x:  nodePosition.x + location.x - startTouch.x, y: nodePosition.y + location.y - startTouch.y), duration: 0.01))
                }
            }
            else {
                let touch = touches.first
                if let location = touch?.location(in: self){
                    puffer.run(SKAction.move(to: CGPoint(x:  nodePosition.x + location.x - startTouch.x, y: nodePosition.y + location.y - startTouch.y), duration: 0.1))
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlling = false
    }
    
    func gameOver(){
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
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        carrot.isHidden = true
        carrotTaken = true
        SKTAudio.sharedInstance().playSoundEffect("Carrot.mp3")
        puffer.removeAllActions()
        let puffAlpha = SKAction.fadeAlpha(to: 0.3, duration: 0.50)
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
                multiLabel.isHidden = true
                puffer.createAnimation()
                puffer.run(puffer.idleAnimation)
                puffer.setScale(0.25)
                puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.run{self.puffer.damageable = true}, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
                carrotSpawned = false
            }
            
            if pufferState == 1 {
                multiLabel.isHidden = false
                multiLabel.text = "2X"
                multiLabel.fontSize = 24.0
                multiLabel.fontColor = .yellow
                puffer.createFutwoAnimation()
                puffer.run(puffer.futwoAction)
                puffer.setScale(0.65)
                puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.run{self.puffer.damageable = true}, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
                carrotSpawned = false
            }
            
            else if pufferState == 2 {
                multiLabel.isHidden = false
                multiLabel.text = "3X"
                multiLabel.fontSize = 26.0
                multiLabel.fontColor = .orange
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
        notHit = 0
        print("hit by bubble")
        pufferState += 1
        puffer.damageable = false
        let puffAlpha = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.2)
        let puffAlpha2 = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        
        puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait, SKAction.run{self.puffer.damageable = true}]))
        if pufferState == 1 {
            
            multiLabel.isHidden = false
            multiLabel.text = "2X"
            multiLabel.fontSize = 24.0
            multiLabel.fontColor = .yellow
            SKTAudio.sharedInstance().playSoundEffect("Hit1.mp3")
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            puffer.createFutwoAnimation()
            puffer.run(puffer.futwoAction)
            puffer.setScale(0.60)
        }
        
        else if pufferState == 2 {
            multiLabel.isHidden = false
            multiLabel.text = "3X"
            multiLabel.fontSize = 26.0
            multiLabel.fontColor = .orange
            SKTAudio.sharedInstance().playSoundEffect("Hit2.mp3")
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            puffer.createFatguAnimation()
            puffer.run(puffer.fatguAction)
            puffer.setScale(0.80)
        }
        
        else if pufferState == 3 {
            SKTAudio.sharedInstance().playSoundEffect("Hit3.mp3")
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            gameOver()
        }
    }
    
    func enemyHit(){
        notHit = 0
        print("touched enemy")
        SKTAudio.sharedInstance().playSoundEffect("Slashed.mp3")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        pufferState = 3
        if pufferState == 1 {
            multiLabel.isHidden = false
            multiLabel.text = "2X"
            multiLabel.fontSize = 24.0
            multiLabel.fontColor = .yellow
            puffer.createFutwoAnimation()
            puffer.run(puffer.futwoAction)
            puffer.setScale(0.65)
        }
        else if pufferState == 2 {
            multiLabel.isHidden = false
            multiLabel.text = "3X"
            multiLabel.fontSize = 26.0
            multiLabel.fontColor = .orange
            puffer.createFatguAnimation()
            puffer.run(puffer.fatguAction)
            puffer.setScale(0.80)
        }
        else if pufferState == 3 {
            gameOver()
        }
    }
    
    func enemyDie(){
        SKTAudio.sharedInstance().playSoundEffect("FuguSlice.mp3")
        let boom = SKSpriteNode(imageNamed: "boom")
        newEnemy.removeAllActions()
        newEnemy.isHidden = true
        newEnemy.removeFromParent()
        boom.position = newEnemy.position
        boom.zPosition = 4
        boom.setScale(0.7)
        addChild(boom)
        createSliceAnimation()
        boom.run(SKAction.sequence([sliceAction, SKAction.removeFromParent()
                                   ]))
        gameScore += 1000
        carrotSpawned = true
    }
    
    func enemy2Die(){
        SKTAudio.sharedInstance().playSoundEffect("FuguSlice.mp3")
        let boom = SKSpriteNode(imageNamed: "boom")
        newEnemy2.removeAllActions()
        newEnemy2.isHidden = true
        newEnemy2.removeFromParent()
        boom.position = newEnemy2.position
        boom.zPosition = 4
        boom.setScale(0.7)
        addChild(boom)
        createSliceAnimation()
        boom.run(SKAction.sequence([sliceAction, SKAction.removeFromParent()
                                   ]))
        gameScore += 1000
        carrotSpawned = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        //        let contactPoint = contact.contactPoint
        if puffer.golden {
            
            if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
                if !newEnemy.isHidden{
                    enemyDie()
                }
            }
            if collision == PhysicsCategory.Ally | PhysicsCategory.Enemy {
                if !newEnemy.isHidden{
                    enemyDie()
                }
            }
            if collision == PhysicsCategory.Enemy2 | PhysicsCategory.Ally {
                if !newEnemy2.isHidden{
                    enemy2Die()
                }
            }
            if collision == PhysicsCategory.Ally | PhysicsCategory.Enemy2 {
                if !newEnemy2.isHidden{
                    enemy2Die()
                }
            }
        }
        
        if puffer.damageable {
            if collision == PhysicsCategory.Bullet | PhysicsCategory.Ally {
                bulletHit()
            }
            if collision == PhysicsCategory.Enemy | PhysicsCategory.Ally {
                if !newEnemy.isHidden{
                    enemyHit()
                }
            }
            if collision == PhysicsCategory.Ally | PhysicsCategory.Enemy {
                if !newEnemy.isHidden{
                    enemyHit()
                }
            }
            if collision == PhysicsCategory.Enemy2 | PhysicsCategory.Ally {
                if !newEnemy2.isHidden{
                    enemyHit()
                }
            }
            if collision == PhysicsCategory.Ally | PhysicsCategory.Enemy2 {
                if !newEnemy2.isHidden{
                    enemyHit()
                }
            }
        }
        if collision == PhysicsCategory.Ally | PhysicsCategory.Carrot {
            if !carrot.isHidden{
                carrotTime()
            }
        }
        if collision == PhysicsCategory.Ally | PhysicsCategory.Letter {
            if !letter.isHidden{
                letterGot()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        //        Your code here
    }
    
//    func spawnLetter(){
//        letter.run(SKAction.move(to: lettersPositions.randomElement()!, duration: 0.1))
//        letter.isHidden = false
//        print("letter spawned")
//        notHit = 0
//        letter.run(SKAction.setTexture(powerLetters[letterCount]))
//    }
    
    func letterGot(){
        letter.isHidden = true
        
        switch letterCount {
        case 0:
                        letter1.isHidden = false
            letterCount += 1
//            pickup.run(SKAction.setTexture(indicators[letterCount]))
        case 1:
                        letter1.isHidden = false
                        letter2.isHidden = false
            letterCount += 1
//            pickup.run(SKAction.setTexture(indicators[letterCount]))
            
        case 2:
                        letter1.isHidden = false
                        letter2.isHidden = false
                        letter3.isHidden = false
            letterCount += 1
//            pickup.run(SKAction.setTexture(indicators[letterCount]))
            
        case 3:
                        letter1.isHidden = false
                        letter2.isHidden = false
                        letter3.isHidden = false
                        letter4.isHidden = false
            letterCount += 1
//            pickup.run(SKAction.setTexture(indicators[letterCount]))
            superFugu()
            
        default:
            letter1.isHidden = true
            letter2.isHidden = true
            letter3.isHidden = true
            letter4.isHidden = true
        }
        
        //        print("got a letter")
        //        if letterCount <= 3 {
        //            letterCount += 1
        //        }
        //        if letterCount == 4 {
        //            superFugu()
        //        }
        
    }
    
    func superFugu(){
        SKTAudio.sharedInstance().backgroundMusicPlayer?.prepareToPlay()
        SKTAudio.sharedInstance().playBackgroundMusic("SuperFugu.mp3")
        print("super fugu!")
        letterCount = 0
        puffer.setScale(0.5)
        puffer.removeAllActions()
        carrot.isHidden = true
        carrotSpawned = true
        puffer.damageable = false
        puffer.golden = true
        letterSpawn = false
        scoreLabel.fontColor = .yellow
        let puffAlpha = SKAction.fadeAlpha(to: 0.3, duration: 0.2)
        let letterSize = SKAction.scale(to: 0.4, duration: 0.3)
        let wait = SKAction.wait(forDuration: 0.1)
        let puffAlpha2 = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
        let letterSize2 = SKAction.scale(to: 0.3, duration: 0.3)
        let blink = SKAction.sequence([letterSize, wait, letterSize2])
        let blinkAction = SKAction.repeatForever(blink)
        
        
        puffer.run(SKAction.sequence([SKAction.run{
            self.puffer.createSuperGuAnimation()
            self.puffer.run(self.puffer.superGuAction)
            self.letter1.run(blinkAction)
            self.letter2.run(blinkAction)
            self.letter3.run(blinkAction)
            self.letter4.run(blinkAction)
        },SKAction.wait(forDuration: 8.0), puffAlpha, wait, puffAlpha2, puffAlpha, wait, puffAlpha2, puffAlpha, wait, puffAlpha2, SKAction.run{
            self.letter1.removeAllActions()
            self.letter2.removeAllActions()
            self.letter3.removeAllActions()
            self.letter4.removeAllActions()
            self.puffer.damageable = true
            self.puffer.golden = false
            self.puffer.createAnimation()
            self.puffer.run(self.puffer.idleAnimation)
            self.carrotSpawned = false
            self.pufferState = 0
            self.notHit = 0
            self.puffer.removeAllActions()
            self.multiLabel.isHidden = true
            self.puffer.createAnimation()
            SKTAudio.sharedInstance().backgroundMusicPlayer?.prepareToPlay()
            SKTAudio.sharedInstance().playBackgroundMusic("Fugu.mp3")
            self.puffer.run(self.puffer.idleAnimation)
            self.puffer.setScale(0.25)
            self.puffer.run(SKAction.sequence([puffAlpha, wait, puffAlpha2, wait,puffAlpha, wait, puffAlpha2, wait, puffAlpha, wait, puffAlpha2, SKAction.wait(forDuration: 0.5), SKAction.run{
                self.letterSpawn = true
                self.puffer.damageable = true
            }, (SKAction.wait(forDuration: 2)), (SKAction.run{self.carrotTaken = false})]))
                        self.letter1.isHidden = true
                        self.letter2.isHidden = true
                        self.letter3.isHidden = true
                        self.letter4.isHidden = true
            self.scoreLabel.fontColor = .white
//            self.pickup.run(SKAction.setTexture(self.indicators[self.letterCount]))
        }
                                     ]))
    }
    
    func spawnBullet3(enemy:SKSpriteNode) {
        if !newEnemy.isHidden{
            let Bullet = SKSpriteNode(imageNamed: "bubble")
            let bulletPop = SKTexture(imageNamed: "bubblepop")
            Bullet.zPosition = 1
            Bullet.setScale(1.0)
            Bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y)
            
            let action = SKAction.move(to: puffer.position, duration: 0.9)
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
    }
    
    func spawnBullet4(enemy:SKSpriteNode){
        if !newEnemy2.isHidden {
            let Bullet = SKSpriteNode(imageNamed: "bubble")
            let bulletPop = SKTexture(imageNamed: "bubblepop")
            Bullet.zPosition = 1
            Bullet.setScale(1.5)
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
    }
    
    func spawnEnemy() {
        let vortex = SKSpriteNode(imageNamed: "Vortexopoli")
        vortex.setScale(0.8)
        vortex.alpha = 0.0
        vortex.zPosition = 1
        createEnemyAnimation()
        createBubbleAnimation()
        newEnemy2 = SKSpriteNode(texture: idleFrames[0])
        enemies.append(newEnemy2)
        newEnemy2.isHidden = true
        newEnemy2.alpha = 0
        newEnemy2.setScale(0.5)
        newEnemy2.zPosition = 2
        newEnemy2.position = enemyPositions.randomElement()!
        newEnemy2.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy2.size.height/4)
        newEnemy2.physicsBody?.categoryBitMask = PhysicsCategory.Enemy2
        newEnemy2.physicsBody!.collisionBitMask = PhysicsCategory.None
        newEnemy2.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        newEnemy2.physicsBody?.affectedByGravity = false
        newEnemy2.physicsBody?.isDynamic = false
        vortex.position = newEnemy2.position
        worldNode.addChild(vortex)
        vortex.run(bubbleAnimation)
        vortex.run(SKAction.sequence([(SKAction.fadeAlpha(to: 0.8, duration: 0.1)), SKAction.rotate(byAngle: 10, duration: 0.8), (SKAction.wait(forDuration: 0.2)), SKAction.run{
            self.worldNode.addChild(self.newEnemy2)
            self.newEnemy2.isHidden = false
            self.newEnemy2.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
        }, (SKAction.wait(forDuration: 0.2)), (SKAction.fadeAlpha(to: 0.0, duration: 0.2)), (SKAction.removeFromParent())]))
        
        newEnemy2.run(enemyAnimation)
        newEnemy2.run(SKAction.sequence([(SKAction.wait(forDuration: 2.0)), (SKAction.fadeAlpha(to: 0.0, duration: 0.2)),
                                         SKAction.run{
            self.newEnemy2.isHidden = true
        }, (SKAction.removeFromParent())]))
        
        for e in enemies
        {
            let wait = SKAction.wait(forDuration: 0.5)
            let run = SKAction.run {
                if !self.newEnemy2.isHidden{
                    self.spawnBullet4(enemy: e)
                }
            }
            e.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
        }
        enemies.removeLast()
    }
    
    func spawnLilEnemy() {
        let vortex = SKSpriteNode(imageNamed: "Vortexopoli")
        vortex.setScale(0.8)
        vortex.alpha = 0.0
        vortex.zPosition = 1
        createMaleniaAnimation()
        createBubbleAnimation()
        newEnemy = SKSpriteNode(texture: idleMalenia[0])
        enemies.append(newEnemy)
        newEnemy.isHidden = true
        newEnemy.setScale(0.5)
        newEnemy.zPosition = 2
        newEnemy.position = smallEnemyPositions.randomElement()!
        newEnemy.physicsBody = SKPhysicsBody(circleOfRadius: newEnemy.size.height/5)
        newEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        newEnemy.physicsBody!.collisionBitMask = PhysicsCategory.None
        newEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        newEnemy.physicsBody?.affectedByGravity = false
        newEnemy.physicsBody?.isDynamic = false
        vortex.position = newEnemy.position
        worldNode.addChild(vortex)
        vortex.run(bubbleAnimation)
        
        vortex.run(SKAction.sequence([(SKAction.fadeAlpha(to: 0.8, duration: 0.1)), SKAction.rotate(byAngle: 10, duration: 0.8), (SKAction.wait(forDuration: 0.2)), SKAction.run{
            self.worldNode.addChild(self.newEnemy)
            self.newEnemy.isHidden = false
            self.newEnemy.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
        }, (SKAction.wait(forDuration: 0.2)), (SKAction.fadeAlpha(to: 0.0, duration: 0.2)), (SKAction.removeFromParent())]))
        
        newEnemy.run(maleniaAction)
        newEnemy.run(SKAction.sequence([(SKAction.wait(forDuration: 2.0)), (SKAction.fadeAlpha(to: 0.0, duration: 0.2)), SKAction.run{
            self.newEnemy.isHidden = true
        }, (SKAction.removeFromParent())]))
        for e in enemies
        {
            let wait = SKAction.wait(forDuration: 0.25)
            let run = SKAction.run {
                if !self.newEnemy.isHidden{
                    self.spawnBullet3(enemy: e)
                }
            }
            e.run(SKAction.repeatForever(SKAction.sequence([wait, run])))
        }
        enemies.removeLast()
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
        letter1.position = CGPoint(x: puffer.position.x - 45, y: puffer.position.y + 80)
        letter2.position = CGPoint(x: puffer.position.x - 15, y: puffer.position.y + 80)
        letter3.position = CGPoint(x: puffer.position.x + 15, y: puffer.position.y + 80)
        letter4.position = CGPoint(x: puffer.position.x + 45, y: puffer.position.y + 80)
        
        if pufferState == 0 {
            gameScore += 1
            notHit += 1
        }
        else if pufferState == 1 {
            gameScore += 3
            notHit += 3
        }
        else if pufferState == 2 {
            gameScore += 6
            notHit += 6
        }
        
        if gameScore >= mod {
            mod = mod + 2000
            spawnCarrot()
        }
        
        if notHit >= 2500 {
            notHit = 0
            letterGot()
        }
    }
    
    override func didMove(to view: SKView) {
        indicators = [pickUps.textureNamed("Pick0"),pickUps.textureNamed("Pick1"),pickUps.textureNamed("Pick2"),pickUps.textureNamed("Pick3"),pickUps.textureNamed("Pick4")]
        
        powerLetters = [power.textureNamed("F"), power.textureNamed("U"), power.textureNamed("G"), power.textureNamed("U2")]
        //        CONSTRAINTS
        let xRange = SKRange(lowerLimit:-(self.frame.width/2 - 10), upperLimit:self.frame.width/2 - 10)
        let yRange = SKRange(lowerLimit:-(self.frame.height/2 - 10), upperLimit:self.frame.height/2 - 10)
        puffer.constraints = [SKConstraint.positionX(xRange, y: yRange)] // This is to prevent Fugu from going into the endless abyss that awaits outside the phone screen.
        SKTAudio.sharedInstance().playBackgroundMusic("Fugu.mp3") // This starts playing our music
        
        //        PHYSICS TIME
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
        
        //        SET FUGU
        puffer.position = CGPoint(x:0, y:0)
        puffer.physicsBody?.affectedByGravity = false
        puffer.physicsBody?.isDynamic = false
        puffer.damageable = true
        puffer.setScale(0.25)
        puffer.zPosition = 1
        puffer.physicsBody = SKPhysicsBody(circleOfRadius: puffer.size.height/5)
        puffer.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        puffer.physicsBody?.collisionBitMask = PhysicsCategory.Wall
        puffer.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Enemy | PhysicsCategory.Carrot | PhysicsCategory.Letter | PhysicsCategory.Wall
        addChild(puffer)
        //        SET SCORELABEL
        scoreLabel = SKLabelNode(fontNamed: "Bubble Pixel-7 Dark")
        scoreLabel.fontSize = 22.0
        scoreLabel.text = "SCORE  0"
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height/2 - 70)
        scoreLabel.zPosition = 2
        worldNode.addChild(scoreLabel)
        
        //        Power letters in HUD, hidden for now they're ugly
        letter1.setScale(0.3)
        letter2.setScale(0.3)
        letter3.setScale(0.3)
        letter4.setScale(0.3)
        letter1.zPosition = 2
        letter2.zPosition = 2
        letter3.zPosition = 2
        letter4.zPosition = 2
        letter1.position = CGPoint(x: puffer.position.x - 45, y: puffer.position.y + 85)
        letter2.position = CGPoint(x: puffer.position.x - 15, y: puffer.position.y + 85)
        letter3.position = CGPoint(x: puffer.position.x + 15, y: puffer.position.y + 85)
        letter4.position = CGPoint(x: puffer.position.x + 45, y: puffer.position.y + 85)
        letter1.isHidden = true
        letter2.isHidden = true
        letter3.isHidden = true
        letter4.isHidden = true
        addChild(letter1)
        addChild(letter2)
        addChild(letter3)
        addChild(letter4)
        //        SET MULTILABEL
        multiLabel = SKLabelNode(fontNamed: "Bubble Pixel-7 Dark")
        multiLabel.fontSize = 22.0
        multiLabel.text = "1X"
        multiLabel.fontColor = .white
        multiLabel.horizontalAlignmentMode = .center
        multiLabel.position = CGPoint(x: self.frame.width/2 - 35, y: self.frame.height/2 - 69)
        multiLabel.zPosition = 2
        multiLabel.isHidden = true
        worldNode.addChild(multiLabel)
        //        SET CARROT
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
        //        SET POWERLETTER
        letter = SKSpriteNode(imageNamed: "F")
        letter.position = lettersPositions.randomElement()!
        letter.zPosition = 3
        letter.setScale(0.5)
        letter.physicsBody = SKPhysicsBody(circleOfRadius: letter.size.height/3)
        letter.physicsBody?.pinned = true
        letter.physicsBody?.categoryBitMask = PhysicsCategory.Letter
        letter.physicsBody?.collisionBitMask = PhysicsCategory.None
        letter.physicsBody?.contactTestBitMask = PhysicsCategory.Ally
        letter.isHidden = true
        worldNode.addChild(letter)
        //        SET BLACKBOX
        blackBox.position = CGPoint(x: 0, y:0)
        blackBox.alpha = 0.0
        blackBox.zPosition = 2
        addChild(blackBox)
        //        SET BANNER
        banner.size.height = self.frame.height/9
        banner.size.width = self.frame.width/2 + 70
        banner.position = CGPoint(x: 0, y: self.frame.height/2 - 40)
        banner.zPosition = 0
        addChild(banner)
        //       SET BACKGROUND
        background.size = self.frame.size
        background.position = CGPoint(x:0, y:0)
        background.zPosition = -3
        addChild(background)
        //        SET LETTERS INDICATOR
//        pickup = SKSpriteNode(texture: indicators[letterCount])
//        pickup.setScale(0.15)
//        pickup.position = CGPoint(x: -self.frame.width/2 + 35, y: self.frame.height/2 - 45)
//        addChild(pickup)
        //    RUN RUN RUN
        if !worldNode.isPaused {
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnEnemy()}, SKAction.wait(forDuration: 2.5)])))
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnLilEnemy()}, SKAction.wait(forDuration: 3.0)])))
            //            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnThirdEnemy()}, SKAction.wait(forDuration: 2.5)])))
        }
    }
}
