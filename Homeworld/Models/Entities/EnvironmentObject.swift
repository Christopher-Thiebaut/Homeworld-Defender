//
//  Tree.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EnvironmentObject: NonDecodableEntity {
    init(spriteNode: SKSpriteNode, contactDamage: Int, health: Int) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        addComponent(spriteComponent)
        
        let teamComponent = TeamComponent(team: .environment)
        addComponent(teamComponent)
        
        let contactDamageComponent = ContactHealthModifier(changeHealthBy: contactDamage, destroySelf: false, doNotHarm: [TeamComponent.Team.environment])
        addComponent(contactDamageComponent)
        
        let healthComponent = HealthComponent(health: health)
        addComponent(healthComponent)
        
        let obstacleComponent = PassiveObstacleComponent(radius: spriteNode.size.height, position: spriteNode.position)
        addComponent(obstacleComponent)
        
        let physicsComponent = PhysicsComponent(spriteNode: spriteNode, bodyType: .rectange, mass: 0, affectedByGravity: false, collisionCategory: .environment)
        addComponent(physicsComponent)
        physicsComponent.physicsBody.isDynamic = false
    }
}

class Tree: EnvironmentObject {
    init(spriteNode: SKSpriteNode) {
        super.init(spriteNode: spriteNode, contactDamage: -30, health: 60)
    }
}

class Rock: EnvironmentObject {
    init(spriteNode: SKSpriteNode) {
        super.init(spriteNode: spriteNode, contactDamage: -100, health: 600)
    }
}
