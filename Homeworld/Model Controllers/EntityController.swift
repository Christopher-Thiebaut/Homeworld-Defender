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

protocol EntityControllerDelegate: AnyObject {
    var floorLevel: CGFloat { get }
    func addChild(_ sprite: SKNode)
    func convert(_ point: CGPoint, from node: SKNode) -> CGPoint
}

class EntityController: NSObject, EntityRemovalDelegate {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    weak var scene: EntityControllerDelegate? {
        didSet {
            entities = Set<GKEntity>()
            toRemove = Set<GKEntity>()
        }
    }
    
    var difficultyLevel: Difficulty
    
    var alienAgents = Set<GKAgent2D>()
    var buildingAgents = Set<GKAgent2D>()
    var obstacles = Set<GKCircleObstacle>()
    lazy var playerAgent: GKAgent2D? = getPlayerAgent()
    
    let componentSystems: [GKComponentSystem<GKComponent>]
    
    init(difficulty: Difficulty.DifficultyLevel, componentSystems: [GKComponentSystem<GKComponent>] = .productionConfigurtion) {
        //Allows the scene to create an instance of this before initializing itself.
        self.difficultyLevel = Difficulty(difficulty: difficulty)
        self.componentSystems = componentSystems
    }

    private func removeAgentFromAgentGroups(_ agent: GKAgent2D?) {
        guard let agent = agent else { return }
        alienAgents.remove(agent)
        buildingAgents.remove(agent)
        if agent == playerAgent {
            playerAgent = nil
        }
    }
    
    private func updateGroupsForAgent(_ agent: GKAgent2D?){
        
        guard let agent = agent,let entity = agent.entity else {
            return
        }
        if entity.component(ofType: TeamComponent.self)?.team == .alien {
            alienAgents.insert(agent)
        }
        if entity is Building {
            buildingAgents.insert(agent)
        }
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        //Add the entity's components to their appropriate component systems so the will get called in the run loop.
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        updateGroupsForAgent(entity.component(ofType: PassiveAgent.self))
        updateGroupsForAgent(entity.component(ofType: RaiderAgent.self))
        updateGroupsForAgent(entity.component(ofType: HunterAgent.self))
        
        if let obstacle = entity.component(ofType: PassiveObstacleComponent.self)?.obstacle {
            obstacles.insert(obstacle)
        }
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            if spriteNode.parent == nil {
                scene?.addChild(spriteNode)
            }
        }
    }
    
    func remove(_ entity: GKEntity){
        entity.component(ofType: SpriteComponent.self)?.node.removeAllActions()
        entity.component(ofType: SpriteComponent.self)?.node.removeFromParent()
        entity.component(ofType: DeathEffectComonent.self)?.applyDeathEffect()
        entity.component(ofType: RocketEffectComponent.self)?.particleEmitter?.removeFromParent()
        removeAgentFromAgentGroups(entity.component(ofType: PassiveAgent.self))
        removeAgentFromAgentGroups(entity.component(ofType: RaiderAgent.self))
        removeAgentFromAgentGroups(entity.component(ofType: HunterAgent.self))
        if let obstacle = entity.component(ofType: PassiveObstacleComponent.self)?.obstacle { obstacles.remove(obstacle) }
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    func update(_ deltaTime: TimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        var killed = [GKEntity]()
        for entity in entities {
            if let node = entity.component(ofType: SpriteComponent.self)?.node, let parent = node.parent, let position = scene?.convert(node.position, from: parent), let floorLevel = scene?.floorLevel, position.y < floorLevel {
                node.position.y += 2000
            }
            
            if let health = entity.component(ofType: HealthComponent.self) {
                if health.health <= 0 {
                    killed.append(entity)
                }
            }
        }
        
        killed.forEach { remove($0) }
        //Remove the components of entities being removed from their component systems so their update functions won't get called again.
        for removedEntity in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: removedEntity)
            }
        }
        toRemove.removeAll()
    }
    
    func getCivilianTargetAgents() -> Set<GKAgent2D> {
        return buildingAgents
    }
    
    func getAlienEntities() -> Set<GKAgent2D> {
        return alienAgents
    }
    
    private func getPlayerAgent() -> GKAgent2D? {
        for entity in entities {
            if let playerEntity = entity as? HumanFighter, let playerAgent = playerEntity.component(ofType: PassiveAgent.self) {
                self.playerAgent = playerAgent
                return playerAgent
            }
        }
        return nil
    }
}

protocol PhysicsContact {
    var bodyA: SKPhysicsBody { get }
    var bodyB: SKPhysicsBody { get }
}

extension SKPhysicsContact: PhysicsContact {}

extension EntityController: SKPhysicsContactDelegate {
    
    func began(_ contact: PhysicsContact) {
        guard let sprite1 = contact.bodyA.node as? SKSpriteNode else { return }
        guard let sprite2 = contact.bodyB.node as? SKSpriteNode else { return }
        let bodyAEntities = findEntitiesWithSpriteNode(sprite1)
        let bodyBEntites = findEntitiesWithSpriteNode(sprite2)
        notifyEntitiesOfMutualContact(bodyAEntities: bodyAEntities, bodyBEntities: bodyBEntites)
    }
    
    //Notify any entities involved about the contact
    func didBegin(_ contact: SKPhysicsContact) {
        began(contact)
    }
    
    private func findEntitiesWithSpriteNode(_ node: SKSpriteNode) -> [GKEntity] {
        var foundEntites: [GKEntity] = []
        for spriteComponent in Array(entities).compactMap({$0.component(ofType: SpriteComponent.self)}){
            if spriteComponent.hasSprite(node: node) {
                foundEntites.append(spriteComponent.entity!)
            }
        }
        return foundEntites
    }
    
    private func notifyEntitiesOfMutualContact(bodyAEntities: [GKEntity], bodyBEntities: [GKEntity]){
        for entity in bodyAEntities {
            //guard let entityContactDamageComponent = entity.component(ofType: ContactDamageComponent.self) else { continue }
            for otherEntity in bodyBEntities {
                entity.component(ofType: ContactHealthModifier.self)?.contactDetectedWith(entity: otherEntity)
                otherEntity.component(ofType: ContactHealthModifier.self)?.contactDetectedWith(entity: entity)
            }
        }
    }
}
