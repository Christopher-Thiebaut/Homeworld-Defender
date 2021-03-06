//
//  HealthPack.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthPack: NonDecodableEntity {
    
    init(sprite: SKSpriteNode, healAmount: Int, upwardSpeed: CGFloat) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: sprite)
        addComponent(spriteComponent)
        
        let healingComponent = ContactHealthModifier(changeHealthBy: healAmount, destroySelf: true, doNotHarm: [.alien, .environment])
        addComponent(healingComponent)
        
        let destnition = CGPoint(x: sprite.position.x, y: 600)
        let duration = TimeInterval(abs(destnition.y - sprite.position.y) / upwardSpeed)
        sprite.run(SKAction.move(to: destnition, duration: duration))
        
        let physicsComponent = PhysicsComponent(spriteNode: sprite, bodyType: .rectange, mass: 0, affectedByGravity: false, collisionCategory: .powerUp)
        physicsComponent.physicsBody.isDynamic = false
        addComponent(physicsComponent)
        
        let lifeSpanComponent = LifespanComponent(lifespan: 15)
        addComponent(lifeSpanComponent)
    }
}
