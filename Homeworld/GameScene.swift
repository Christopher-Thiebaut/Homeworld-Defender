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
    
    ///Handles most of the simulation by managing the addition and removal of entities and calling the update functions of their components.
    let entityController: EntityController
    ///Used to calculate how much time has passed since the last update so that the EntityController can take appropriately sized simulaiton steps.
    var lastUpdateTimeInterval: TimeInterval = 0
    ///The floor is what should be consider "ground level" for most game elements, but will not usually be 0 at runtime because the control nodes are below the "floor"
    var floorLevel: CGFloat = 0
    //Player Character's class. Allows for giving the player different kinds of fighters/planes on different levels.
    let playerType: HumanFighter.Type
    //Player's Sprite Node
    var playerSpriteNode: SKSpriteNode? = nil
    //The node representing the floor.
    var floorNode: SKSpriteNode? = nil
    ///Minimum height at which the camera will track the player.
    var minimumCameraHeight: CGFloat = 200
    //The size of the gameplay area. Used for map wrapping, restricting camera tracking, and "mirror zones" which move content that is at one edge of the gameplay area to the other as the player moves over there to create the illusion of a continuous world. The gameplay area is centered around the initial area.
    var gamePlayArea: CGSize
    ///The portion of the gameplay area in which it is safe to place nodes such that movement due to mirror zones will not cause a collision.
    private var placementArea: CGRect {
        return CGRect(x: minX, y: floorLevel, width: rightMirrorBoundary, height: gamePlayArea.height)
    }
    
    var minX: CGFloat {
        return -gamePlayArea.width/2
    }
    var maxX: CGFloat {
        return gamePlayArea.width/2
    }
    private var leftMirrorBoundary: CGFloat {
        return minX + size.width/2
    }
    
    private var rightMirrorBoundary: CGFloat {
        return maxX - size.width/2
    }
    
    init<T: HumanFighter>(visibleSize: CGSize, gamePlayAreaSize: CGSize, player: T.Type){
        playerType = player
        gamePlayArea = gamePlayAreaSize
        entityController = EntityController()
        super.init(size: visibleSize)
        entityController.scene = self
    }
    
    private var lastPlayerPositionX: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let joyStickWidth = min(size.width/4, 100)
        
        let joyStickSize = CGSize(width: joyStickWidth, height: joyStickWidth)
        let joyStick = JoystickNode(size: joyStickSize)
        
        let player = playerType.init(entityController: entityController, propulsionControl: joyStick, rotationControl: joyStick)
        guard let playerSpriteNode = player.component(ofType: SpriteComponent.self)?.node else{
            fatalError("Player Character must have a sprite component.")
        }
        self.playerSpriteNode = playerSpriteNode
        playerSpriteNode.position = CGPoint(x: anchorPoint.x, y: size.height/2)
        lastPlayerPositionX = playerSpriteNode.position.x
        entityController.add(player)

        //Assign the fire button to the player's fire function.
        let buttonTexture = SKTexture(image: #imageLiteral(resourceName: "red_button"))
        let fireButton = ButtonNode(texture: buttonTexture, size: joyStickSize) {
            if let fireComponent = player.component(ofType: FireProjectileComponent.self){
                fireComponent.fire()
            }
        }
        
        floorLevel = joyStickWidth + 15
        
        let floorNode = SKSpriteNode(color: .white, size: CGSize(width: gamePlayArea.width * 2, height: 10))
        floorNode.position = CGPoint(x: anchorPoint.x, y: floorLevel)
        addChild(floorNode)
        self.floorNode = floorNode
        floorNode.physicsBody = SKPhysicsBody(rectangleOf: floorNode.size)
        floorNode.physicsBody?.affectedByGravity = false
        
        
        //Make the controls children of the player so that they will move with the camera. Controls are positioned relative to the camera (center of the screen) so they don't move when the camera does.
        let camera = SKCameraNode()
        addChild(camera)
        self.camera = camera
        camera.addChild(joyStick)
        joyStick.position = CGPoint(x:  -0.5 * (size.width - joyStickWidth) + 10, y: -0.5 * (size.height - joyStickWidth) + 10)
        camera.addChild(fireButton)
        fireButton.position = CGPoint(x: 0.5 * (size.width - joyStickWidth) - 10, y: -0.5 * (size.height - joyStickWidth) + 10)
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
 //       singleNodeDemoCity(buildingWidth: 30)
//        let debugginBeacon = DebugginBeacon()
//        debugginBeacon.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: anchorPoint.x, y: floorLevel + 30)
//        entityController.add(debugginBeacon)
        buildDemoCity(buildingWidth: 30)
//
//
//        let wait = SKAction.wait(forDuration: 4)
//        run(wait)
//        run(SKAction.sequence([wait, SKAction.run {[weak self] in
//            self?.spawnRaider()
//            }]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        updateCameraPosition()
        //updateMirrorZones()
        slidingWindowUpdate()
        entityController.update(dt)
    }
    
    //NOTE: This is used instead of SKConstraints to update the camera position because when the scene to tried to update camera x position due to map wrapping below the minimum height, there was a super gross jump in which the camera had a difficult time tracking the player. This looks smooth because the camera doesn't translate accross space to track the player, it teleports (like the player does)
    private func updateCameraPosition(){
        guard let playerNode = playerSpriteNode, let floorNode = floorNode else {
            NSLog("Cannot position camera because the player or the floor could not be found.")
            return
        }
        camera?.position.x = playerNode.position.x
        if playerNode.position.y - floorNode.position.y > minimumCameraHeight {
            camera?.position.y = playerNode.position.y
        }
    }
    
    private func slidingWindowUpdate(){
        guard let playerSprite = playerSpriteNode else {
            NSLog("Cannot update positions based on player position because the player has no position.")
            return
        }
        if playerSprite.position.x > lastPlayerPositionX {
            let nodesToUpdate = getNodesWithXcoordinatesBetween(min: playerSprite.position.x - gamePlayArea.width/2 - 40, max: playerSprite.position.x - gamePlayArea.width/2 - 30)
            for node in nodesToUpdate {
                //let distanceFromWindow = playerSprite.position.x - gamePlayArea.width/2 - node.position.x
                //node.position.x = playerSprite.position.x + gamePlayArea.width/2 + distanceFromWindow
                node.position.x += gamePlayArea.width
            }
        }else if playerSprite.position.x < lastPlayerPositionX {
            let nodesToUpdate = getNodesWithXcoordinatesBetween(min: playerSprite.position.x + gamePlayArea.width/2 + 30, max: playerSprite.position.x + gamePlayArea.width/2 + 40)
            for node in nodesToUpdate {
                //let distanceFromWindow = node.position.x - playerSprite.position.x - gamePlayArea.width/2
                //node.position.x = playerSprite.position.x - gamePlayArea.width/2 - distanceFromWindow
                node.position.x -= gamePlayArea.width
            }
        }
        lastPlayerPositionX = playerSprite.position.x
    }
    
    private func getNodesWithXcoordinatesBetween(min: CGFloat, max: CGFloat) -> [SKNode]{
        var foundNodes: [SKNode] = []
        for node in children {
            if node.position.x > min && node.position.x < max {
                foundNodes.append(node)
            }
        }
        return foundNodes
    }
    
    private func distanceBetween(_ node1: SKSpriteNode, _ node2: SKSpriteNode) -> CGFloat{
        return hypot(node1.position.x - node2.position.x, node1.position.y - node2.position.y)
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
        var lastBuildingEnd: CGFloat = placementArea.minX - (0.5 * spaceBetweenBuildings)
        var lastBuilding: Building? = nil
        while lastBuildingEnd < placementArea.maxX {
            let newBuilding = Building(texture: buildingTexture, size: buildingSize, entityController: entityController)
            if let buildingNode = newBuilding.component(ofType: SpriteComponent.self)?.node {
                buildingNode.position = CGPoint(x: lastBuildingEnd + buildingNode.size.width/2 + spaceBetweenBuildings, y: floorLevel + buildingNode.size.height/2)
                lastBuildingEnd = buildingNode.position.x + buildingNode.size.width/2
                entityController.add(newBuilding)
                lastBuilding = newBuilding
            }
        }
        //Remove the last building iff it is mostly off screen.
        if let lastBuilding = lastBuilding, lastBuildingEnd > placementArea.maxX {
            entityController.remove(lastBuilding)
        }
    }
    
    private func spawnRaider(){
        let raiderTexture = SKTexture(image: #imageLiteral(resourceName: "enemy01"))
        let raider = Raider(appearance: raiderTexture, findTargets: entityController.getCivilianTargetAgents, afraidOf: [entityController.getPlayerAgent()], unlessDistanceAway: 0, entityController: entityController)
        raider.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: size.width/2, y: size.height - 100)
        raider.component(ofType: RaiderAgent.self)?.position = float2.init(x: Float(size.width/2), y: Float(size.width/2 - 100))
        entityController.add(raider)
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
