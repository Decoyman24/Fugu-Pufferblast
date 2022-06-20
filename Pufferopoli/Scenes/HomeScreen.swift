//
//  HomeScreen.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 23/03/22.
//

import SpriteKit

class HomeScreen : SKScene {
    var sceneManagerDelegate: SceneManagerDelegate?
    var startButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        if let gameo = self.childNode(withName: "StartButton") as? SKSpriteNode {
            startButton = gameo
        }
        self.view?.showsPhysics = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        touchedButton(touchLocation: touchLocation)
        
        func touchedButton(touchLocation: CGPoint) {
            let nodeAtPoint = atPoint(touchLocation)
            if let touchedNode = nodeAtPoint as? SKSpriteNode {
                if touchedNode.name?.starts(with: "StartButton") == true {
                    let gameScene = TutorialScreen(fileNamed: "TutorialScreen")
                    print("moving to tutorial")
                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.4))
                }
                else {
                    let gameScene = GameScene(fileNamed: "GameScene")
                    print("moving to gameplay")
                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.4))
                }
            }
        }
    }
}
