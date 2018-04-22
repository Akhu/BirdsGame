//
//  BlockType.swift
//  Birds
//
//  Created by Anthony Da Cruz on 21/04/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit

enum BlockType: String {
    case wood, stone, glass
    
    func getProperties() -> Int {
        switch self {
        case .glass:
            return 50
        case .stone:
            return 500
        case .wood:
            return 200
        }
    }
}

class Block: SKSpriteNode {
    
    let type: BlockType
    var health: Int
    let damageTreshold: Int
    
    init(withType type: BlockType) {
        self.type = type
        self.health = self.type.getProperties()
        
        damageTreshold = health/2
        
        super.init(texture: nil, color: UIColor.clear, size: .zero)
    }
    
    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.block
        physicsBody?.contactTestBitMask = PhysicsCategory.all
        physicsBody?.collisionBitMask = PhysicsCategory.all
    }
    
    func impact(withForce force: Int){
        health -= force
        print(health)
        if health < 1 {
            removeFromParent()
        } else if health < damageTreshold {
            color = UIColor.red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
