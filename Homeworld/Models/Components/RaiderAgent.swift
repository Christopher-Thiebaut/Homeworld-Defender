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
    let desiredDistanceFromEnemies: Float
    private var lastPosition: CGPoint = CGPoint(x: 0, y: 0)
    private let findObstacles: () -> [GKObstacle]
    private let findEnemy: () -> GKAgent2D?
    weak var target: GKAgent2D? = nil
    private let entityController: EntityController
    
    init(findTargets: @escaping () -> [GKAgent2D], findObstacles: @escaping () -> [GKObstacle], findEnemy: @escaping () -> GKAgent2D?, distanceFromAvoid: Float, maxSpeed: Float, maxAcceleration: Float, radius: Float, entityController: EntityController){
        self.entityController = entityController
        self.findTargets = findTargets
        let targets = findTargets()
        self.findObstacles = findObstacles
        desiredDistanceFromEnemies = distanceFromAvoid
        self.findEnemy = findEnemy
        super.init()
        self.delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.4
        if let nearestTarget = nearestTarget(from: targets){
            behavior = GKCompositeBehavior(behaviors: [ChaseBehavior(targetSpeed: maxSpeed, seek: nearestTarget), CollisionAvoidanceBehavior(collisionRisks: findObstacles())], andWeights: [1, 400]) //ChaseBehavior(targetSpeed: maxSpeed, seek: nearestTarget)
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
        
        position = SIMD2(x: Float(spriteComponent.node.position.x), y: Float(spriteComponent.node.position.y))
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        //Check for super insane jumps in position (which GKAgents aparently do sometimes) If the agent jumps insanely, put it back.
        let distance = hypot(lastPosition.x - CGFloat(position.x), lastPosition.y - CGFloat(position.y))
        if distance > 10000 {
            position.x = Float(lastPosition.x)
            position.y = Float(lastPosition.y)
            entity?.component(ofType: SpriteComponent.self)?.node.position = lastPosition
        }else{
            lastPosition.x = CGFloat(position.x)
            lastPosition.y = CGFloat(position.y)
        }
        
        //Find nearest target

        if self.target == nil {
            let targets = findTargets()
            //target = self.nearestTarget(from: targets)
            let targetIndex = GKARC4RandomSource.sharedRandom().nextInt(upperBound: targets.count)
            target = targets[targetIndex]
        }
        
        let obstacles = findObstacles()
        
        
        
        let enemy: GKAgent2D? = findEnemy()
        
        if let dangerousEnemy = enemy, distanceTo(target: dangerousEnemy) < desiredDistanceFromEnemies{
            behavior = GKCompositeBehavior(behaviors: [RetreatBehavior(targetSpeed: maxSpeed, avoid: dangerousEnemy), CollisionAvoidanceBehavior(collisionRisks: obstacles)], andWeights: [1, 400]) //RetreatBehavior(targetSpeed: maxSpeed, avoid: dangerousEnemy)

            let stormTrooperOffset = entityController.difficultyLevel.getStormTrooperOffset()//Float(GKARC4RandomSource.sharedRandom().nextInt(upperBound: 10) - 5) * 0.05
            let fireAngle = atan2f(dangerousEnemy.position.y - self.position.y,dangerousEnemy.position.x - self.position.x)
            entity?.component(ofType: FireProjectileComponent.self)?.fire(angle: fireAngle + stormTrooperOffset)
            
            return
        }
        
        guard let target = target else {
            NSLog("Raider will not attack because target can't be found.")
            return
        }
        let attackDistance = entityController.difficultyLevel.getAttackDistance()
        guard distanceTo(target: target) < attackDistance else {
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
        let fireAngle = atan2f(target.position.y - self.position.y, target.position.x - self.position.x)
        projectileFiringComponent.fire(angle: fireAngle)
        
    }
    
    private func nearestTarget(from targets: [GKAgent2D?]) -> GKAgent2D? {
        var nearestTarget: GKAgent2D? = nil
        for target in targets {
            guard let closeTarget = nearestTarget else {
                nearestTarget = target
                continue
            }
            
            guard let target = target else {
                continue
            }
            
            //We are using this instead of the actual distances to save computation time.
            var xDifference = self.position.x - closeTarget.position.x
            var yDifference = self.position.y - closeTarget.position.y
            let closeTargetDiscanceRep = xDifference * xDifference + yDifference * yDifference
            xDifference = self.position.x - target.position.x
            yDifference = self.position.y - target.position.y
            let targetDistanceRep = xDifference * xDifference + yDifference * yDifference
            
            if targetDistanceRep < closeTargetDiscanceRep {
                nearestTarget = target
            }
        }
        return nearestTarget
    }
    
    private func distanceTo(target: GKAgent2D) -> Float {
        return hypotf(self.position.x - target.position.x, self.position.y - target.position.y)
    }
    
}
