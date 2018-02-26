//
//  HealthComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class HealthComponent: GKComponent {
    
    var health: Int
    weak var entityController: EntityController?
    
    init(health: Int,entityController: EntityController) {
        self.health = health
        self.entityController = entityController
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeDamage(_ damage: Int){
        health -= damage
        if let entity = self.entity, health < 0 {
            entityController?.remove(entity)
        }
    }
    
}
