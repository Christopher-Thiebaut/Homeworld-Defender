//
//  ChaseBehavior.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class ChaseBehavior: GKBehavior {
    
    init(targetSpeed: Float, seek: GKAgent){
        super.init()
        if targetSpeed > 0 {
            setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
            setWeight(0.9, for: GKGoal(toSeekAgent: seek))
            //setWeight(1, for: GKGoal(toInterceptAgent: seek, maxPredictionTime: 0.5))
        }
    }
}
