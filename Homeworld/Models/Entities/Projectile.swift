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
        
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        addComponent(spriteComponent)
        
        guard let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .texture, mass: 5, affectedByGravity: false, collisionCategory: collisionCategory) else{
            fatalError("A projectile MUST have a physics body or it cannot have a velocity")
        }
        addComponent(physicsComponent)
        physicsComponent.physicsBody.velocity = velocity
        
        let contactDamageComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 50, destroySelf: oneHit, doNotHarm: allies == nil ? [] : [allies!], entityController: entityController)
        addComponent(contactDamageComponent)
        
        let lifeSpanComponent = LifespanComponent(lifespan: 0.75, entityController: entityController)
        addComponent(lifeSpanComponent)
        
        if let scene = entityController.scene, isRocket {
            let rocketEffectComponent = RocketEffectComponent(spriteNode: spriteComponent.node, scene: scene)
            addComponent(rocketEffectComponent)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
