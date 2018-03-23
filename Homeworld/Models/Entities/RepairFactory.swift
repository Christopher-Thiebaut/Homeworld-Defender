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
    
    init(spriteNode: SKSpriteNode, health: Int, baseRepairFrequency: TimeInterval, variation: TimeInterval, restoreHealth: Int, entityController: EntityController){
        
        super.init(spriteNode: spriteNode, health: health, entityController: entityController)
        
        let repairSpawner = HealthSpawner(origin: spriteNode.position, baseFrequency: baseRepairFrequency, variability: variation, healAmount: restoreHealth, entityController: entityController)
        addComponent(repairSpawner)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

