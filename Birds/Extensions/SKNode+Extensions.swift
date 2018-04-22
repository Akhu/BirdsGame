//
//  SKNode+Extensions.swift
//  Birds
//
//  Created by Anthony Da Cruz on 22/04/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit


extension SKNode {
    
    func aspectScale(to size:CGSize, width: Bool, multiplier: CGFloat){
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
    }
}
