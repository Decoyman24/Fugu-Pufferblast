//
//  GameViewController.swift
//  Pufferopoli
//
//  Created by Luigi Minniti on 21/03/22.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManagerDelegate {
    func presentHomeScreen()
    func presentGameScene()
    func presentGameOver()
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentHomeScreen()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: SceneManagerDelegate {
    func present(scene: SKScene){
        if let view = self.view as! SKView? {
            if let gestureRecognizers = view.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    view.removeGestureRecognizer(recognizer)
                }
            }
            view.presentScene(scene)
            scene.scaleMode = .aspectFill
            scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // imposta il vettore della gravità dell'intera scena a 0
            scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame) //imposta la scena intera come bordo
            scene.physicsBody!.restitution = 0.2 //Aggiunge la proprietà rimbalzante a tutti i physics body (in questo caso lo slime)
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    func presentHomeScreen(){
        let homeScreen = HomeScreen(fileNamed: "HomeScreen")
        homeScreen?.sceneManagerDelegate = self
        self.present(scene: homeScreen!)
    }
    
    func presentGameScene(){
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.sceneManagerDelegate = self
        self.present(scene: gameScene!)
    }
    
    func presentGameOver(){
        let gameOver = GameOver(fileNamed: "GameOver")
        gameOver?.sceneManagerDelegate = self
        self.present(scene: gameOver!)
    }
    
    func infoPanelAnimation(){
       //non lo so fare
    }
}

