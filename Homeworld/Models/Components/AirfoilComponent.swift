//
//  AirfoilComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/9/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AirfoilComponent: NonDecodableComponent {
    
    let physicsBody: SKPhysicsBody
    let liftRatio: CGFloat
    
    init(physicsBody: SKPhysicsBody, liftRatio: CGFloat){
        self.physicsBody = physicsBody
        self.liftRatio = liftRatio
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        var velocity = physicsBody.velocity
        velocity.dy += liftRatio * abs(velocity.dx)
        physicsBody.velocity = velocity
    }
}
