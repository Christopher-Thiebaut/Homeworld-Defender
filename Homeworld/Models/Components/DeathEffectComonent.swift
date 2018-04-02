//
//  ScoreDeathComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class DeathEffectComonent: GKComponent {
    
    var deathEffect: () -> ()
    
    init(deathEffect: @escaping () -> ()) {
        self.deathEffect = deathEffect
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDeathEffect(){
        deathEffect()
    }
    
}
