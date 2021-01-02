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

protocol ContactHealthModifierDelegate: AnyObject {
    func contactDetected(with entity: GKEntity)
}

protocol EntityRemovalDelegate: AnyObject {
    func remove(_ entity: GKEntity)
}

class ContactHealthModifier: GKComponent {
    
    ///Indicates that this entity should be removed after causing contact damage. Should be used for consumable projectiles like missiles and laser beams.
    var destroySelf: Bool
    
    var contactHealthChange: Int
    var doNotHarm: [TeamComponent.Team]
    
    weak var delegate: ContactHealthModifierDelegate?

    init(changeHealthBy: Int, destroySelf: Bool, doNotHarm: [TeamComponent.Team] = []){
        self.contactHealthChange = changeHealthBy
        self.destroySelf = destroySelf
        self.doNotHarm = doNotHarm
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contactDetectedWith(entity: GKEntity) {
        delegate?.contactDetected(with: entity)
        
        if destroySelf {
            self.entity?.addComponent(Tombstone())
        }
        
        guard let otherEntityHealthComponent = entity.component(ofType: HealthComponent.self) else {return}
        if let otherTeam = entity.component(ofType: TeamComponent.self)?.team, doNotHarm.contains(otherTeam) {
            return
        }

        otherEntityHealthComponent.changeHealthBy(contactHealthChange)
    }
}
