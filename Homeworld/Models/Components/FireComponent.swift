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
    let size: CGSize
    let reloadTime: TimeInterval
    var timeSinceLastFired: TimeInterval
    
    //TODO: Make this so that if the user presses a button, the update cycle of this causes a damaging projectile to move in the direction the entity's sprite is facing.
    init(projectileTexture: SKTexture, size: CGSize, damage: Int, speed: CGFloat, reloadTime: TimeInterval, entityController: EntityController){
        self.reloadTime = reloadTime
        self.timeSinceLastFired = reloadTime + 1
        self.texture = projectileTexture
        self.size = size
        self.speed = speed
        self.entityController = entityController
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        timeSinceLastFired += seconds
    }
    
    func fire(){
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("She cannot fire while she's cloaked.")
            return
        }
        
        guard timeSinceLastFired > reloadTime else {
            return
        }
        
        timeSinceLastFired = 0
        
        let angle = Float(spriteNode.zRotation)
        let dx = CGFloat(cosf(angle))
        let dy = CGFloat(sinf(angle))
        
        let velocity = CGVector(dx: dx * speed, dy: dy * speed)
        
        var immuneEntities: Set<GKEntity> = []
        if let ownEntity = self.entity {
            immuneEntities.insert(ownEntity)
        }
        
        let projectile = Projectile(velocity: velocity, texture: texture, size: size, oneHit: true, immuneEntities: immuneEntities, entityController: entityController)
        projectile.component(ofType: SpriteComponent.self)?.node.position = spriteNode.position
        projectile.component(ofType: SpriteComponent.self)?.node.zRotation = spriteNode.zRotation
        entityController.add(projectile)
    }
    
}
