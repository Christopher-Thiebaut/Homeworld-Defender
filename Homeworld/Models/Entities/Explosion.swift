//
//  Explosion.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class Explosion: GKEntity {
    
    init(scale: CGFloat, textureAtlas: SKTextureAtlas, damage: Int, duration: TimeInterval){
        
        super.init()
        
        let textureAtlas = SKTextureAtlas(named: "explosion")
        let texture = textureAtlas.textureNamed("1")
        let size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        addComponent(spriteComponent)
        
        spriteComponent.node.zPosition = GameScene.ZPositions.high
        
        let explosionAnimation = ConstantAnimationComponent(
            node: spriteComponent.node,
            spriteAtlas: textureAtlas,
            timePerFrame: duration/Double(textureAtlas.textureNames.count)
        )
        addComponent(explosionAnimation)
        explosionAnimation.runAnimation()
        if UserData.currentUser.wantsSoundEffects {
            spriteComponent.node.run(SKAction.playSoundFileNamed(ResourceNames.Sounds.smallExplosion, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
