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
    let projectileCategory: PhysicsComponent.CollisionCategory
    let allies: TeamComponent.Team?
    let firesRockets: Bool
    
    init(projectileTexture: SKTexture, size: CGSize, damage: Int, speed: CGFloat, reloadTime: TimeInterval, projectileCategory: PhysicsComponent.CollisionCategory, allies: TeamComponent.Team?, firesRockets: Bool = false,entityController: EntityController){
        self.reloadTime = reloadTime
        self.timeSinceLastFired = reloadTime + 1
        self.texture = projectileTexture
        self.size = size
        self.speed = speed
        self.entityController = entityController
        self.projectileCategory = projectileCategory
        self.allies = allies
        self.firesRockets = firesRockets
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
        
        let projectile = Projectile(velocity: velocity, texture: texture, size: size, oneHit: true, allies: allies, collisionCategory: projectileCategory, isRocket: firesRockets ,entityController: entityController)
        projectile.component(ofType: SpriteComponent.self)?.node.position = spriteNode.position
        projectile.component(ofType: SpriteComponent.self)?.node.zRotation = spriteNode.zRotation
        entityController.add(projectile)
    }
    
}
