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
    
    init(texture: SKTexture, size: CGSize, health: Int, entityController: EntityController){
        self.health = health
        
        super.init()
        
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(health: health, entityController: entityController)
        addComponent(healthComponent)
        
        let passiveAgent = PassiveAgent(spriteNode: spriteComponent.node)
        addComponent(passiveAgent)
        
        let contactDamageComponenent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 100, destroySelf: false, doNotHarm: [TeamComponent.Team.environment], entityController: entityController)
        addComponent(contactDamageComponenent)
        
        let teamComponent = TeamComponent(team: .environment)
        addComponent(teamComponent)
        
        let createExplosion: () -> () = {
            let explosionAtlas = SKTextureAtlas(named: "explosion")
            let explosion = Explosion(scale: 2, textureAtlas: explosionAtlas, damage: 100, duration: 0.2, entityController: entityController)
            explosion.component(ofType: SpriteComponent.self)?.node.position = spriteComponent.node.position
            entityController.add(explosion)
        }
        
        let deathEffectComponent = DeathEffectComonent(deathEffect: createExplosion)
        addComponent(deathEffectComponent)
    }
    
    init(spriteNode: SKSpriteNode, health: Int, entityController: EntityController){
        self.health = health
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: spriteNode, color: .white)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(health: health, entityController: entityController)
        addComponent(healthComponent)
        
        let passiveAgent = PassiveAgent(spriteNode: spriteComponent.node)
        addComponent(passiveAgent)
        
        let contactDamageComponenent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: health/4, destroySelf: false,doNotHarm: [TeamComponent.Team.environment], entityController: entityController)
        addComponent(contactDamageComponenent)
        
        let teamComponent = TeamComponent(team: .environment)
        addComponent(teamComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
