//
//  Building.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Building: GKEntity {
    
    let health: Int
    
    init(spriteNode: SKSpriteNode, health: Int){
        self.health = health
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: spriteNode, color: .white)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(health: health)
        addComponent(healthComponent)
        
        let passiveAgent = PassiveAgent(spriteNode: spriteComponent.node)
        addComponent(passiveAgent)
        
        let obstacleComponent = PassiveObstacleComponent(radius: spriteNode.size.height, position: spriteNode.position)
        addComponent(obstacleComponent)
        
        let contactDamageComponenent = ContactHealthModifier(changeHealthBy: -health/4, destroySelf: false,doNotHarm: [TeamComponent.Team.environment])
        addComponent(contactDamageComponenent)
        
        let teamComponent = TeamComponent(team: .environment)
        addComponent(teamComponent)
        
        let physicsComponent = PhysicsComponent(spriteNode: spriteNode, bodyType: .rectange, mass: 0, affectedByGravity: false, collisionCategory: .environment)
        addComponent(physicsComponent)
        physicsComponent.physicsBody.isDynamic = false
        
        let explosionConfig = ExplosionConfig(scale: 2, damage: 100, duration: 0.2)
        addComponent(ExplodeOnDeath(config: explosionConfig))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
