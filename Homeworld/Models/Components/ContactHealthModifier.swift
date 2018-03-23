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

class ContactHealthModifier: GKComponent {
    
    var spriteNode: SKSpriteNode
    ///Indicates that this entity should be removed after causing contact damage. Should be used for consumable projectiles like missiles and laser beams.
    var destroySelf: Bool
    
    var damage: Int
    var lastDamageTime: TimeInterval
    var doNotHarm: [TeamComponent.Team]
    
    weak var entityController: EntityController?

    init(spriteNode: SKSpriteNode, changeHealthBy: Int, destroySelf: Bool, doNotHarm: [TeamComponent.Team] = [], entityController: EntityController){
        self.spriteNode = spriteNode
        self.damage = changeHealthBy
        self.destroySelf = destroySelf
        self.entityController = entityController
        self.doNotHarm = doNotHarm
        lastDamageTime = 0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contactDetectedWith(entity: GKEntity) {
        guard let otherEntityHealthComponent = entity.component(ofType: HealthComponent.self) else {return}
        if let otherTeam = entity.component(ofType: TeamComponent.self)?.team, doNotHarm.contains(otherTeam) {
            return
        }

        otherEntityHealthComponent.changeHealthBy(-damage)
        if destroySelf, let ownEntity = self.entity {
            entityController?.remove(ownEntity)
        }
    }
}
