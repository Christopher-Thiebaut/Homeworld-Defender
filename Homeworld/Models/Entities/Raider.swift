//
//  Raider.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

let maxSpeed: Float = 100
let maxAcceleration: Float = 40000

class Raider: GKEntity {
    
    init(
        appearance: SKTexture,
        findTargets: @escaping () -> [GKAgent2D],
        findObstacles: @escaping () -> [GKObstacle],
        unlessDistanceAway distance: Float,
        entityController: EntityController,
        gameScene: GameScene
    ){
        
        super.init()
        
        //Set up the visual component
        let raiderSize = CGSize(width: appearance.size().width/7, height: appearance.size().height/7)
        let spriteComponent = SpriteComponent(texture: appearance, size: raiderSize)
        addComponent(spriteComponent)
        
        //Give the raider limited health
        let healthComponent = HealthComponent(health: 25)
        addComponent(healthComponent)
        
        //The raider should cause damage if collided with
        let contactDamgeComponent = ContactHealthModifier(changeHealthBy: -20, destroySelf: false, doNotHarm: [TeamComponent.Team.alien])
        addComponent(contactDamgeComponent)
        
        //Give the raider an agent to control its behavior
        let raiderAgent = RaiderAgent(findTargets: findTargets, findObstacles: findObstacles, findEnemy: {return entityController.playerAgent},distanceFromAvoid: distance, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: Float(max(spriteComponent.node.size.width, spriteComponent.node.size.height)), entityController: entityController)
        addComponent(raiderAgent)
        
        //Set up the raider's gun
        let projectileSpeed = entityController.difficultyLevel.getEnemyProjectileSpeed()
        let reloadTime = entityController.difficultyLevel.getEnemyReloadTime()
        let projectileTexture = SKTextureAtlas(named: ResourceNames.mainSpriteAtlasName).textureNamed(ResourceNames.defaultAlientBlaster)
        let projectileSize = CGSize(width: spriteComponent.node.size.width/10, height: spriteComponent.node.size.height/10)
        let fireProjectileComponent = FireProjectileComponent(projectileTexture: projectileTexture, size: projectileSize, speed: projectileSpeed, reloadTime: reloadTime, projectileCategory: .alienProjectile, allies: .alien, entityController: entityController)
        addComponent(fireProjectileComponent)
        
        //Give the raider a physics component so he won't run through boundaries
        let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .rectange, mass: 1000, affectedByGravity: false, collisionCategory: .alien)
        addComponent(physicsComponent)
        
        let team = TeamComponent(team: .alien)
        addComponent(team)
        
        let createExplosion: () -> () = {
            let explosionAtlas = SKTextureAtlas(named: "explosion")
            let explosion = Explosion(scale: 0.5, textureAtlas: explosionAtlas, damage: 100, duration: 0.2, entityController: entityController)
            explosion.component(ofType: SpriteComponent.self)?.node.position = spriteComponent.node.position
            entityController.add(explosion)
            gameScene.score += Int(floor(5 * entityController.difficultyLevel.getScoreMultiplier()))
        }
        
        let deathEffectComponent = DeathEffectComonent(deathEffect: createExplosion)
        addComponent(deathEffectComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
