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
        let spriteComponent = SpriteComponent(texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        let contactDamageComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 200, destroySelf: true, entityController: entityController)
        addComponent(contactDamageComponent)
        
        let chaseAgent = ChaseAgent(target: target, maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: 1, entityController: entityController)
        addComponent(chaseAgent)
        
        guard let scene = entityController.scene else { fatalError("Tried to do setup from entityController with no scene.") }
        let mapWrappingComponent = MapWrappingComponent(spriteNode: spriteComponent.node, scene: scene)
        addComponent(mapWrappingComponent)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
