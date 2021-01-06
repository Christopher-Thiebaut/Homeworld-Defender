//
//  Rock.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Rock: GKEntity {
    
    init(spriteNode: SKSpriteNode){
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: spriteNode)
        addComponent(spriteComponent)
        
        let teamComponent = TeamComponent(team: .environment)
        addComponent(teamComponent)
        
        let contactDamageComponent = ContactHealthModifier(changeHealthBy: -100, destroySelf: false, doNotHarm: [TeamComponent.Team.environment])
        addComponent(contactDamageComponent)
        
        let healthComponent = HealthComponent(health: 600)
        addComponent(healthComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
