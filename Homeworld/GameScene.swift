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
        
        buildDemoCity(buildingWidth: 50)
        
        
//        let wait = SKAction.wait(forDuration: 4)
//        self.run(wait)
//        run(SKAction.sequence([wait, SKAction.run {
//            self.addDemoMissile(target: humanFighter.component(ofType: PassiveAgent.self)!)
//            }]))
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
        var lastBuildingEnd: CGFloat = 0
        let buildingTexture = SKTexture(image: #imageLiteral(resourceName: "basic_building"))
        let scale = buildingWidth/buildingTexture.size().width
        let buildingSize = CGSize(width: buildingTexture.size().width * scale, height: buildingTexture.size().height * scale)
        let spaceBetweenBuildings: CGFloat = buildingWidth/5
        while lastBuildingEnd < size.width {
            let newBuilding = Building(texture: buildingTexture, size: buildingSize, entityController: entityController)
            if let buildingNode = newBuilding.component(ofType: SpriteComponent.self)?.node {
                buildingNode.position = CGPoint(x: lastBuildingEnd + buildingNode.size.width/2 + spaceBetweenBuildings, y: floorLevel + buildingNode.size.height/2)
                lastBuildingEnd = buildingNode.position.x + buildingNode.size.width/2
                entityController.add(newBuilding)
            }
        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
