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

class Explosion: GKEntity {
    
    init(scale: CGFloat, textureAtlas: SKTextureAtlas, damage: Int, duration: TimeInterval, entityController: EntityController){
        
        super.init()
        
        let textureAtlas = SKTextureAtlas(named: "explosion")
        let texture = textureAtlas.textureNamed("1")
        let size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        addComponent(spriteComponent)
        
        let explosionAnimation = ConstantAnimationComponent(spriteAtlas: textureAtlas, timePerFrame: duration/Double(textureAtlas.textureNames.count), entityController: entityController)
        addComponent(explosionAnimation)
        explosionAnimation.explosionAnimation()
        
//        let lifespanComponent = LifespanComponent(lifespan: duration, entityController: entityController)
//        addComponent(lifespanComponent)
        
//        let contactDamageComponent = ContactDamageComponent(spriteNode: spriteComponent.node, contactDamage: damage, destroySelf: false, doNotHarm: [], entityController: entityController)
//        addComponent(contactDamageComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
