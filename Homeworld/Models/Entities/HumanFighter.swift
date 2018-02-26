//
//  HumanFighter.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class HumanFighter: GKEntity {
    
    let mass: CGFloat = 1000
    
    let image = #imageLiteral(resourceName: "test_airplane")
    
    init(entityController: EntityController, propulsionControl: PropulsionControl){
        super.init()
        
        //Set up the visual component of the entity
        let texture = SKTexture(image: image)
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        spriteComponent.node.zRotation = 1.5707963268
        
        //Set up the physics properties of the physics component
        guard let physicsComponent = PhysicsComponent(spriteNode: spriteComponent.node, bodyType: .texture, mass: mass) else {
            fatalError("Cannot initialize HumanFighter without a texture.")
        }
        addComponent(physicsComponent)
        
        //Set up the propulsion component
        guard let propulsionComponent = PropulsionComponent(spriteNode: spriteComponent.node, control: propulsionControl) else {
            fatalError("Could not initialize propulsion for human fighter. This is going to be a real short trip.")
        }
        addComponent(propulsionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//The extension below is for debuging purposes only to make sure the propulsion component works correctly
extension HumanFighter : PropulsionControl {
    
    func shouldApplyThrust() -> Bool {
        return true
    }
    
    func magnitude() -> CGFloat {
        return 1470
    }
    
    
}
