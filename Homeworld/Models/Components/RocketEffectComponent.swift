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

class RocketEffectComponent: NonDecodableComponent {
    
    let particleEmitter: SKEmitterNode?
    let spriteNode: SKSpriteNode
    private var animationRunning = false
    
    init(spriteNode: SKSpriteNode) {
        particleEmitter = SKEmitterNode(fileNamed: "RocketFire.sks")
        self.spriteNode = spriteNode
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        guard !animationRunning else { return }
        createAnimation()
    }
    
    private func createAnimation() {
        guard let entity = entity else { return }
        animationRunning = true
        let rocketAtlas = SKTextureAtlas(named: "rocket")
        let firstTexture = rocketAtlas.textureNamed("1")
        let scale = 10/firstTexture.size().height
        let size = CGSize(width: firstTexture.size().width * scale, height: firstTexture.size().height * scale)
        
        let fire = SKSpriteNode(
            texture: firstTexture,
            color: .white,
            size: size
        )
        
        let fireAnimation = ConstantAnimationComponent(
            node: fire,
            spriteAtlas: rocketAtlas,
            timePerFrame: 0.1
        )
        entity.addComponent(fireAnimation)
        
        spriteNode.addChild(fire)
        fire.position.x = -spriteNode.size.width/2
        fire.zPosition = -1
        
        fireAnimation.runAnimation(loop: true)
    }
}
