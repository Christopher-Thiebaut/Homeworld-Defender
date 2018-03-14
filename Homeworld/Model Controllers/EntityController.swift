//
//  EntityController.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityController {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    var scene: GameScene? {
        didSet {
            entities = Set<GKEntity>()
            toRemove = Set<GKEntity>()
        }
    }
    
    lazy var componentSystems: [GKComponentSystem] = {
        let airfoilSystem = GKComponentSystem(componentClass: AirfoilComponent.self)
        let firingSystem = GKComponentSystem(componentClass: FireProjectileComponent.self)
        let manualRotationSystem = GKComponentSystem(componentClass: ManualRotationComponent.self)
        let animatedSystem = GKComponentSystem(componentClass: AnimatedComponent.self)
        let propulsionSystem = GKComponentSystem(componentClass: PropulsionComponent.self)
        let mapWrappingSystem = GKComponentSystem(componentClass: MapWrappingComponent.self)
        let passiveAgentSystem = GKComponentSystem(componentClass: PassiveAgent.self)
        let contactDamageComponent = GKComponentSystem(componentClass: ContactDamageComponent.self)
        let chaseAgentSystem = GKComponentSystem(componentClass: ChaseAgent.self)
        let healthSystem = GKComponentSystem(componentClass: HealthComponent.self)
        let expirationSystem = GKComponentSystem(componentClass: LifespanComponent.self)
        let raiderAgentSystem = GKComponentSystem(componentClass: RaiderAgent.self)
        let positionLoggingComponent = GKComponentSystem(componentClass: PositionLoggingComponent.self)
        let rocketEffectSystem = GKComponentSystem(componentClass: RocketEffectComponent.self)
        return [airfoilSystem ,positionLoggingComponent, firingSystem, manualRotationSystem, animatedSystem, propulsionSystem, mapWrappingSystem, passiveAgentSystem, chaseAgentSystem, raiderAgentSystem, healthSystem, expirationSystem, contactDamageComponent, rocketEffectSystem]
    }()
    
    ///This initializer allows for creating an entityManager before assigning a scene BUT an EntityController with no scene is NOT a valid state and the scene should be assigned to the entity controller before it is actually used.
    init() {
        //Allows the scene to create an instance of this before initializing itself.
    }
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        //Add the entity's components to their appropriate component systems so the will get called in the run loop.
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene?.addChild(spriteNode)
        }
    }
    
    func remove(_ entity: GKEntity){
        entity.component(ofType: SpriteComponent.self)?.node.removeFromParent()
        entity.component(ofType: ScoreDeathComponent.self)?.scoreDeath()
        entity.component(ofType: RocketEffectComponent.self)?.particleEmitter?.removeFromParent()
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    func update(_ deltaTime: TimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        //Remove the components of entities being removed from their component systems so their update functions won't get called again.
        for removedEntity in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: removedEntity)
            }
        }
        toRemove.removeAll()
    }
    
    func getCivilianTargetAgents() -> [GKAgent2D]{
        var targets: [GKAgent2D] = []
        for entity in entities {
            guard let building = entity as? Building, let buildingAgent = building.component(ofType: PassiveAgent.self) else {
                continue
            }
            targets.append(buildingAgent)
        }
        return targets
    }
    
    func getAlienEntities() -> [GKEntity]{
        var aliens: [GKEntity] = []
        for entity in entities {
            if let raider = entity as? Raider {
                aliens.append(raider)
            }
        }
        return aliens
    }
    
    func getPlayerAgent() -> GKAgent2D {
        for entity in entities {
            if let playerEntity = entity as? HumanFighter, let playerAgent = playerEntity.component(ofType: PassiveAgent.self) {
                return playerAgent
            }
        }
        fatalError("Player was not found.  This should have led to the game ending.")
    }
    
}
