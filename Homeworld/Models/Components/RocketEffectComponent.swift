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
    
    init(spriteNode: SKSpriteNode, entityController: EntityController) {
        particleEmitter = SKEmitterNode(fileNamed: "RocketFire.sks")
        self.spriteNode = spriteNode

        let rocketAtlas = SKTextureAtlas(named: "rocket")
        let firstTexture = rocketAtlas.textureNamed("1")
        let scale = 10/firstTexture.size().height
        let size = CGSize(width: firstTexture.size().width * scale, height: firstTexture.size().height * scale)
        let fireEntity = GKEntity()
        
        let fireSpriteComponent = SpriteComponent(texture: firstTexture, color: .white, size: size)
        fireEntity.addComponent(fireSpriteComponent)
        
        let fireAnimation = ConstantAnimationComponent(spriteAtlas: rocketAtlas, timePerFrame: 0.1, entityController: entityController)
        fireEntity.addComponent(fireAnimation)
        
        spriteNode.addChild(fireSpriteComponent.node)
        fireSpriteComponent.node.position.x = -spriteNode.size.width/2
        fireSpriteComponent.node.zPosition = -1
        
        entityController.add(fireEntity)
        fireAnimation.runAnimation(loop: true)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
