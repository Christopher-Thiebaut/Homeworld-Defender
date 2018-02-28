//
//  ContactDamageComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ContactDamageComponent: GKComponent {
    
    var spriteNode: SKSpriteNode
    ///Indicates that this entity should be removed after causing contact damage. Should be used for consumable projectiles like missiles and laser beams.
    var destroySelf: Bool
    
    var damage: Int
    var lastDamageTime: TimeInterval
    var doNotHarm: Set<GKEntity>
    
    weak var entityController: EntityController?
    
    
    
    init(spriteNode: SKSpriteNode, contactDamage: Int, destroySelf: Bool, doNotHarm: Set<GKEntity> = [], entityController: EntityController){
        self.spriteNode = spriteNode
        self.damage = contactDamage
        self.destroySelf = destroySelf
        self.entityController = entityController
        self.doNotHarm = doNotHarm
        lastDamageTime = 0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        guard let entityController = entityController, let ownEntity = self.entity else {
            NSLog("A contact damage component has no entity controller. Fix it.")
            return
        }
        
        var otherEntities = entityController.entities
        otherEntities.remove(ownEntity)
        
        
        //Loop through other entities and see if any are having a collision with this one. If so, they should take the specified amount of damage.
        for entity in otherEntities {
            
            guard let otherEntitySpriteComponent = entity.component(ofType: SpriteComponent.self), let otherEntityHealthComponent = entity.component(ofType: HealthComponent.self), !doNotHarm.contains(entity) else {
                //The other entity being checked either is immune to damage or has no physical representation and cannot collide or be damaged by contact, or we have been specifically instructed not to damage.
                continue
            }
            
            if spriteNode.calculateAccumulatedFrame().intersects(otherEntitySpriteComponent.node.calculateAccumulatedFrame()) {
                otherEntityHealthComponent.takeDamage(damage)
                if destroySelf {
                    entityController.remove(ownEntity)
                }
            }
        }
    }
}
