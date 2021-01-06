//
//  RepairFactory.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class RepairFactory: Building {
    
    init(spriteNode: SKSpriteNode, health: Int, baseRepairFrequency: TimeInterval, variation: TimeInterval, restoreHealth: Int, entityController: EntityController, gameScene: GameScene){
        
        super.init(spriteNode: spriteNode, health: health)
        
        //midX and midY are used because we don't know what the anchorpoint of the spritenode is.
        let repairSpawner = HealthSpawner(origin: CGPoint.init(x: spriteNode.frame.midX, y: spriteNode.frame.midY), baseFrequency: baseRepairFrequency, variability: variation, healAmount: restoreHealth, entityController: entityController, gameScene: gameScene)
        addComponent(repairSpawner)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

