//
//  FireProjectileComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/5/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class FireProjectileComponent: GKComponent {
    private let speed: CGFloat
    private let reloadTime: TimeInterval
    private var timeSinceLastFired: TimeInterval
    let projectileCategory: PhysicsComponent.CollisionCategory
    private let projectileType: ProjectileType
    
    var pendingProjectiles = [FiredProjectile]()
    
    init(speed: CGFloat,
         reloadTime: TimeInterval,
         projectileType: ProjectileType,
         projectileCategory: PhysicsComponent.CollisionCategory
    ){
        self.reloadTime = reloadTime
        self.timeSinceLastFired = reloadTime + 1
        self.speed = speed
        self.projectileCategory = projectileCategory
        self.projectileType = projectileType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastFired += seconds
    }
    
    func fire(){
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("She cannot fire while she's cloaked.")
            return
        }
        
        let angle = Float(spriteNode.zRotation)
        
        fire(angle: angle)
    }
    
    func fire(angle: Float) {
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("She cannot fire while she's cloaked.")
            return
        }
        
        guard timeSinceLastFired > reloadTime else {
            return
        }
        
        timeSinceLastFired = 0
        
        let dx = CGFloat(cosf(angle))
        let dy = CGFloat(sinf(angle))
        
        let velocity = CGVector(dx: dx * speed, dy: dy * speed)
        
        let projectile = projectileForType(
            projectileType,
            at: spriteNode.position,
            with: velocity
        )
        pendingProjectiles.append(projectile)
    }
    
    private func projectileForType(_ type: ProjectileType,
                                   at position: CGPoint,
                                   with velocity: CGVector) -> FiredProjectile {
        switch type {
        case .rocket:
            return .rocket(position: position, velocity: velocity)
        case .energyPulse:
            return .energyPulse(position: position, velocity: velocity)
        }
    }
    
}

extension FireProjectileComponent: PercentageBarQuantity {
    var quantityRemaining: CGFloat {
        return min(CGFloat(timeSinceLastFired), CGFloat(reloadTime))
    }
    
    var maximumQuantity: CGFloat {
        return CGFloat(reloadTime)
    }
}
