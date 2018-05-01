//
//  AnimationHelper.swift
//  Birds
//
//  Created by Anthony Da Cruz on 01/05/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        
        for index in 0..<atlas.textureNames.count{
            textures.append(atlas.textureNamed(name + String(index+1)))            
        }
        
        return textures
    }
}
