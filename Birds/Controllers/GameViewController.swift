//
//  GameViewController.swift
//  Birds
//
//  Created by Anthony Da Cruz on 13/03/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentLevelScene()
    func presentGameSceneFor(level: Int)
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
    }
}

extension GameViewController: SceneManagerDelegate {
    func present(scene: SKScene){
        if let view = self.view as! SKView? {
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }
    
    func presentMenuScene() {
        let menuScene = MenuScene()
        menuScene.sceneManagerDelegate = self
        self.present(scene: menuScene)
    }
    
    func presentLevelScene() {
        let levelScene = LevelSelectionScene()
        levelScene.sceneManagerDelegate = self
        self.present(scene: levelScene)
    }
    
    func presentGameSceneFor(level: Int) {
        let sceneName = "GameScene_\(level)"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
            present(scene: gameScene)
        }
    }
    
    
}
