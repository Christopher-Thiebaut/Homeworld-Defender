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
    let size: CGSize
    let position: CGPoint
    let gameScene: GameScene
    
    init(
        size: CGSize,
        position: CGPoint,
        exits: Int,
        entityController: EntityController,
        gameScene: GameScene
    ){
        
        self.entityController = entityController
        self.size = size
        self.position = position
        self.gameScene = gameScene
        
        super.init()
        
        let mainPanel = SKSpriteNode(color: UIColor.green.withAlphaComponent(0.4), size: size)
        mainPanel.position = position
        
        mainPanel.zPosition = GameScene.ZPositions.high
        
        let spriteComponent = SpriteComponent(spriteNode: mainPanel)
        addComponent(spriteComponent)
        
        spriteNode = spriteComponent.node
        
        addTiledTexture()
        
        let contactDamageComponent = ContactHealthModifier(changeHealthBy: -1000, destroySelf: false, doNotHarm: [.alien])
        addComponent(contactDamageComponent)
        
        let physicsComponent = PhysicsComponent(spriteNode: mainPanel, bodyType: .rectange, mass: 0, affectedByGravity: false, collisionCategory: .alien)
        physicsComponent.physicsBody.isDynamic = false
        addComponent(physicsComponent)
        
        mainPanel.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run { [weak self] in
            self?.spawnAliens(timeElapsed: 1)
            }]))) 
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timeSinceAlien: TimeInterval = 100
    private var alienInterval: TimeInterval = 2
    private var totalAliens = 100
    private var aliensSpawned = 0
    private var maxAliens = 30
    private func spawnAliens(timeElapsed dt: TimeInterval) {
        timeSinceAlien += dt
        if timeSinceAlien > alienInterval && aliensSpawned < totalAliens && entityController.getAlienEntities().count < maxAliens {
            timeSinceAlien = 0
            spawnAlien()
            aliensSpawned += 1
            if aliensSpawned%10 == 0 && alienInterval > 0.5 {
                alienInterval -= 0.25
            }
        }
        if aliensSpawned >= totalAliens {
            gameScene.finishedSpawningEnemies = true
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
        let getPlayer = {[weak self] () -> [GKAgent2D] in
            var agentArray: [GKAgent2D] = []
            if let player = self?.entityController.playerAgent { agentArray.append(player) }
            return agentArray
        }
        let alien: GKEntity
        if aliensSpawned%3 == 0 {
            alien = Raider(
                appearance: raiderTexture,
                findTargets: findTargets,
                findObstacles: findObstacles,
                unlessDistanceAway: 250,
                entityController: entityController,
                gameScene: gameScene
            )
        }else{
            alien = Raider(
                appearance: hunterTexture,
                findTargets: getPlayer,
                findObstacles: findObstacles,
                unlessDistanceAway: 100,
                entityController: entityController,
                gameScene: gameScene
            )
        }
        let doorWidth: CGFloat = 200
        let xPositionOffset = CGFloat(GKARC4RandomSource.sharedRandom().nextUniform() - 0.5) * doorWidth
        alien.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: spriteNode.position.x + xPositionOffset, y: spriteNode.position.y)
        alien.component(ofType: SpriteComponent.self)?.node.zPosition = GameScene.ZPositions.low
        //raider.component(ofType: RaiderAgent.self)?.position = float2.init(x: Float(size.width/2), y: Float(size.width/2 - 100))
        entityController.add(alien)
    }
    
    private func addTiledTexture() {
        let texture = textureAtlas.textureNamed(ResourceNames.mothershipTexture)
        let scale = (size.height - size.height/4)/texture.size().height
        let tileSize = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
        var tiledTextureWidth: CGFloat = 0
        var nextTilePosition = CGPoint(x: position.x - size.width/2 + tileSize.width/2, y: 0)
        while tiledTextureWidth < size.width {
            let tile = SKSpriteNode(texture: texture, color: .white, size: tileSize)
            tile.position = nextTilePosition
            spriteNode?.addChild(tile)
            tile.zPosition -= GameScene.ZPositions.low //This is so that the total z-index of the tiles will match an existing level and not need a separate drawing pass.
            tiledTextureWidth += tileSize.width
            nextTilePosition.x += tileSize.width
        }
    }
}
