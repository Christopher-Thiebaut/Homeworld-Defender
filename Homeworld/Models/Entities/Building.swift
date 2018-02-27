//
//  Building.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Building: GKEntity {
    
    let health = 50
    
    init(texture: SKTexture, size: CGSize, entityController: EntityController){
        
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(health: health, entityController: entityController)
        addComponent(healthComponent)
        
        let passiveAgent = PassiveAgent(spriteNode: spriteComponent.node)
        addComponent(passiveAgent)
        
        let contactDamageComponenent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 100, destroySelf: false, entityController: entityController)
        addComponent(contactDamageComponenent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
