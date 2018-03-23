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

class Tree: GKEntity {
    
    init(spriteNode: SKSpriteNode, entityController: EntityController){
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        addComponent(spriteComponent)
        
        let teamComponent = TeamComponent(team: .environment)
        addComponent(teamComponent)
        
        let contactDamageComponent = ContactHealthModifier(spriteNode: spriteNode, changeHealthBy: 30, destroySelf: false, doNotHarm: [TeamComponent.Team.environment], entityController: entityController)
        addComponent(contactDamageComponent)
        
        let healthComponent = HealthComponent(health: 60, entityController: entityController)
        addComponent(healthComponent)
        
        let obstacleComponent = PassiveObstacleComponent(radius: spriteNode.size.height, position: spriteNode.position)
        addComponent(obstacleComponent)
        
        if let physicsComponent = PhysicsComponent(spriteNode: spriteNode, bodyType: .rectange, mass: 0, affectedByGravity: false, collisionCategory: .environment){
            addComponent(physicsComponent)
            physicsComponent.physicsBody.isDynamic = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
