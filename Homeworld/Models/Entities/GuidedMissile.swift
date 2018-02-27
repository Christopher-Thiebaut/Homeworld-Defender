//
//  GuidedMissile.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GuidedMissile: GKEntity {
    
    let entityController: EntityController
    let target: GKAgent
    let image = #imageLiteral(resourceName: "missile")
    let maxSpeed: Float = 400
    let maxAcceleration: Float = 40000
    
    init(target: GKAgent2D, entityController: EntityController){
        self.entityController = entityController
        self.target = target
        super.init()
        
        let texture = SKTexture(image: image)
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        let contactDamageComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 200, destroySelf: true, entityController: entityController)
        addComponent(contactDamageComponent)
        
        let chaseAgent = ChaseAgent(target: target, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: 1, entityController: entityController)
        addComponent(chaseAgent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
