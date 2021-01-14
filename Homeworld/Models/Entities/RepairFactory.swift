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
        
        //midX and midY are used because we don't know what the anchorpoint of the spritenode is.
        let repairSpawner = HealthSpawner(baseFrequency: baseRepairFrequency, variability: variation, healAmount: restoreHealth)
        addComponent(repairSpawner)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

