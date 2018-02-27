//
//  FireComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit



class FireProjectileComponent: GKComponent {
    
    let entityController: EntityController
    let speed: CGFloat
    let texture: SKTexture
    
    //TODO: Make this so that if the user presses a button, the update cycle of this causes a damaging projectile to move in the direction the entity's sprite is facing.
    init(projectileTexture: SKTexture, damage: Int, speed: CGFloat, entityController: EntityController){
        self.texture = projectileTexture
        self.speed = speed
        self.entityController = entityController
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(){
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("She cannot fire while she's cloaked.")
            return
        }
        
        let angle = Float(spriteNode.zRotation)
        let dx = CGFloat(cosf(angle))
        let dy = CGFloat(sinf(angle))
        
        let velocity = CGVector(dx: dx * speed, dy: dy * speed)
        
        var immuneEntities: Set<GKEntity> = []
        if let ownEntity = self.entity {
            immuneEntities.insert(ownEntity)
        }
        
        let projectile = Projectile(velocity: velocity, texture: texture, oneHit: true, immuneEntities: immuneEntities, entityController: entityController)
        projectile.component(ofType: SpriteComponent.self)?.node.position = spriteNode.position
        projectile.component(ofType: SpriteComponent.self)?.node.zRotation = spriteNode.zRotation
        entityController.add(projectile)
    }
    
}
