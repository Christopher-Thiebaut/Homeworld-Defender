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
    
    required init(entityController: EntityController, propulsionControl: PropulsionControl, rotationControl: RotationControl){
        super.init()
        
        //Set up the visual component of the entity
        let texture = SKTexture(image: image)
        let size = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        
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
        
        //Set up the manual rotation component. This will allow the component to be manually rotated in response to a control's state.
        let rotationComponent = ManualRotationComponent(spriteNode: spriteComponent.node, rotationControl: rotationControl)
        addComponent(rotationComponent)
        
        //Give the HumanFighter a MapWrappingComponent so that if it leaves the map, it will re-enter from the other side.
//        guard let scene = entityController.scene else { fatalError("Tried to do setup from entityController with no scene.") }
//        let mapWrappingComponent = MapWrappingComponent(spriteNode: spriteComponent.node, scene: scene)
//        addComponent(mapWrappingComponent)
        
        //Give the HumanFighter a set amount of health
        let healthComponent = HealthComponent(health: 10000000, entityController: entityController)
        addComponent(healthComponent)
        
        //The human fighter should do damage to entities with which it collides. Still probably not a good idea to collide with things.
        let contactDamageComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: 50, destroySelf: false, entityController: entityController)
        addComponent(contactDamageComponent)
        
        //Add a passive agent to the fighter.  This will effectively do nothing except allow ai characters driven by agents to easily track it.
        let passiveAgent = PassiveAgent(spriteNode: spriteComponent.node)
        addComponent(passiveAgent)
        
        
        //Set up the fighter's rocket launcher
        let projectileTexture = SKTexture(image: #imageLiteral(resourceName: "missile"))
        let projectileSize = CGSize(width: projectileTexture.size().width/5, height: projectileTexture.size().height/5)
        let fireComponent = FireProjectileComponent(projectileTexture: projectileTexture, size: projectileSize, damage: 50, speed: 1000,reloadTime: 1, entityController: entityController)
        addComponent(fireComponent)
        
        //Give this entity a camera component that will be the scene's camera and follow this entity
//        let cameraComponent = CameraComponent(spriteNodeToFollow: spriteComponent.node, scene: scene)
//        addComponent(cameraComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
