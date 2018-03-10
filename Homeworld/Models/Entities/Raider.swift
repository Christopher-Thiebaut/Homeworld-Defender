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
    
    init(appearance: SKTexture, findTargets: @escaping () -> [GKAgent2D], afraidOf: [GKAgent2D], unlessDistanceAway distance: Float, entityController: EntityController){
        
        super.init()
        
        guard let gameScene = entityController.scene else {
            fatalError("Cannot add an entity to an entity controller with no scene.")
        }
        
        //Set up the visual component
        let spriteComponent = SpriteComponent(texture: appearance, size: appearance.size())
        addComponent(spriteComponent)
        
        //Give the raider limited health
        let healthComponent = HealthComponent(health: 25, entityController: entityController)
        addComponent(healthComponent)
        
        //The raider should cause damage if collided with
        let contactDamgeComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 20, destroySelf: false, doNotHarm: [TeamComponent.Team.alien], entityController: entityController)
        addComponent(contactDamgeComponent)
        
        //Give the raider an agent to control its behavior
        let raiderAgent = RaiderAgent(findTargets: findTargets, avoid: afraidOf, distanceFromAvoid: distance, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: 1, entityController: entityController)
        addComponent(raiderAgent)
        
        //Set up the raider's gun
        let projectileTexture = SKTexture(image: #imageLiteral(resourceName: "missile"))
        let projectileSize = CGSize(width: spriteComponent.node.size.width/10, height: spriteComponent.node.size.height/10)
        let fireProjectileComponent = FireProjectileComponent(projectileTexture: projectileTexture, size: projectileSize, damage: 50, speed: 1000, reloadTime: 1.5, projectileCategory: .alienProjectile, allies: .alien, entityController: entityController)
        addComponent(fireProjectileComponent)
        
        //Assign the number of points the player will get if this entity is destroyed.
        let scoreDeathComponent = ScoreDeathComponent(gameScene: gameScene, pointValue: 5)
        addComponent(scoreDeathComponent)
        
        //Give the raider a physics component so he won't run through boundaries
        if let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .rectange, mass: 1000, affectedByGravity: false, collisionCategory: .alien){
            addComponent(physicsComponent)
        }
        
        
        let team = TeamComponent(team: .alien)
        addComponent(team)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
