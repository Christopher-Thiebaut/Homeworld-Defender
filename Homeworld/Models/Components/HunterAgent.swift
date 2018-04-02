//
//  HunterAgent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class HunterAgent: GKAgent2D, GKAgentDelegate {
    
    let chase: GKBehavior
    //let retreat: GKBehavior
    let doNotRunIntoStuff: GKBehavior
    let compositeBehavior: GKCompositeBehavior
    let target: GKAgent2D
    private let entityController: EntityController
    
    init(target: GKAgent2D, obstacles: [GKObstacle], maxSpeed: Float, maxAcceleration: Float, radius: Float, entityController: EntityController){
        chase = ChaseBehavior(targetSpeed: maxSpeed, seek: target)
        //retreat = RetreatBehavior(targetSpeed: maxSpeed, avoid: target)
        doNotRunIntoStuff = CollisionAvoidanceBehavior(collisionRisks: obstacles)
        compositeBehavior = GKCompositeBehavior(behaviors: [chase, doNotRunIntoStuff], andWeights: [1,0,40])
        self.entityController = entityController
        self.target = target
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.4
        behavior = compositeBehavior
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - GKAgentDelegate
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2.init(x: Float(spriteComponent.node.position.x), y: Float(spriteComponent.node.position.y))
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        let distanceToTarget = hypotf(self.position.x - target.position.x, self.position.y - target.position.y)
//        if distanceToTarget < 0 {
//            compositeBehavior.setWeight(400, for: retreat)
//        }else{
//            compositeBehavior.setWeight(0, for: retreat)
//        }
        let attackDistance = entityController.difficultyLevel.getAttackDistance()
        if distanceToTarget < attackDistance {
            let fireAngle = atan2f(target.position.y - self.position.y, target.position.x - self.position.x)
            let stormTrooperOffset = entityController.difficultyLevel.getStormTrooperOffset()
            entity?.component(ofType: FireProjectileComponent.self)?.fire(angle: fireAngle + stormTrooperOffset)
        }
    }
    
}
