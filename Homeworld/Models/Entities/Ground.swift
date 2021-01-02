//
//  Ground.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/13/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Ground: GKEntity {
    
    init(spriteNode: SKSpriteNode, entityController: EntityController){
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        addComponent(spriteComponent)
        
        let contactDamageComponent = ContactHealthModifier(changeHealthBy: -1000000, destroySelf: false, doNotHarm: [.environment])
        addComponent(contactDamageComponent)
        
        let physicsComponent = PhysicsComponent(spriteNode: spriteNode, bodyType: .rectange, mass: 1000, affectedByGravity: false, collisionCategory: .environment)
        addComponent(physicsComponent)
        physicsComponent.physicsBody.isDynamic = false
        
        let groundAgent = PassiveAgent(spriteNode: spriteNode)
        addComponent(groundAgent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
