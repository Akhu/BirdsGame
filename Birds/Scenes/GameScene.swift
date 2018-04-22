//
//  GameScene.swift
//  Birds
//
//  Created by Anthony Da Cruz on 13/03/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState {
    case ready, flying, finished, animating
}

class GameScene: SKScene {
    
    
    var mapNode = SKTileMapNode()
    
    let gameCamera = GameCamera()
    
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale: CGFloat = 0
    
    var bird = Bird(withBirdType: .red)
    var birds = [
        Bird(withBirdType: .blue),
        Bird(withBirdType: .red),
        Bird(withBirdType: .yellow)
        ]
    let anchor = SKNode()
    
    var roundState:RoundState = .ready
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupLevel()
        
        setupGestureRecognizer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch self.roundState {
        case .ready:
            if let touch = touches.first { //the first touch in the screen
                let location = touch.location(in: self) //coordinates in self
                if bird.contains(location) { //If touch is in bird
                    panRecognizer.isEnabled = false
                    bird.grabbed = true
                    bird.position = location
                }
            }
        case .flying:
            break
        case .finished:
            guard let view = view else { return }
            roundState = .animating
            let moveCameraBackAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 0.8)
            moveCameraBackAction.timingMode = .easeInEaseOut
            gameCamera.run(moveCameraBackAction) {
                self.panRecognizer.isEnabled = true
                self.addBird()
            }
        case .animating:
            break
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if bird.grabbed {
                let location = touch.location(in: self)
                bird.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bird.grabbed {
            self.gameCamera.setConstraints(with: self, andFrame: self.mapNode.frame, toNode: bird)
            bird.grabbed = false
            bird.flying = true
            self.roundState = .flying
            let dx = anchor.position.x - bird.position.x //Deltas between birds and anchor
            let dy = anchor.position.y - bird.position.y
            let impulse = CGVector(dx: dx, dy: dy)
            constraintToAnchor(active: false)
            
            bird.physicsBody?.applyImpulse(impulse)
            bird.isUserInteractionEnabled = false
            //panRecognizer.isEnabled = true
        }
    }
    
    func setupGestureRecognizer(){
        guard let view = view else { return }
        self.panRecognizer.addTarget(self, action: #selector(self.pan))
        view.addGestureRecognizer(self.panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    func setupLevel() {
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            self.maxScale = min(mapNode.mapSize.height / frame.size.height, mapNode.mapSize.width/frame.size.width) //Ensure that dezooming will not go outside the tileMapSize
        }
        
        addCamera()
        
        for child in mapNode.children {
            if let child = child as? SKSpriteNode,
                let name = child.name, ["wood", "glass", "stone"].contains(name), let type = BlockType(rawValue: name) {
                let block = Block(withType: type)
                block.size = child.size
                block.position = child.position
                block.zPosition = ZPosition.obstacles
                block.zRotation = child.zRotation
                block.createPhysicsBody()
                mapNode.addChild(block)
                child.removeFromParent()
            } else { continue }
        }
        
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: self.mapNode.frame.size.width, height: self.mapNode.frame.size.height - mapNode.tileSize.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect) //Create our physics boundaries
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.bird | PhysicsCategory.block
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        
        anchor.position = CGPoint(x: mapNode.frame.midX/2, y: mapNode.frame.midY/2) //Used to set a spawn position for our birds
        addChild(anchor)
        addBird()
    }
    
    
    func addBird() {
        if birds.isEmpty {
            print("no more birds")
            return
        }
        
        bird = birds.removeFirst() //Return the element and suppress it from Array
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird //our bird id
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.all //Contact detection
        bird.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge //Collision detection
        bird.physicsBody?.isDynamic = false //Ensure that bird will not fall at start
        bird.physicsBody?.allowsRotation = true
        bird.position = anchor.position
        addChild(bird)
        bird.aspectScale(to: mapNode.tileSize, width: false, multiplier: 1.0)
        constraintToAnchor(active: true) //Constraint bird dragging around our launchpad
        roundState = .ready
    }
    
    func constraintToAnchor(active: Bool){
        if active {
            let slingRange = SKRange(lowerLimit: 0.0, upperLimit: bird.size.width*2)
            let positionConstraint = SKConstraint.distance(slingRange, to: anchor.position)
            bird.constraints = [positionConstraint]
        }else {
            bird.constraints?.removeAll()
        }
    }
    
    func addCamera() {
        guard let view = view else { return }
        addChild(self.gameCamera)
        self.gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        self.camera = self.gameCamera
        gameCamera.setConstraints(with: self, andFrame: mapNode.frame, toNode: nil)
    }
    
    /**
     * When physics has been simulated
    */
    override func didSimulatePhysics() {
        guard let physicsBody = bird.physicsBody else { return }
        if roundState == .flying && physicsBody.isResting {
            gameCamera.setConstraints(with: self, andFrame: mapNode.frame, toNode: nil)
            bird.removeFromParent()
            roundState = .finished
        }
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        //Contact entre les blocks
        //Contact entre les blocks et le sol
        //Contact entre l'oiseau et les murs => flying = false
        switch mask {
        case PhysicsCategory.bird | PhysicsCategory.block, PhysicsCategory.block | PhysicsCategory.edge:
            if let block = contact.bodyB.node as? Block {
                block.impact(withForce: Int(contact.collisionImpulse))
            } else if let block = contact.bodyA.node as? Block {
                block.impact(withForce: Int(contact.collisionImpulse))
            }
        case PhysicsCategory.block | PhysicsCategory.block:
            if let blockA = contact.bodyA.node as? Block, let blockB = contact.bodyB.node as? Block {
                blockA.impact(withForce: Int(contact.collisionImpulse))
                blockB.impact(withForce: Int(contact.collisionImpulse))
            }
        case PhysicsCategory.bird | PhysicsCategory.edge:
            bird.flying = false
        default:
            break
        }
    }
}

extension GameScene {
    @objc func pan(_ sender: UIPanGestureRecognizer){
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale //With extension
        self.gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func pinch(_ sender: UIPinchGestureRecognizer){
        guard let view = view else { return }
        if sender.numberOfTouches == 2 { //Zoom
            let locationInView = sender.location(in: view)
            let location = convertPoint(fromView: locationInView) //Point in center of pinch
            if sender.state == .changed { //is actually pinching
                let convertedScale = 1/sender.scale //Scaling from pinch to gameCamera
                let newScale = gameCamera.yScale*convertedScale
                
                if newScale < maxScale && newScale > 0.5 { //If scale is between our authorized scale
                    gameCamera.setScale(newScale)
                }
                
                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = location - locationAfterScale //Nice technics here, should use later
                let newPosition = gameCamera.position + locationDelta
                gameCamera.position = newPosition
                sender.scale = 1.0
                gameCamera.setConstraints(with: self, andFrame: mapNode.frame, toNode: nil)
            }
        }
    }
}
