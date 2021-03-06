//
//  PassiveAgent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

///The PassiveAgent has no agency.  It follows its sprite around and exists so that its entity can be targeted or followed by other agents. Intended to be used for the entity representing the player character.  Can also be used for buildings or other passive objects that can be targeted.
class PassiveAgent: GKAgent2D {
    
    let spriteNode: SKSpriteNode
    
    init(spriteNode: SKSpriteNode){
        self.spriteNode = spriteNode
        super.init()
        self.mass = 0.001
        self.maxSpeed = Float.greatestFiniteMagnitude
        self.maxAcceleration = Float.greatestFiniteMagnitude
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self.position = SIMD2(x: spriteNode.position.x.float, y: spriteNode.position.y.float)
    }
}

extension CGFloat {
    var float: Float {
        Float(self)
    }
}
