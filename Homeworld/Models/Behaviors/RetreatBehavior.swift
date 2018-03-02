//
//  RetreatBehavior.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class RetreatBehavior: GKBehavior {
    
    init(targetSpeed: Float, avoid: GKAgent2D){
        super.init()
        setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
        setWeight(0.9, for: GKGoal(toFleeAgent: avoid))
    }
}
