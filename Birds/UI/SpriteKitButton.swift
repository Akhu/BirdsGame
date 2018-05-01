//
//  SpriteKitButton.swift
//  SpriteKit Demo
//
//  Created by Anthony Da Cruz on 10/03/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import SpriteKit

protocol SKDefaultButtonProtocol {
    var defaultButton: SKSpriteNode { get set }
    var action: (Int) -> () { get set }
    var index: Int { get set }
}

class SpriteKitButton: SKSpriteNode, SKDefaultButtonProtocol {
    
    var defaultButton: SKSpriteNode
    var action: (Int) -> ()
    var index: Int
    
    init(defaultButtonImage: String, action: @escaping (Int) -> (), index: Int){
        self.defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.action = action
        self.index = index
        super.init(texture: nil, color: UIColor.clear, size: defaultButton.size)
        
        self.isUserInteractionEnabled = true
        self.addChild(defaultButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 0.75
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if defaultButton.contains(location){
            self.defaultButton.alpha = 0.75
        }else{
            self.defaultButton.alpha = 1.0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if self.defaultButton.contains(location) {
            action(index)
        }
        
        defaultButton.alpha = 1.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.defaultButton.alpha = 1.0
    }
    
}
