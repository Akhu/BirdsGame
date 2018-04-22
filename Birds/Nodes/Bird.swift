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
}


class Bird: SKSpriteNode {
    
    let birdType: BirdType
    var grabbed = false
    var flying = false {
        didSet {
            if flying {
                physicsBody?.isDynamic = true
            }
        }
    }
    
    init(withBirdType type: BirdType){
        birdType = type
    
        super.init(texture: nil, color: self.birdType.getColor(), size: CGSize(width: 40.0, height: 40.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
