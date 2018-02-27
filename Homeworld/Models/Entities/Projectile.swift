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
    
    
    init(velocity: CGVector, texture: SKTexture, oneHit: Bool = true, immuneEntities: Set<GKEntity>, entityController: EntityController){
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        guard let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .texture, mass: 5, affectedByGravity: false, categoryBitmask: 0) else{
            fatalError("A projectile MUST have a physics body or it cannot have a velocity")
        }
        addComponent(physicsComponent)
        physicsComponent.physicsBody.velocity = velocity
        
        let contactDamageComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 50, destroySelf: oneHit, doNotHarm: immuneEntities, entityController: entityController)
        addComponent(contactDamageComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
