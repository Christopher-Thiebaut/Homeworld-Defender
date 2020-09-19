//
//  HealthPack.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/21/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthPack: GKEntity {
    
    init(sprite: SKSpriteNode, healAmount: Int, upwardSpeed: CGFloat, entityController: EntityController){
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: sprite)
        addComponent(spriteComponent)
        
        let healingComponent = ContactHealthModifier(spriteNode: sprite, changeHealthBy: 100, destroySelf: true, doNotHarm: [.alien, .environment], entityController: entityController)
        addComponent(healingComponent)
        
        guard let scene = entityController.scene else {return}
        
        let destnition = CGPoint(x: sprite.position.x, y: scene.floorLevel + scene.gamePlayArea.height/2)
        let duration = TimeInterval(abs(destnition.y - sprite.position.y) / upwardSpeed)
        sprite.run(SKAction.move(to: destnition, duration: duration))
        
        let physicsComponent = PhysicsComponent(spriteNode: sprite, bodyType: .rectange, mass: 0, affectedByGravity: false, collisionCategory: .powerUp)
        physicsComponent.physicsBody.isDynamic = false
        addComponent(physicsComponent)
        
        let lifeSpanComponent = LifespanComponent(lifespan: 15, entityController: entityController)
        addComponent(lifeSpanComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
