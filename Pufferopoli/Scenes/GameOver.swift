//
//  GameOver.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 23/03/22.
//

import SpriteKit

class GameOver : SKScene {
    var sceneManagerDelegate: SceneManagerDelegate?
    var retryButton = SKSpriteNode()
    var mainMenuButton = SKSpriteNode()
    var score = SKLabelNode()
    
    override func didMove(to view: SKView) {
        score.zPosition = 3
        score.text = "SCORE: \(userScore)"
        score.position = CGPoint(x: 0, y: 352)
        addChild(score)
        if let gameo = self.childNode(withName: "RetryButton") as? SKSpriteNode {
            retryButton = gameo
        }
        if let gameo = self.childNode(withName: "MainMenuButton") as? SKSpriteNode {
            mainMenuButton = gameo
        }
        self.view?.showsPhysics = false
    }
    
    override func update(_ currentTime: TimeInterval) {
//        Your code here
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        touchedButton(touchLocation: touchLocation)
        
        func touchedButton(touchLocation: CGPoint) {
            let nodeAtPoint = atPoint(touchLocation)
            if let touchedNode = nodeAtPoint as? SKSpriteNode {
                if touchedNode.name?.starts(with: "RetryButton") == true {
                    let gameScene = GameScene(fileNamed: "GameScene")
                    print("moving to gameplay")
                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0))
                }
                if touchedNode.name?.starts(with: "MainMenuButton") == true {
                    let gameScene = HomeScreen(fileNamed: "HomeScreen")
                    print("moving to gameplay")
                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0))
                }
            }
        }
    }
}
