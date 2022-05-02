//
//  Enemy.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 23/03/22.
//

import SpriteKit
var userScore = 0
var bigEnemyAtlas : SKTextureAtlas = SKTextureAtlas(named: "BigEnemy")
var maleniaAtlas : SKTextureAtlas = SKTextureAtlas(named: "Malenia")
var fugu2Atlas: SKTextureAtlas = SKTextureAtlas(named: "Fugu2")
var superGuAtlas: SKTextureAtlas = SKTextureAtlas(named: "SuperFugu")
var fatGu: SKTextureAtlas = SKTextureAtlas(named: "Fugu3")
var vortexAtlas: SKTextureAtlas = SKTextureAtlas(named: "Vortex")
var sliceAtlas: SKTextureAtlas = SKTextureAtlas(named: "Slice")

let idleFrames: [SKTexture] = [bigEnemyAtlas.textureNamed("BigEnemy1"), bigEnemyAtlas.textureNamed("BigEnemy2"), bigEnemyAtlas.textureNamed("BigEnemy3"), bigEnemyAtlas.textureNamed("BigEnemy4"), bigEnemyAtlas.textureNamed("BigEnemy5"), bigEnemyAtlas.textureNamed("BigEnemy6")]

let idleMalenia: [SKTexture] = [maleniaAtlas.textureNamed("Malenia1"), maleniaAtlas.textureNamed("Malenia2"), maleniaAtlas.textureNamed("Malenia3"), maleniaAtlas.textureNamed("Malenia4"), maleniaAtlas.textureNamed("Malenia5"), maleniaAtlas.textureNamed("Malenia6")]

let vortexAnimation: [SKTexture] = [vortexAtlas.textureNamed("Vortexopoli"), vortexAtlas.textureNamed("Vortexopoli2")]

let sliceAnimation: [SKTexture] = [sliceAtlas.textureNamed("Slice1"), sliceAtlas.textureNamed("Slice2"), sliceAtlas.textureNamed("Slice3"), sliceAtlas.textureNamed("Slice4")]


var enemyAnimation = SKAction()
var maleniaAction = SKAction()
var bubbleAnimation = SKAction()
var sliceAction = SKAction()


func createEnemyAnimation(){
    let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.20)
    enemyAnimation = SKAction.repeatForever(idleAction)
}
func createMaleniaAnimation(){
    let idleAction = SKAction.animate(with: idleMalenia, timePerFrame: 0.20)
    maleniaAction = SKAction.repeatForever(idleAction)
}

func createBubbleAnimation(){
    let idleAction = SKAction.animate(with: vortexAnimation, timePerFrame: 0.40)
    bubbleAnimation = SKAction.repeatForever(idleAction)
}

func createSliceAnimation(){
    let idleAction = SKAction.animate(with: sliceAnimation, timePerFrame: 0.08)
    sliceAction = idleAction
}
