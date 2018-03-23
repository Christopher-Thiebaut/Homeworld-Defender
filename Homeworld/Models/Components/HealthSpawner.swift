//
//  EntitySpawner.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/22/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthSpawner: GKComponent {
    
    let baseFrequency: TimeInterval
    let variability: TimeInterval
    let healAmount: Int
    let entityController: EntityController
    var accumulatedTime: TimeInterval
    var nextSpawn: TimeInterval = 0
    
    init(origin: CGPoint, baseFrequency: TimeInterval, variability: TimeInterval, healAmount: Int, entityController: EntityController){
        self.baseFrequency = baseFrequency
        self.variability = variability
        self.healAmount = healAmount
        self.entityController = entityController
        self.accumulatedTime = 0
        super.init()
        nextSpawn = getNextSpawnInterval()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        accumulatedTime += seconds
        guard accumulatedTime > nextSpawn else { return }
        let healEntity = HealthPack(sprite: SKSpriteNode.init(color: .white, size: CGSize(width: 50, height: 50)), healAmount: 50, upwardSpeed: 50, entityController: entityController)
        healEntity.component(ofType: SpriteComponent.self)?.node.zPosition = GameScene.ZPositions.medium
        entityController.add(healEntity)
        accumulatedTime = 0
        nextSpawn = getNextSpawnInterval()
    }
    
    private func getNextSpawnInterval() -> TimeInterval {
        return (TimeInterval(GKARC4RandomSource.sharedRandom().nextUniform()) - 0.5) * 2 * variability + baseFrequency
    }
    
}
