//
//  PhysicsComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class PhysicsComponent: GKComponent {
    
    enum BodyType {
        case rectange
        case circle
        case texture
    }
    
    enum CollisionCategory: UInt32 {
        case player = 1
        case playerProjectile = 2
        case humanAI = 4
        case alien = 8
        case alienProjectile = 16
        case environment = 32
    }
    
    private let collideWithAllCategories = CollisionCategory.player.rawValue + CollisionCategory.playerProjectile.rawValue + CollisionCategory.humanAI.rawValue + CollisionCategory.alien.rawValue + CollisionCategory.alienProjectile.rawValue + CollisionCategory.environment.rawValue
    
    var physicsBody: SKPhysicsBody
    
    init?(spriteNode: SKSpriteNode, bodyType: BodyType, mass: CGFloat, affectedByGravity: Bool = true, collisionCategory: CollisionCategory){
        let center = CGPoint(x: spriteNode.size.width/2, y: spriteNode.size.height/2)
        switch bodyType {
        case .rectange:
            physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size, center: center)
        case .circle:
            physicsBody = SKPhysicsBody(circleOfRadius: spriteNode.size.width/2, center: center)
        case .texture:
            guard let texture = spriteNode.texture else {
                NSLog("Cannot initialize SKPhysics body for PhysicsComponent with texture because the provided SKSpriteNode has no texture.")
                return nil
            }
            physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.05, size: spriteNode.size)
        }
        physicsBody.mass = mass
        spriteNode.physicsBody = physicsBody
        physicsBody.affectedByGravity = affectedByGravity
        physicsBody.linearDamping = 1
        super.init()
        setCollisionCategory(collisionCategory)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollisionCategory(_ category: CollisionCategory){
        physicsBody.categoryBitMask = category.rawValue
        switch category {
        case .player:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.player.rawValue - CollisionCategory.playerProjectile.rawValue
        case .playerProjectile:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.player.rawValue - CollisionCategory.playerProjectile.rawValue - CollisionCategory.alien.rawValue
        case .humanAI:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.humanAI.rawValue
        case .alien:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.alien.rawValue - CollisionCategory.alienProjectile.rawValue
        case .alienProjectile:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.alien.rawValue - CollisionCategory.alienProjectile.rawValue
        case .environment:
            physicsBody.collisionBitMask = collideWithAllCategories

        }
    }
    
}
