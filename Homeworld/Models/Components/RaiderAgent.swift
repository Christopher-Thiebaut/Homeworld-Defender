//
//  RaiderAgent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class RaiderAgent: GKAgent2D, GKAgentDelegate {
    
    let findTargets: () -> [GKAgent2D]
    
    init(findTargets: @escaping () -> [GKAgent2D], avoid: [GKAgent2D], distanceFromAvoid: Float, maxSpeed: Float, maxAcceleration: Float, radius: Float, entityController: EntityController){
        self.findTargets = findTargets
        let targets = findTargets()
        super.init()
        self.delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.4
        if let nearestTarget = nearestTarget(from: targets){
            behavior = ChaseBehavior(targetSpeed: maxSpeed, seek: nearestTarget)
        }
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
        
        //Find nearest target
        let targets = findTargets()
        
        let nearestTarget: GKAgent2D? = self.nearestTarget(from: targets)
        
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("Raider agent will not perform activity because it has no sprite.")
            return
        }
        
        guard let target = nearestTarget, let targetSpriteNode = target.entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("Raider will not attack because target can't be found.")
            return
        }
        
        // Turn to face the nearest target.
        let rotationConstraint = SKConstraint.orient(to: targetSpriteNode, offset: SKRange(constantValue: 0))
        spriteNode.constraints = [rotationConstraint]
        
        guard distanceTo(target: target) < 200 else {
            //If the raider is not very close to a target, approach the nearest one.
            behavior = ChaseBehavior(targetSpeed: maxSpeed, seek: target)
            return
        }
        //If the raider is already close to a target, stand still to shoot.
        let dummyAgent = GKAgent2D()
        dummyAgent.position = position
        speed = speed/2
        behavior = ChaseBehavior(targetSpeed: 0, seek: dummyAgent)
        
        //If the agent's entity can shoot, shoot at the nearest target.
        guard let projectileFiringComponent = entity?.component(ofType: FireProjectileComponent.self) else {
            NSLog("Raider cannot attack because it is unarmed.")
            return
        }
        //TODO: Consider doing something to reduce the accuracy of the raider or the frequency with which it fires. This will be ugly.
        projectileFiringComponent.fire()
        
    }
    
    private func nearestTarget(from targets: [GKAgent2D]) -> GKAgent2D? {
        var nearestTarget: GKAgent2D? = nil
        for target in targets {
            guard let closeTarget = nearestTarget else {
                nearestTarget = target
                continue
            }
            let closeTargetDistance = distanceTo(target: closeTarget)
            let targetDistance = distanceTo(target: target)
            
            if targetDistance < closeTargetDistance {
                nearestTarget = target
            }
        }
        return nearestTarget
    }
    
    private func distanceTo(target: GKAgent2D) -> Float {
        return hypotf(self.position.x - target.position.x, self.position.y - target.position.y)
    }
    
}