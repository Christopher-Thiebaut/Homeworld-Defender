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
    let spriteNode: SKSpriteNode
    
    init(spriteNode: SKSpriteNode, scene: GameScene) {
        particleEmitter = SKEmitterNode(fileNamed: "RocketFire.sks")
        self.spriteNode = spriteNode
        if particleEmitter == nil {
            NSLog("Failed to initialize particle emitter for rocket effect.")
        }
        if let emitter = particleEmitter {
            scene.addChild(emitter)
            emitter.zPosition = spriteNode.zPosition - 1
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let desiredDistance = spriteNode.size.width/2 - spriteNode.size.width/10
        let angle = Float(spriteNode.zRotation)
        let dx = CGFloat(cosf(angle))
        let dy = CGFloat(sinf(angle))
        particleEmitter?.position = CGPoint(x: spriteNode.position.x - dx * desiredDistance, y: spriteNode.position.y - dy * desiredDistance)
        particleEmitter?.zRotation = spriteNode.zRotation
    }
    
}
