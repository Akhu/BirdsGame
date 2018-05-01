//
//  Bird.swift
//  Birds
//
//  Created by Anthony Da Cruz on 21/04/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit

enum BirdType: String {
    case red, blue, yellow, gray
    
    func getColor() -> UIColor {
        switch self {
            case .blue:
                return UIColor.blue
            case .red:
                return UIColor.red
            case .gray:
                return UIColor.gray
            case .yellow:
                return UIColor.yellow
        }
    }
    
    func getTexture() -> SKTexture {
        return SKTexture(imageNamed: self.getImageName())
    }
    
    func getImageName() -> String {
        return self.rawValue + "1"
    }
}


class Bird: SKSpriteNode {
    
    let birdType: BirdType
    var grabbed = false
    var flying = false {
        didSet {
            if flying {
                physicsBody?.isDynamic = true
                self.animateFlight(active: true)
            }else {
                self.animateFlight(active: false)
            }
        }
    }
    
    let flyingFrames: [SKTexture]
    
    init(withBirdType type: BirdType){
        birdType = type
        flyingFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: type.rawValue), withName: type.rawValue)
        
        super.init(texture: type.getTexture(), color: UIColor.clear, size: type.getTexture().size())
    }
    
    func animateFlight(active: Bool){
        if active {
            run(SKAction.repeatForever(SKAction.animate(with: flyingFrames, timePerFrame: 0.1, resize: true, restore: true)))
        }else {
            removeAllActions()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
