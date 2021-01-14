//
//  PointsOnDeathComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/14/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class PointsOnDeathComponent: GKComponent {
    var playerPointsOnDeath: Int
    
    init(playerPointsOnDeath: Int) {
        self.playerPointsOnDeath = playerPointsOnDeath
        super.init()
    }
    
    required init?(coder: NSCoder) {
        playerPointsOnDeath = 0
        super.init(coder: coder)
    }
}
