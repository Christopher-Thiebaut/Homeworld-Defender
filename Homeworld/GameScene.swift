//
//  GameScene.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/24/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityController: EntityController!
    var lastUpdateTimeInterval: TimeInterval = 0
    ///The floor is what should be consider "ground level" for most game elements, but will not usually be 0 at runtime because the control nodes are below the "floor"
    var floorLevel: CGFloat = 0
    
    override func didMove(to view: SKView) {
        entityController = EntityController(scene: self)
        
        
        let joyStickWidth = size.width/5
        
        let joyStickSize = CGSize(width: joyStickWidth, height: joyStickWidth)
        let joyStick = JoystickNode(size: joyStickSize)
        joyStick.position = CGPoint(x: joyStickWidth/2 + 10, y: joyStickWidth/2 + 10)
        addChild(joyStick)
        
        let humanFighter = HumanFighter(entityController: entityController, propulsionControl: joyStick, rotationControl: joyStick)
        if let humanSpriteComponent = humanFighter.component(ofType: SpriteComponent.self) {
            humanSpriteComponent.node.position = CGPoint(x: size.width/2, y: size.height/2)
        }
        entityController.add(humanFighter)
        
        //TODO: Refactor so that the controls can be added before the fighter. There should be a base scene that all levels inherit from that adds the controls.
        let buttonTexture = SKTexture(image: #imageLiteral(resourceName: "red_button"))
        let fireButton = ButtonNode(texture: buttonTexture, size: joyStickSize) {
            if let fireComponent = humanFighter.component(ofType: FireProjectileComponent.self){
                fireComponent.fire()
            }
        }
        fireButton.position = CGPoint(x: size.width - joyStickWidth/2 - 10, y: joyStickWidth/2 + 10)
        addChild(fireButton)
        
        let floor = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: joyStick.frame.maxY + 5), to: CGPoint(x: frame.maxX, y: joyStick.frame.maxY + 5))
        self.physicsBody = floor
        
        floorLevel = joyStick.frame.maxY + 5
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        buildDemoCity(buildingWidth: 30)
        
        
        let wait = SKAction.wait(forDuration: 4)
        self.run(wait)
        run(SKAction.sequence([wait, SKAction.run {[weak self] in
            self?.spawnRaider()
            }]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        entityController.update(dt)
    }
    
    private func addDemoMissile(target: GKAgent2D){
        let demoMissile = GuidedMissile.init(target: target, entityController: entityController)
        if let demoMissileSpriteComponent = demoMissile.component(ofType: SpriteComponent.self) {
            demoMissileSpriteComponent.node.position = CGPoint(x: size.width, y: demoMissileSpriteComponent.node.size.height/2)
        }
        entityController.add(demoMissile)
    }
    
    private func buildDemoCity(buildingWidth: CGFloat){
        let buildingTexture = SKTexture(image: #imageLiteral(resourceName: "basic_building"))
        let scale = buildingWidth/buildingTexture.size().width
        let buildingSize = CGSize(width: buildingTexture.size().width * scale, height: buildingTexture.size().height * scale)
        let spaceBetweenBuildings: CGFloat = buildingWidth/5
        var lastBuildingEnd: CGFloat = -0.5 * spaceBetweenBuildings
        var lastBuilding: Building? = nil
        while lastBuildingEnd < size.width {
            let newBuilding = Building(texture: buildingTexture, size: buildingSize, entityController: entityController)
            if let buildingNode = newBuilding.component(ofType: SpriteComponent.self)?.node {
                buildingNode.position = CGPoint(x: lastBuildingEnd + buildingNode.size.width/2 + spaceBetweenBuildings, y: floorLevel + buildingNode.size.height/2)
                lastBuildingEnd = buildingNode.position.x + buildingNode.size.width/2
                entityController.add(newBuilding)
                lastBuilding = newBuilding
            }
        }
        //Remove the last building iff it is mostly off screen.
        if let lastBuilding = lastBuilding, lastBuildingEnd > size.width + buildingWidth/2 {
            entityController.remove(lastBuilding)
        }
    }
    
    private func spawnRaider(){
        let raiderTexture = SKTexture(image: #imageLiteral(resourceName: "enemy01"))
        let raider = Raider(appearance: raiderTexture, findTargets: entityController.getCivilianTargetAgents, afraidOf: [entityController.getPlayerAgent()], unlessDistanceAway: 0, entityController: entityController)
        raider.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: size.width/2, y: size.height - 100)
        raider.component(ofType: RaiderAgent.self)?.position = float2.init(x: Float(size.width/2), y: Float(size.width/2 - 100))
        entityController.add(raider)
        //let missile = GuidedMissile(target: entityController.getPlayerAgent(), entityController: entityController)
        //missile.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: size.width, y: size.height)
        //entityController.add(missile)
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
