//
//  ChaseAgent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class ChaseAgent : GKAgent2D, GKAgentDelegate {
    
    let entityController: EntityController
    let target: GKAgent2D
    
    init(target: GKAgent2D, maxSpeed: Float, maxAcceleration: Float, radius: Float, entityController: EntityController){
        self.entityController = entityController
        self.target = target
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.4
        behavior = ChaseBehavior(targetSpeed: maxSpeed, seek: target)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Make sure the agent's location matches the sprite's location because the sprite locaiton is what the user sees.
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = SIMD2(x: Float(spriteComponent.node.position.x), y: Float(spriteComponent.node.position.y))
    }
    
    //update the position of the sprite component to match the position of the agent.
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        let rotationConstraint = SKConstraint.orient(to: CGPoint.init(x: CGFloat(target.position.x), y: CGFloat(target.position.y)), offset: SKRange(constantValue: 0))
        spriteComponent.node.constraints = [rotationConstraint]
    }
    
}
