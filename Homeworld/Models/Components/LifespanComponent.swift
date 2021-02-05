//
//  LifespanComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/27/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

///Entities with this component will be removed after their specified lifespan is over.  Good for things like projectiles that will be spawned a lot and should have their impact on gameplay quickly.
class LifespanComponent: NonDecodableComponent {
    
    let lifespan: TimeInterval
    var elapsedTime: TimeInterval = 0
    
    init(lifespan: TimeInterval){
        self.lifespan = lifespan
        super.init()
    }

    override func update(deltaTime seconds: TimeInterval) {
        elapsedTime += seconds
        if elapsedTime >= lifespan {
            entity?.addComponent(Tombstone())
        }
    }
}
