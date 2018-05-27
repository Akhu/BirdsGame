//
//  MenuScene.swift
//  Birds
//
//  Created by Anthony Da Cruz on 22/04/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        self.setupMenu()
    }
    
    func setupMenu() {
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1.0)
        background.zPosition = ZPosition.background
        
        self.addChild(background)
        
        let button = SpriteKitButton(defaultButtonImage: "playButton", action: goToLevelScene, index: 0)
        button.position = CGPoint(x: frame.midX, y: frame.midY*0.8)
        button.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        button.zPosition = ZPosition.hudLabel
        addChild(button)
    }
    
    func goToLevelScene(_: Int){
        sceneManagerDelegate?.presentLevelScene()
    }
}
