//
//  GameCamera.swift
//  Birds
//
//  Created by Anthony Da Cruz on 15/03/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit

class GameCamera: SKCameraNode {

    func setConstraints(with scene: SKScene, andFrame frame: CGRect, toNode node: SKNode?){
        let scaledSize = CGSize(width: scene.size.width * xScale, height: scene.size.height * yScale) //Max zoomed size from scene
        let boardContentRect = frame
        
        let xInset = min(scaledSize.width / 2, boardContentRect.width / 2)
        let yInset = min(scaledSize.height / 2, boardContentRect.height / 2)
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        if let node = node {
            let zeroRange = SKRange(constantValue: 0.0)
            let positionConstraint = SKConstraint.distance(zeroRange, to: node)
            constraints = [positionConstraint, levelEdgeConstraint]
        }else {
            constraints = [levelEdgeConstraint]
        }
        
    }
}
