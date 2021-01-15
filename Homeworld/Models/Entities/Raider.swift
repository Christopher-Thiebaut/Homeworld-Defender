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
        findEnemy: @escaping () -> GKAgent2D?,
        unlessDistanceAway distance: Float,
        difficulty: Difficulty,
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
        let raiderAgent = RaiderAgent(findTargets: findTargets, findObstacles: findObstacles, findEnemy: findEnemy,distanceFromAvoid: distance, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: Float(max(spriteComponent.node.size.width, spriteComponent.node.size.height)), difficulty: difficulty)
        addComponent(raiderAgent)
        
        //Set up the raider's gun
        let projectileSpeed = difficulty.getEnemyProjectileSpeed()
        let reloadTime = difficulty.getEnemyReloadTime()

        let weapon = FireProjectileComponent(speed: projectileSpeed, reloadTime: reloadTime, projectileType: .energyPulse, projectileCategory: .alienProjectile)
        addComponent(weapon)
        
        //Give the raider a physics component so he won't run through boundaries
        let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .rectange, mass: 1000, affectedByGravity: false, collisionCategory: .alien)
        addComponent(physicsComponent)
        
        let team = TeamComponent(team: .alien)
        addComponent(team)
        
        let explosionConfig = ExplosionConfig(scale: 0.5, damage: 100, duration: 0.2)
        addComponent(ExplodeOnDeath(config: explosionConfig))
        
        let pointsOnDeath = PointsOnDeathComponent(playerPointsOnDeath: 5)
        addComponent(pointsOnDeath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
