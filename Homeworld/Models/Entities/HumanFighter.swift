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

class HumanFighter: NonDecodableEntity {
    
    let mass: CGFloat = 1000
    
    let image = SKTextureAtlas(named: "red_jet").textureNamed("1")
    
    required init(propulsionControl: PropulsionControl, rotationControl: RotationControl){
        super.init()
        
        //Set up the visual component of the entity
        //let texture = SKTexture(image: image)
        let texture = image
        let size = CGSize(width: texture.size().width/7, height: texture.size().height/7)
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent.init(spriteNode: spriteComponent.node, bodyType: .rectange, mass: mass, collisionCategory: .player)
        addComponent(physicsComponent)
        
        //Set up the propulsion component
        guard let propulsionComponent = PropulsionComponent(spriteNode: spriteComponent.node, control: propulsionControl) else {
            fatalError("Could not initialize propulsion for human fighter. This is going to be a real short trip.")
        }
        addComponent(propulsionComponent)
        
        //Set up the manual rotation component. This will allow the component to be manually rotated in response to a control's state.
        let rotationComponent = ManualRotationComponent(spriteNode: spriteComponent.node, rotationControl: rotationControl)
        addComponent(rotationComponent)
        
        //Give the HumanFighter a set amount of health
        let healthComponent = HealthComponent(health: 200)
        addComponent(healthComponent)
        
        //The human fighter should do damage to entities with which it collides. Still probably not a good idea to collide with things.
        let contactDamageComponent = ContactHealthModifier(changeHealthBy: -50, destroySelf: false, doNotHarm: [.human])
        addComponent(contactDamageComponent)
        
        //Add a passive agent to the fighter.  This will effectively do nothing except allow ai characters driven by agents to easily track it.
        let passiveAgent = PassiveAgent(spriteNode: spriteComponent.node)
        addComponent(passiveAgent)
        
        let weapon = FireProjectileComponent(
            speed: 2000,
            reloadTime: 0.4,
            projectileType: .rocket,
            projectileCategory: .playerProjectile
        )
        addComponent(weapon)
        
        //Give the fighter an airfoil (produces upward velocity from horizontal) so fighter won't fall if it flies sideways.
        let airfoilComponent = AirfoilComponent(physicsBody: physicsComponent.physicsBody, liftRatio: 0.01)
        addComponent(airfoilComponent)
        
        let team = TeamComponent(team: .human)
        addComponent(team)
        
        let animationComponent = AnimatedComponent(spriteAtlas: SKTextureAtlas(named: "red_jet"))
        addComponent(animationComponent)
        
        let rocketEffectComponent = RocketEffectComponent(spriteNode: spriteComponent.node)
        addComponent(rocketEffectComponent)
        
        let impactFeedbackComponent = ImpactFeedbackComponent(feedbackStyle: .heavy)
        addComponent(impactFeedbackComponent)
        
        let explosionConfig = ExplosionConfig(scale: 2, damage: 100, duration: 0.2)
        addComponent(ExplodeOnDeath(config: explosionConfig))
    }
}
