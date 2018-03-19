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
    
    init(spriteAtlas: SKTextureAtlas, timePerFrame: TimeInterval){
        textures = spriteAtlas
        self.timePerFrame = timePerFrame
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        accumulatedTime += seconds
        let frameNumber = Int(accumulatedTime/timePerFrame)
        entity?.component(ofType: SpriteComponent.self)?.node.texture = textures.textureNamed("\(frameNumber)")
    }
    
    
}
