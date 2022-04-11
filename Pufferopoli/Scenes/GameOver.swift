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
    var score = SKLabelNode(fontNamed: "Bubble Pixel-7 Dark")
    var highScore = SKLabelNode(fontNamed: "Bubble Pixel-7 Dark")
    
    override func didMove(to view: SKView) {
        if userScore > UserDefaults.standard.integer(forKey: "scoreKey") {
            UserDefaults.standard.set(userScore, forKey: "scoreKey")
        }
        
        score.zPosition = 3
        score.horizontalAlignmentMode = .center
        score.fontColor = .systemOrange
        score.text = "FINAL SCORE: \(userScore)"
        score.fontSize = 22.0
        score.position = CGPoint(x: 0, y: self.frame.height/5 - 80)
        addChild(score)
        
        highScore.zPosition = 3
        highScore.horizontalAlignmentMode = .center
        highScore.fontColor = .systemOrange
        highScore.text = "HIGH SCORE: \(UserDefaults.standard.integer(forKey: "scoreKey"))"
        highScore.fontSize = 22.0
        highScore.position = CGPoint(x: 0, y: self.frame.height/5 - 110)
        addChild(highScore)
        
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
