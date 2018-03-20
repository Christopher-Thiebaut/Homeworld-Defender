//
//  CollisionAvoidanceBehavior.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class CollisionAvoidanceBehavior: GKBehavior {
    
    init(collisionRisks: [GKAgent2D]) {
        super.init()
        setWeight(1, for: GKGoal(toAvoid: collisionRisks, maxPredictionTime: 1))
    }
    
}
