//
//  PhysicsComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class PhysicsComponent: NonDecodableComponent {
    
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
        case powerUp = 64
    }
    
    private var spriteNode: SKSpriteNode
    private var bodyType: BodyType
    private var mass: CGFloat
    private var affectedByGravity: Bool
    private var collisionCategory: CollisionCategory
    
    private let collideWithAllCategories = CollisionCategory.player.rawValue + CollisionCategory.playerProjectile.rawValue + CollisionCategory.humanAI.rawValue + CollisionCategory.alien.rawValue + CollisionCategory.alienProjectile.rawValue + CollisionCategory.environment.rawValue + CollisionCategory.powerUp.rawValue
    
    var physicsBody: SKPhysicsBody
    
    init(spriteNode: SKSpriteNode, bodyType: BodyType, mass: CGFloat, affectedByGravity: Bool = true, collisionCategory: CollisionCategory){
        
        self.spriteNode = spriteNode
        self.bodyType = bodyType
        self.mass = mass
        self.affectedByGravity = affectedByGravity
        self.collisionCategory = collisionCategory
        physicsBody = SKPhysicsBody()
        super.init()
        setupPhysicsBody()
    }

    func setupPhysicsBody(){
        let velocity = physicsBody.velocity
        let center = CGPoint(x: 0, y: 0)
        switch bodyType {
        case .rectange:
            physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size, center: center)
        case .circle:
            physicsBody = SKPhysicsBody(circleOfRadius: spriteNode.size.width/2, center: center)
        case .texture:
            guard let texture = spriteNode.texture else {
                NSLog("Cannot initialize SKPhysics body for PhysicsComponent with texture because the provided SKSpriteNode has no texture.")
                return
            }
            physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.05, size: spriteNode.size)
        }
        physicsBody.mass = mass
        spriteNode.physicsBody = physicsBody
        physicsBody.affectedByGravity = affectedByGravity
        physicsBody.linearDamping = 1
        physicsBody.velocity = velocity
        setCollisionCategory(collisionCategory)
    }
    
    func setCollisionCategory(_ category: CollisionCategory){
        physicsBody.categoryBitMask = category.rawValue
        switch category {
        case .player:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.player.rawValue - CollisionCategory.playerProjectile.rawValue - CollisionCategory.powerUp.rawValue
        case .playerProjectile:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.player.rawValue - CollisionCategory.playerProjectile.rawValue - CollisionCategory.powerUp.rawValue
        case .humanAI:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.humanAI.rawValue - CollisionCategory.powerUp.rawValue
        case .alien:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.alien.rawValue - CollisionCategory.alienProjectile.rawValue - CollisionCategory.powerUp.rawValue
        case .alienProjectile:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.alien.rawValue - CollisionCategory.alienProjectile.rawValue - CollisionCategory.powerUp.rawValue
        case .environment:
            physicsBody.collisionBitMask = collideWithAllCategories - CollisionCategory.environment.rawValue - CollisionCategory.powerUp.rawValue 
        case .powerUp:
            physicsBody.collisionBitMask = 0

        }
        //Notify of all collisions, except if it is a powerup. Powerups should only interact with the player
        physicsBody.contactTestBitMask = category == .powerUp ? CollisionCategory.player.rawValue : physicsBody.collisionBitMask
        
    }
    
}
