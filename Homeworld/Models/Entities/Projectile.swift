//
//  Projectile.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Projectile: GKEntity {
    
    let lifespan: TimeInterval = 0.75
    
    init(velocity: CGVector, texture: SKTexture, size: CGSize, oneHit: Bool = true, allies: TeamComponent.Team?, collisionCategory: PhysicsComponent.CollisionCategory, isRocket: Bool = false, entityController: EntityController){
        super.init()
        
        if let allies = allies {
            let teamComponent = TeamComponent(team: allies)
            addComponent(teamComponent)
        }
        
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .rectange, mass: 5, affectedByGravity: false, collisionCategory: collisionCategory)
        addComponent(physicsComponent)
        physicsComponent.physicsBody.velocity = velocity
        
        let contactDamageComponent = ContactHealthModifier(changeHealthBy: -50, destroySelf: oneHit, doNotHarm: allies == nil ? [] : [allies!])
        addComponent(contactDamageComponent)
        
        let lifeSpanComponent = LifespanComponent(lifespan: 0.75)
        addComponent(lifeSpanComponent)
        
        let healthComponent = HealthComponent(health: 1)
        addComponent(healthComponent)
        
        if isRocket {
            let explosionConfig = ExplosionConfig(scale: 1, damage: 100, duration: 0.2)
            addComponent(ExplodeOnDeath(config: explosionConfig))
        }
        
        spriteComponent.node.zPosition = GameScene.ZPositions.default
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
