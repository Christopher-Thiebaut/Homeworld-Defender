//
//  PassiveObstacleComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class PassiveObstacleComponent: GKComponent {
    
    let obstacle: GKCircleObstacle
    
    init(radius: CGFloat, position: CGPoint){
        obstacle = GKCircleObstacle(radius: Float(radius))
        obstacle.position.x = Float(position.x)
        obstacle.position.y = Float(position.y)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}