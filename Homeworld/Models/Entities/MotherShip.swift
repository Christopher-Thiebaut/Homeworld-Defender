//
//  AlienInvasion.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/14/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class MotherShip: GKEntity {
    
    let entityController: EntityController
    let textureAtlas = SKTextureAtlas(named: ResourceNames.mainSpriteAtlasName)
    var spriteNode: SKSpriteNode? = nil
    
    init(size: CGSize, position: CGPoint, exits: Int, entityController: EntityController){
        
        self.entityController = entityController
        
        super.init()
        
        let mainPanel = SKSpriteNode(color: .gray, size: size)
        mainPanel.position = position
        
        mainPanel.zPosition = GameScene.ZPositions.high
        
        let spriteComponent = SpriteComponent(spriteNode: mainPanel)
        addComponent(spriteComponent)
        
        spriteNode = spriteComponent.node
        
        let contactDamageComponent = ContactDamageComponent(spriteNode: mainPanel, contactDamage: 1000, destroySelf: false, doNotHarm: [.alien], entityController: entityController)
        addComponent(contactDamageComponent)
        
        mainPanel.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run { [weak self] in
            self?.spawnAliens(timeElapsed: 1)
            }]))) 
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timeSinceAlien: TimeInterval = 100
    private var alienInterval: TimeInterval = 2
    private var totalAliens = 30
    private var aliensSpawned = 0
    private var maxAliens = 30
    private func spawnAliens(timeElapsed dt: TimeInterval) {
        timeSinceAlien += dt
        if timeSinceAlien > alienInterval && aliensSpawned < totalAliens && entityController.getAlienEntities().count < maxAliens {
            timeSinceAlien = 0
            spawnAlien()
            aliensSpawned += 1
        }
        if aliensSpawned >= totalAliens {
            entityController.scene?.finishedSpawningEnemies = true
        }
    }
    var raiderTexture: SKTexture?
    var hunterTexture: SKTexture?
    private func spawnAlien(){
        //let raiderTexture = SKTexture(image: #imageLiteral(resourceName: "enemy01"))
        if self.raiderTexture == nil {
            self.raiderTexture = textureAtlas.textureNamed(ResourceNames.raiderName)
        }
        
        if self.hunterTexture == nil {
            self.hunterTexture = textureAtlas.textureNamed(ResourceNames.hunterName)
        }
        
        let findObstacles = {[weak self] () -> [GKObstacle] in
            if let obstacles = self?.entityController.obstacles {
                return Array(obstacles)
            }else{
                return []
            }
        }
        let findTargets = {[weak self] () -> [GKAgent2D] in
            var targets = [GKAgent2D]()
            if let entityController = self?.entityController {
                targets = Array(entityController.getCivilianTargetAgents())
            }
            return targets
        }
        guard let raiderTexture = raiderTexture else {return}
        guard let hunterTexture = hunterTexture else {return}
        guard let spriteNode = spriteNode else { return }
        guard let player = entityController.playerAgent else {return}
        let alien: GKEntity
        if aliensSpawned%3 == 0 {
            alien = Raider(appearance: raiderTexture, findTargets: findTargets, findObstacles: findObstacles, unlessDistanceAway: 250, entityController: entityController)
        }else{
            alien = Hunter(appearance: hunterTexture, target: player, obstacles: findObstacles(), entityController: entityController)
        }
        alien.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: spriteNode.position.x, y: spriteNode.position.y)
        alien.component(ofType: SpriteComponent.self)?.node.zPosition = GameScene.ZPositions.low
        //raider.component(ofType: RaiderAgent.self)?.position = float2.init(x: Float(size.width/2), y: Float(size.width/2 - 100))
        entityController.add(alien)
    }
    
}
