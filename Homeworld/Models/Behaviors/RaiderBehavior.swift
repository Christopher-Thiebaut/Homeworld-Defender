//
//  RaiderBehavior.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class RaiderBehavior: GKBehavior {
    
    let targetStalkingRange: Float = 100
    
    ///This behavior is designed to cause an agent to try to remain close to its targets while avoiding certain other agent. Typical use would be to tell it to remain close to vulnerable targets (which the agent could attack) while avoiding dangerous ones.
    init(targetSpeed: Float, targets: [GKAgent2D], avoid: [GKAgent2D], distanceFromAvoidTargets: Float){
        super.init()
        if targetSpeed > 0 {
            setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
            setWeight(0.5, for: GKGoal(toCohereWith: targets, maxDistance: targetStalkingRange, maxAngle: 2))
            //setWeight(1, for: GKGoal(toSeparateFrom: avoid, maxDistance: distanceFromAvoidTargets, maxAngle: 2))
        }
    }
}
