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
    
    init(spriteNode: SKSpriteNode, health: Int, baseRepairFrequency: TimeInterval, variation: TimeInterval, restoreHealth: Int){
        
        super.init(spriteNode: spriteNode, health: health)
        let repairSpawner = HealthSpawner(baseFrequency: baseRepairFrequency, variability: variation, healAmount: restoreHealth)
        addComponent(repairSpawner)

    }
}

