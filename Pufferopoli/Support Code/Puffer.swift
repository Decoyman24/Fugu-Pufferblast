//
//  Puffer.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 23/03/22.
//

import SpriteKit

class Puffer : SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Fugu")
    var initialSize: CGSize = CGSize (width: 256, height: 256)
    var idleAnimation = SKAction()
    var futwoAction = SKAction()
    var fatguAction = SKAction()
    var superGuAction = SKAction()
    var damageable = true
    var golden = false
    
    
    func createAnimation(){
        let idleFrames: [SKTexture] = [textureAtlas.textureNamed("Fugu1"), textureAtlas.textureNamed("Fugu2"), textureAtlas.textureNamed("Fugu3"), textureAtlas.textureNamed("Fugu4"), textureAtlas.textureNamed("Fugu5"), textureAtlas.textureNamed("Fugu6"), textureAtlas.textureNamed("Fugu7"), textureAtlas.textureNamed("Fugu8")]
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.15)
        idleAnimation = SKAction.repeatForever(idleAction)
    }
    
    func createFutwoAnimation(){
        let idleFugu2: [SKTexture] = [fugu2Atlas.textureNamed("Futwo1"), fugu2Atlas.textureNamed("Futwo2"), fugu2Atlas.textureNamed("Futwo3"), fugu2Atlas.textureNamed("Futwo4"), fugu2Atlas.textureNamed("Futwo5"), fugu2Atlas.textureNamed("Futwo6"), fugu2Atlas.textureNamed("Futwo7"), fugu2Atlas.textureNamed("Futwo8")]
        let idleAction = SKAction.animate(with: idleFugu2, timePerFrame: 0.15)
        futwoAction = SKAction.repeatForever(idleAction)
    }
    
    func createFatguAnimation(){
        let idleFatgu: [SKTexture] = [fatGu.textureNamed("FATGU1"), fatGu.textureNamed("FATGU2"), fatGu.textureNamed("FATGU3"), fatGu.textureNamed("FATGU4"), fatGu.textureNamed("FATGU5"), fatGu.textureNamed("FATGU6"), fatGu.textureNamed("FATGU7"), fatGu.textureNamed("FATGU8")]
        let idleAction = SKAction.animate(with: idleFatgu, timePerFrame: 0.15)
        fatguAction = SKAction.repeatForever(idleAction)
    }
    
    func createSuperGuAnimation(){
        let superFrames: [SKTexture] = [superGuAtlas.textureNamed("SFugu1"), superGuAtlas.textureNamed("SFugu2"), superGuAtlas.textureNamed("SFugu3"), superGuAtlas.textureNamed("SFugu4"), superGuAtlas.textureNamed("SFugu5"), superGuAtlas.textureNamed("SFugu6"), superGuAtlas.textureNamed("SFugu7"), superGuAtlas.textureNamed("SFugu8")]
        let idleAction = SKAction.animate(with: superFrames, timePerFrame: 0.15)
        superGuAction = SKAction.repeatForever(idleAction)
    }
    
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimation()
        self.run(idleAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
