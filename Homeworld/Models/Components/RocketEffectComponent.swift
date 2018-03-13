//
//  RocketEffectComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/13/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class RocketEffectComponent: GKComponent {
    
    let particleEmitter: SKEmitterNode?
    
    init(spriteNode: SKSpriteNode) {
        particleEmitter = SKEmitterNode(fileNamed: "RocketFire.sks")
        if particleEmitter == nil {
            NSLog("Failed to initialize particle emitter for rocket effect.")
        }
        particleEmitter?.targetNode = spriteNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
}
