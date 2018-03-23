//
//  Hunter.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class Hunter: GKEntity {
    
    let maxSpeed: Float = 100
    let maxAcceleration: Float = 40000
    
    init(appearance: SKTexture, target: GKAgent2D, obstacles: [GKObstacle], entityController: EntityController){
        
        super.init()
        
        guard let gameScene = entityController.scene else {
            fatalError("Cannot add an entity to an entity controller with no scene.")
        }
        
        //Set up the visual component
        let raiderSize = CGSize(width: appearance.size().width/7, height: appearance.size().height/7)
        let spriteComponent = SpriteComponent(texture: appearance, size: raiderSize)
        addComponent(spriteComponent)
        
        //Give the hunter limited health
        let healthComponent = HealthComponent(health: 50, entityController: entityController)
        addComponent(healthComponent)
        
        //The hunter should cause damage if collided with
        let contactDamgeComponent = ContactHealthModifier(spriteNode: spriteComponent.node, changeHealthBy: 50, destroySelf: false, doNotHarm: [TeamComponent.Team.alien], entityController: entityController)
        addComponent(contactDamgeComponent)
        
        //Give the hunter an agent to control its behavior
        let hunterAgent = HunterAgent(target: target, obstacles: obstacles, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: Float(max(spriteComponent.node.size.width, spriteComponent.node.size.height)), entityController: entityController)
        addComponent(hunterAgent)
        
        //Set up the hunter's gun
        let projectileSpeed = entityController.difficultyLevel.getEnemyProjectileSpeed()
        let reloadTime = entityController.difficultyLevel.getEnemyReloadTime()
        let projectileTexture = SKTextureAtlas(named: ResourceNames.mainSpriteAtlasName).textureNamed(ResourceNames.defaultAlientBlaster)
        let projectileSize = CGSize(width: spriteComponent.node.size.width/10, height: spriteComponent.node.size.height/10)
        let fireProjectileComponent = FireProjectileComponent(projectileTexture: projectileTexture, size: projectileSize, damage: 50, speed: projectileSpeed, reloadTime: reloadTime, projectileCategory: .alienProjectile, allies: .alien, entityController: entityController)
        addComponent(fireProjectileComponent)
        
        //Give the hunter a physics component so he won't run through boundaries
        if let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .rectange, mass: 1000, affectedByGravity: false, collisionCategory: .alien){
            addComponent(physicsComponent)
        }
        
        let team = TeamComponent(team: .alien)
        addComponent(team)
        
        let createExplosion: () -> () = {
            let explosionAtlas = SKTextureAtlas(named: "explosion")
            let explosion = Explosion(scale: 0.5, textureAtlas: explosionAtlas, damage: 100, duration: 0.2, entityController: entityController)
            explosion.component(ofType: SpriteComponent.self)?.node.position = spriteComponent.node.position
            entityController.add(explosion)
            gameScene.score += 5
        }
        
        let deathEffectComponent = DeathEffectComonent(deathEffect: createExplosion)
        addComponent(deathEffectComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
