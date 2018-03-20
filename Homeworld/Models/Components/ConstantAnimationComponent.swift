//
//  ConstantAnimationComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ConstantAnimationComponent: GKComponent {
    
    let textures: SKTextureAtlas
    let timePerFrame: TimeInterval
    var accumulatedTime: TimeInterval = 0
    var frames: [SKTexture] = []
    let entityController: EntityController
    
    init(spriteAtlas: SKTextureAtlas, timePerFrame: TimeInterval, entityController: EntityController){
        textures = spriteAtlas
        self.timePerFrame = timePerFrame
        self.entityController = entityController
        for index in 1...spriteAtlas.textureNames.count {
            frames.append(textures.textureNamed("\(index)"))
        }
        super.init()
       // explosionAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func explosionAnimation() {
        guard let entity = entity, let spriteNode = entity.component(ofType: SpriteComponent.self)?.node else {return}
        spriteNode.run(SKAction.sequence([SKAction.animate(with: frames, timePerFrame: timePerFrame), SKAction.run({[weak self] in self?.entityController.remove(entity)})]))
    }
    
//    override func update(deltaTime seconds: TimeInterval) {
//        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node, let existingTexture = spriteNode.texture else { return }
//        super.update(deltaTime: seconds)
//        accumulatedTime += seconds
//        let frameNumber = Int(accumulatedTime/timePerFrame)
//        let frameTexture = textures.textureNamed("\(frameNumber)")
//        let scale = spriteNode.size.width/existingTexture.size().width
//        let size = CGSize(width: frameTexture.size().width * scale, height: frameTexture.size().height * scale)
//        spriteNode.texture = frameTexture
//        spriteNode.size = size
//    }
    
    
}
