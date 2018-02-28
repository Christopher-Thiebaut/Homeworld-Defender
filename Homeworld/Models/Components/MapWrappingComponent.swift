//
//  MapWrappingComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

///Entities with a map wrapping component will check their position every update and, if they have left the scene's visible area, will reappear on the opposite side from which they left.
class MapWrappingComponent: GKComponent {
    
    weak var scene: GameScene?
    var spriteNode: SKSpriteNode
    
    init(spriteNode: SKSpriteNode, scene: GameScene){
        self.spriteNode = spriteNode
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let scene = scene else {
            fatalError("MapWrappingCompoenent does not have a scene.")
        }
        if spriteNode.position.x > scene.maxX + spriteNode.size.width/2 {
            spriteNode.position.x = scene.minX + spriteNode.size.width/2
        }else if spriteNode.position.x < scene.minX {
            spriteNode.position.x = scene.maxX - spriteNode.size.width/2
        }
    }
}
