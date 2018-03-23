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
        
        guard let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .rectange, mass: 5, affectedByGravity: false, collisionCategory: collisionCategory) else{
            fatalError("A projectile MUST have a physics body or it cannot have a velocity")
        }
        addComponent(physicsComponent)
        physicsComponent.physicsBody.velocity = velocity
        
        let contactDamageComponent = ContactHealthModifier(spriteNode: spriteComponent.node, changeHealthBy: 50, destroySelf: oneHit, doNotHarm: allies == nil ? [] : [allies!], entityController: entityController)
        addComponent(contactDamageComponent)
        
        let lifeSpanComponent = LifespanComponent(lifespan: 0.75, entityController: entityController)
        addComponent(lifeSpanComponent)
        
        let healthComponent = HealthComponent(health: 1, entityController: entityController)
        addComponent(healthComponent)
        
        if isRocket {
            let createExplosion: () -> () = {
                let explosionAtlas = SKTextureAtlas(named: "explosion")
                let explosion = Explosion(scale: 1, textureAtlas: explosionAtlas, damage: 100, duration: 0.2, entityController: entityController)
                explosion.component(ofType: SpriteComponent.self)?.node.position = spriteComponent.node.position
                entityController.add(explosion)
            }
            
            let deathEffectComponent = DeathEffectComonent(deathEffect: createExplosion)
            addComponent(deathEffectComponent)

        }
        
        spriteComponent.node.zPosition = GameScene.ZPositions.default
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
