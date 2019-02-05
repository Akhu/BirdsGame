//
//  Enemy.swift
//  Birds
//
//  Created by Anthony Da Cruz on 05/02/2019.
//  Copyright © 2019 Anthony Da Cruz. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {
    
    var health: Int
    let damageTreshold: Int
    let animationFrames: [SKTexture]
    
    init(){
        animationFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: "orange"), withName: "orange")
        health = 100
        damageTreshold = health/2
        
        super.init(texture: animationFrames[0], color: .clear, size: animationFrames[0].size())
    }
    
    func animate(){
        run(SKAction.repeatForever(SKAction.animate(with: self.animationFrames, timePerFrame: 0.3, resize: false, restore: true)))
    }
    
    func impactAndIsDead(withForce force: Int) -> Bool{
        health -= force
        print("enemy health: \(health)")
        if health < 1 {
            removeFromParent()
            return true
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Enemy {
    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        guard let physics = physicsBody else { return }
        physics.isDynamic = true
        physics.categoryBitMask = PhysicsCategory.enemy
        physics.contactTestBitMask = PhysicsCategory.all
        physics.collisionBitMask = PhysicsCategory.all
    }
    
    static func createEnemy(fromPlaceholder placeholder: SKSpriteNode, name: String) -> Enemy {
        let enemy = Enemy()
        enemy.size = placeholder.size
        enemy.position = placeholder.position
        enemy.createPhysicsBody()
        return enemy
    }
}
