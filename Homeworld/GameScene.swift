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
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        entityController.update(dt)
        // Called before each frame is rendered
//        if touchWasIn(node: thrustButton){
//            guard let playerRotation = player?.zRotation else {
//                NSLog("Failed to apply impulse to player because the player's orientation could not be determined")
//                return
//            }
//            let scale = 100.0
//            let angle = Float(playerRotation)
//            let dx = Double(cosf(angle))
//            let dy = Double(sinf(angle))
//            player?.physicsBody?.applyImpulse(CGVector.init(dx: dx * scale, dy: dy * scale))
//            lastTouchLocation = nil
//        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
