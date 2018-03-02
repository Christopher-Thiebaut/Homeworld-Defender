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
    
    struct ZPositions {
        static let `default`: CGFloat = 0
        static let low: CGFloat = 250
        static let medium: CGFloat = 500
        static let high: CGFloat = 750
        static let required: CGFloat = 1000
    }
    
    var score: Int = 0 {
        didSet{
            scoreLabel?.text = "\(score)"
        }
    }
    
    var scoreLabel: SKLabelNode?
    
    ///Handles most of the simulation by managing the addition and removal of entities and calling the update functions of their components.
    let entityController: EntityController
    ///Used to calculate how much time has passed since the last update so that the EntityController can take appropriately sized simulaiton steps.
    var lastUpdateTimeInterval: TimeInterval = 0
    ///The floor is what should be consider "ground level" for most game elements, but will not usually be 0 at runtime because the control nodes are below the "floor"
    var floorLevel: CGFloat = 0
    //Player Character's class. Allows for giving the player different kinds of fighters/planes on different levels.
    let playerType: HumanFighter.Type
    //Player's Sprite Node
    var playerSpriteNode: SKSpriteNode!
    //The node representing the floor.
    var floorNode: SKSpriteNode!
    ///Minimum height at which the camera will track the player.
    var minimumCameraHeight: CGFloat = 200
    //The size of the gameplay area. Used for map wrapping, restricting camera tracking, and "mirror zones" which move content that is at one edge of the gameplay area to the other as the player moves over there to create the illusion of a continuous world. The gameplay area is centered around the initial area.
    var gamePlayArea: CGSize
    ///The portion of the gameplay area in which it is safe to place nodes such that movement due to mirror zones will not cause a collision.
    private var placementArea: CGRect {
        return CGRect(x: minX, y: floorLevel, width: gamePlayArea.width, height: gamePlayArea.height)
    }
    
    var minX: CGFloat {
        return (camera?.position.x ?? 0) - gamePlayArea.width/2
    }
    var maxX: CGFloat {
        return (camera?.position.x ?? 0) + gamePlayArea.width/2
    }
    
    let cityCenterReferenceNode = SKNode()
    
    private var lastPlayerPositionX: CGFloat = 0
    
    var gameStates: GameStateMachine!
    
    init<T: HumanFighter>(visibleSize: CGSize, gamePlayAreaSize: CGSize, player: T.Type){
        playerType = player
        gamePlayArea = gamePlayAreaSize
        entityController = EntityController()
        super.init(size: visibleSize)
        gameStates = GameStateMachine(states: [PlayState(scene: self), PauseState(scene: self)])
        entityController.scene = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let joyStickWidth = min(size.width/3.5, 100)
        
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
        
        let floorNode = SKSpriteNode(color: UIColor.white.withAlphaComponent(0), size: CGSize(width: gamePlayArea.width * 2, height: 10))
        floorNode.position = CGPoint(x: anchorPoint.x, y: floorLevel)
        addChild(floorNode)
        self.floorNode = floorNode
        floorNode.physicsBody = SKPhysicsBody(rectangleOf: floorNode.size)
        floorNode.physicsBody?.affectedByGravity = false
        floorNode.physicsBody?.isDynamic = false
        
        
        //Make the controls children of the player so that they will move with the camera. Controls are positioned relative to the camera (center of the screen) so they don't move when the camera does.
        let camera = SKCameraNode()
        addChild(camera)
        self.camera = camera
        camera.addChild(joyStick)
        joyStick.position = CGPoint(x:  -0.5 * (size.width - joyStickWidth) + joyStickWidth/4, y: -0.5 * (size.height - joyStickWidth) + 10)
        joyStick.zPosition = ZPositions.high
        camera.addChild(fireButton)
        fireButton.position = CGPoint(x: 0.5 * (size.width - joyStickWidth) - joyStickWidth/4, y: -0.5 * (size.height - joyStickWidth) + 10)
        fireButton.zPosition = ZPositions.high
        
        //Add a pause button in the top left corner of the screen (positioned relative to the camera.)
        let pauseTexture = SKTexture(image: #imageLiteral(resourceName: "pause"))
        let pauseButton = ButtonNode(texture: pauseTexture, size: CGSize(width: 30, height: 30)) { [weak self] in
            self?.gameStates.enter(PauseState.self)
        }
        camera.addChild(pauseButton)
        pauseButton.position = CGPoint(x: -0.5 * (size.width - pauseButton.size.width) + 10, y: 0.5 * (size.height - pauseButton.size.height) - 10)
        pauseButton.zPosition = ZPositions.high
        
        //Add a label that will be used to display the current score in a cool retro font.
        let scoreDisplay = SKLabelNode(fontNamed: "VT323")
        scoreDisplay.text = "\(score)"
        scoreDisplay.position = CGPoint(x: 0, y: 0.5 * (size.height - scoreDisplay.frame.height) - 20)
        camera.addChild(scoreDisplay)
        
        scoreLabel = scoreDisplay
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        
        /*buildDemoCity(buildingWidth: 30)
        
        run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 4), SKAction.run {
            self.spawnRaider()
            }]), count: 4))*/
        cityCenterReferenceNode.position = CGPoint(x: playerSpriteNode.position.x, y: floorLevel)

    }
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        updateCameraPosition()
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
                node.position.x += gamePlayArea.width
            }
        }else if playerSprite.position.x < lastPlayerPositionX {
            let nodesToUpdate = getNodesWithXcoordinatesBetween(min: playerSprite.position.x + gamePlayArea.width/2 + 30, max: playerSprite.position.x + gamePlayArea.width/2 + 40)
            for node in nodesToUpdate {
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
    
    private func addDemoMissile(target: GKAgent2D){
        let demoMissile = GuidedMissile.init(target: target, entityController: entityController)
        if let demoMissileSpriteComponent = demoMissile.component(ofType: SpriteComponent.self) {
            demoMissileSpriteComponent.node.position = CGPoint(x: size.width, y: demoMissileSpriteComponent.node.size.height/2)
        }
        entityController.add(demoMissile)
    }
    
    func buildDemoCity(buildingWidth: CGFloat){
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
        guard let camera = camera else { return }
        raider.component(ofType: SpriteComponent.self)?.node.position = CGPoint(x: camera.position.x, y: size.height - 100)
        //raider.component(ofType: RaiderAgent.self)?.position = float2.init(x: Float(size.width/2), y: Float(size.width/2 - 100))
        entityController.add(raider)
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
