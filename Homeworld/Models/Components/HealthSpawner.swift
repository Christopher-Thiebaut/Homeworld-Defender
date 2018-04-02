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
    let origin: CGPoint
    
    init(origin: CGPoint, baseFrequency: TimeInterval, variability: TimeInterval, healAmount: Int, entityController: EntityController){
        self.baseFrequency = baseFrequency
        self.variability = variability
        self.healAmount = healAmount
        self.entityController = entityController
        self.accumulatedTime = 0
        self.origin = origin
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
        //let sprite = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
        let texture = SKTextureAtlas(named: ResourceNames.mainSpriteAtlasName).textureNamed(ResourceNames.repairToken)
        let sprite = SKSpriteNode(texture: texture, color: .white, size: CGSize(width: 50, height: 50))
        sprite.position = origin
        //sprite.position.y -= 150
        sprite.zPosition = GameScene.ZPositions.low - 1
        let healEntity = HealthPack(sprite: sprite, healAmount: 50, upwardSpeed: 50, entityController: entityController)
        entityController.add(healEntity)
        accumulatedTime = 0
        nextSpawn = getNextSpawnInterval()
    }
    
    private func getNextSpawnInterval() -> TimeInterval {
        return (TimeInterval(GKARC4RandomSource.sharedRandom().nextUniform()) - 0.5) * 2 * variability + baseFrequency
    }
    
}
