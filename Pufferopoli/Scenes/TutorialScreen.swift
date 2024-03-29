//
//  HomeScreen.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 23/03/22.
//

import SpriteKit

class TutorialScreen : SKScene {
    var sceneManagerDelegate: SceneManagerDelegate?
    var tutorialView = SKSpriteNode(imageNamed: "TutorialScreen")
    
    override func didMove(to view: SKView) {
        self.view?.showsPhysics = false
        if modelName == "Simulator iPhone 14 Plus" {
            tutorialView.position = CGPoint(x: 0, y: 0)
            tutorialView.zPosition = 2
            tutorialView.setScale(0.55)
            addChild(tutorialView)
        }
        
        else if modelName == "Simulator iPhone 14 Pro Max" {
            tutorialView.position = CGPoint(x: 0, y: 0)
            tutorialView.zPosition = 2
            tutorialView.setScale(0.55)
            addChild(tutorialView)
        }
        
        else if modelName == "iPhone 14 Plus" {
            tutorialView.position = CGPoint(x: 0, y: 0)
            tutorialView.zPosition = 2
            tutorialView.setScale(0.55)
            addChild(tutorialView)
        }
        
        else if modelName == "iPhone 14 Pro Max" {
            tutorialView.position = CGPoint(x: 0, y: 0)
            tutorialView.zPosition = 2
            tutorialView.setScale(0.55)
            addChild(tutorialView)
        }
        
        else {
            tutorialView.position = CGPoint(x: 0, y: 0)
            tutorialView.zPosition = 2
            tutorialView.setScale(0.5)
            addChild(tutorialView)
        }
        //        tutorialView.position = CGPoint(x: 0, y: 0)
        //        tutorialView.zPosition = 2
        //        tutorialView.setScale(0.5)
        //        addChild(tutorialView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = HomeScreen(fileNamed: "HomeScreen")
        gameScene?.sceneManagerDelegate = self.sceneManagerDelegate
        print("moving to home")
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.4))
    }
}


