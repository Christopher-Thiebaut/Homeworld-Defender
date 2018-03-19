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
    
    weak var gameScene: GameScene?
    
    var deathEffect: () -> ()
    
    init(gameScene: GameScene, deathEffect: @escaping () -> ()) {
        self.gameScene = gameScene
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
