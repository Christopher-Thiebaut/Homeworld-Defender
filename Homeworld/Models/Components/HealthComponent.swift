//
//  HealthComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

class HealthComponent: NonDecodableComponent {
    
    var health: Int
    var fullHealth: Int
    
    init(health: Int) {
        self.fullHealth = health
        self.health = health
        
        super.init()
    }

    func changeHealthBy(_ amount: Int){
        health += amount
        health = min(health, fullHealth)
        entity?.component(ofType: ImpactFeedbackComponent.self)?.impactDetected()
        if health <= 0 {
            entity?.addComponent(Tombstone())
        }
    }
    
}

extension HealthComponent: PercentageBarQuantity {
    var quantityRemaining: CGFloat {
        return CGFloat(health)
    }
    
    var maximumQuantity: CGFloat {
        return CGFloat(fullHealth)
    }
    
    
}
