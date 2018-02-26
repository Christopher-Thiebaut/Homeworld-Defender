//
//  GameScene.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/24/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityController: EntityController!
    var lastUpdateTimeInterval: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        entityController = EntityController(scene: self)
        
        let floor = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        self.physicsBody = floor
        
        let joyStickSize = CGSize(width: 60, height: 60)
        let joyStick = JoystickNode(size: joyStickSize)
        joyStick.position = CGPoint(x: 2 * 60, y: 3 * 60)
        addChild(joyStick)
        
        
        let humanFighter = HumanFighter(entityController: entityController, propulsionControl: joyStick, rotationControl: joyStick)
        if let humanSpriteComponent = humanFighter.component(ofType: SpriteComponent.self) {
            humanSpriteComponent.node.position = CGPoint(x: size.width/2, y: size.height/2)
            
        }
        entityController.add(humanFighter)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        entityController.update(dt)
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
