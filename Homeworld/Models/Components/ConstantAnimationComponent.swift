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
    private let node: SKSpriteNode
    
    init(node: SKSpriteNode, spriteAtlas: SKTextureAtlas, timePerFrame: TimeInterval) {
        textures = spriteAtlas
        self.timePerFrame = timePerFrame
        self.node = node
        for index in 1...spriteAtlas.textureNames.count {
            frames.append(textures.textureNamed("\(index)"))
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runAnimation(loop: Bool = false) {
        let animation = SKAction.animate(with: frames, timePerFrame: timePerFrame)
        if loop {
            node.run(SKAction.repeatForever(animation))
        } else {
            let remove = SKAction.run { [weak self] in
                self?.entity?.addComponent(Tombstone())
            }
            node.run(SKAction.sequence([animation, remove]))
        }
        
    }
    
}
