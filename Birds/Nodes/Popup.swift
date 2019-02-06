//
//  Popup.swift
//  Birds
//
//  Created by Anthony Da Cruz on 05/02/2019.
//  Copyright © 2019 Anthony Da Cruz. All rights reserved.
//

import SpriteKit

struct PopupButtons {
    static let menu = 0
    static let next = 1
    static let retry = 2
}

class Popup: SKSpriteNode {
    
    let type: Int
    var menuClicked: (() -> ())? = nil
    var retryClicked: (() -> ())? = nil
    var nextClicked: (() -> ())? = nil
    
    init(type: Int, size: CGSize){
        self.type = type
        super.init(texture: nil, color: .clear, size: size)
        setupPopup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPopup() {
        let background = type == 0 ? SKSpriteNode(imageNamed: "popupcleared") : SKSpriteNode(imageNamed: "popupfailed")
        background.aspectScale(to: size, width: false, multiplier: 0.5)
        let menuButton = SpriteKitButton(defaultButtonImage: "popmenu", action: popupButtonHandler, index: PopupButtons.menu)
        let nextButton = SpriteKitButton(defaultButtonImage: "popnext", action: popupButtonHandler, index: PopupButtons.next)
        let retryButton = SpriteKitButton(defaultButtonImage: "popretry", action: popupButtonHandler, index: PopupButtons.retry)
        
        nextButton.isUserInteractionEnabled = type == 0 ? true : false
        
        menuButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        nextButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        retryButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        
         let buttonWidthOffset = retryButton.size.width/2
         let buttonHeightOffset = retryButton.size.height/2
        let backgroundWidthOffset = background.size.width/2
        let backgroundHeightOffset = background.size.height/2
        
        menuButton.position = CGPoint(x: -backgroundWidthOffset + buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset )
        nextButton.position = CGPoint(x: 0, y: -backgroundHeightOffset - buttonHeightOffset)
        menuButton.position = CGPoint(x: backgroundWidthOffset - buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset )
        
        background.position = CGPoint(x: 0, y: buttonHeightOffset)
        
        addChild(menuButton)
        addChild(nextButton)
        addChild(retryButton)
        addChild(background)
    }
    
    func popupButtonHandler(index: Int){
        switch index {
        case PopupButtons.menu:
            self.menuClicked?()
            break
        case PopupButtons.next:
            self.nextClicked?()
            break
        case PopupButtons.retry:
            self.retryClicked?()
            break
        default:
            break
        }
    }
}
