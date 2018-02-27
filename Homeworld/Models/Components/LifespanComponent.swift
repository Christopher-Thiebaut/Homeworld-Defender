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
class LifespanComponent: GKComponent {
    
    let lifespan: TimeInterval
    let entityController: EntityController
    var elapsedTime: TimeInterval = 0
    
    init(lifespan: TimeInterval, entityController: EntityController){
        self.lifespan = lifespan
        self.entityController = entityController
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        elapsedTime += seconds
        if elapsedTime >= lifespan, let expiredEntity = entity {
            entityController.remove(expiredEntity)
        }
    }
}
