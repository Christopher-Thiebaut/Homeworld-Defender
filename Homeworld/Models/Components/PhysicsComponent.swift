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
    
    
    
    var physicsBody: SKPhysicsBody
    
    init?(spriteNode: SKSpriteNode, bodyType: BodyType, mass: CGFloat, affectedByGravity: Bool = true, categoryBitmask: UInt32 = 0){
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
            physicsBody.contactTestBitMask = 0
        }
        physicsBody.mass = mass
        physicsBody.categoryBitMask = categoryBitmask
        spriteNode.physicsBody = physicsBody
        physicsBody.affectedByGravity = affectedByGravity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
