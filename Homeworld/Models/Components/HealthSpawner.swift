//
//  EntitySpawner.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthSpawner: NonDecodableComponent {
    
    let baseFrequency: TimeInterval
    let variability: TimeInterval
    let healAmount: Int
    var accumulatedTime: TimeInterval
    var nextSpawn: TimeInterval = 0
    var healthPack: PowerUp?
    
    init(baseFrequency: TimeInterval, variability: TimeInterval, healAmount: Int) {
        self.baseFrequency = baseFrequency
        self.variability = variability
        self.healAmount = healAmount
        self.accumulatedTime = 0
        super.init()
        nextSpawn = getNextSpawnInterval()
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        accumulatedTime += seconds
        guard accumulatedTime > nextSpawn else { return }
        healthPack = PowerUp(effect: .heal(amount: healAmount), upwardSpeed: 50)
        accumulatedTime = 0
        nextSpawn = getNextSpawnInterval()
    }
    
    private func getNextSpawnInterval() -> TimeInterval {
        return (TimeInterval(GKARC4RandomSource.sharedRandom().nextUniform()) - 0.5) * 2 * variability + baseFrequency
    }
    
}
