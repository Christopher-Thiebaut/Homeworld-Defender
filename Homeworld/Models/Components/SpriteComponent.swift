//
//  SpriteComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, color: UIColor = .white, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: color, size: size)
        super.init()
    }
    
    init(spriteNode: SKSpriteNode, color: UIColor = .white) {
        node = spriteNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
