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
    
    //MARK: - PROPERTIES
    
    var score: Int = 0 {
        didSet{
            scoreLabel?.text = "\(score)"
        }
    }
    
    var finishedSpawningEnemies = false
    
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
    var playerSpriteNode: SKSpriteNode?
    //The node representing the floor.
    var floorNode: SKSpriteNode?
    ///Minimum distance from the floor at which the camera will track the player.
    lazy var minimumCameraHeight: CGFloat = size.width/4
    //The size of the gameplay area. Used for map wrapping, restricting camera tracking, and "mirror zones" which move content that is at one edge of the gameplay area to the other as the player moves over there to create the illusion of a continuous world. The gameplay area is centered around the initial area.
    var gamePlayArea: CGSize

    let textureAtlas = SKTextureAtlas(named: ResourceNames.mainSpriteAtlasName)
    
    ///The portion of the gameplay area in which it is safe to place nodes such that their relative position to other nodes in game space will not be altered by sliding window update.
    private var placementArea: CGRect {
        return CGRect(x: minX, y: floorLevel, width: gamePlayArea.width, height: gamePlayArea.height)
    }
    
    var minX: CGFloat {
        return (camera?.position.x ?? 0) - gamePlayArea.width/2
    }
    var maxX: CGFloat {
        return (camera?.position.x ?? 0) + gamePlayArea.width/2
    }
    
    private var lastPlayerPositionX: CGFloat = 0
    
    var gameStates: GameStateMachine?
    
    var sceneEditorNode: SKNode?
    
    //MARK: - Initialization
    
    init<T: HumanFighter>(fileNamed: String? = nil, visibleSize: CGSize, gamePlayAreaSize: CGSize, player: T.Type){
        playerType = player
        gamePlayArea = gamePlayAreaSize
        entityController = EntityController(difficulty: UserData.currentUser.preferredDifficulty)
        super.init(size: visibleSize)
        if let fileName = fileNamed {
            sceneEditorNode = SKNode(fileNamed: fileName)
        }
        gameStates = buildGameStates()
        entityController.scene = self
        physicsWorld.contactDelegate = entityController
    }
    
    private func buildGameStates() -> GameStateMachine {
        return GameStateMachine(states: [PlayState(scene: self), PauseState(scene: self), VictoryState(scene: self), DefeatState(scene: self)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SETUP
    
    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let joyStickWidth = min(size.width/3.5, 150)
        
        let joyStickSize = CGSize(width: joyStickWidth, height: joyStickWidth)
        let joyStick = JoystickNode(size: joyStickSize)
        joyStick.distanceOffCenter = 0.4
        
        let player = playerType.init(entityController: entityController, propulsionControl: joyStick, rotationControl: joyStick)
        guard let playerSpriteNode = player.component(ofType: SpriteComponent.self)?.node else{
            fatalError("Player Character must have a sprite component.")
        }
        self.playerSpriteNode = playerSpriteNode
        playerSpriteNode.zPosition = ZPositions.low
        playerSpriteNode.position = CGPoint(x: anchorPoint.x, y: floorLevel + 200)
        lastPlayerPositionX = playerSpriteNode.position.x
        entityController.add(player)

        //Assign the fire button to the player's fire function.
        let buttonTexture = textureAtlas.textureNamed(ResourceNames.redButtonName)
        let fireButton = ButtonNode(texture: buttonTexture, size: joyStickSize) {
            if let fireComponent = player.component(ofType: FireProjectileComponent.self){
                fireComponent.fire()
            }
        }
        
        floorLevel = -size.width/2 + joyStickWidth
        //let floorTexture = SKTexture(image: #imageLiteral(resourceName: "ground"))
        let floorTexture = textureAtlas.textureNamed(ResourceNames.groundName)
        let floorNode = SKSpriteNode(texture: floorTexture, color: .white, size: CGSize(width: gamePlayArea.width * 3, height: 10))
        floorNode.zPosition = ZPositions.low
        floorNode.position = CGPoint(x: anchorPoint.x, y: floorLevel)
        let floorEntity = Ground(spriteNode: floorNode, entityController: entityController)
        self.floorNode = floorNode
        entityController.add(floorEntity)
        
        //Make the controls children of the player so that they will move with the camera. Controls are positioned relative to the camera (center of the screen) so they don't move when the camera does.
        let camera = SKCameraNode()
        addChild(camera)
        self.camera = camera
        camera.addChild(joyStick)
        let leftPositionAdjustment = CGFloat(view.safeAreaInsets.left)
        let rightPositionAdjustment = CGFloat(view.safeAreaInsets.right)
 
        joyStick.position = CGPoint(x:  -0.5 * (size.width - joyStickWidth - leftPositionAdjustment) + joyStickWidth/4, y: -0.5 * (size.height - joyStickWidth) + 30)
        joyStick.zPosition = ZPositions.high
        camera.addChild(fireButton)
        fireButton.position = CGPoint(x: 0.5 * (size.width - joyStickWidth - rightPositionAdjustment) - joyStickWidth/4, y: -0.5 * (size.height - joyStickWidth) + 30)
        fireButton.zPosition = ZPositions.high
        
        //Add a pause button in the top left corner of the screen (positioned relative to the camera.)
        //let pauseTexture = SKTexture(image: #imageLiteral(resourceName: "pause"))
        let pauseTexture = textureAtlas.textureNamed(ResourceNames.pauseName)
        let pauseButton = ButtonNode(texture: pauseTexture, size: CGSize(width: 30, height: 30)) { [weak self] in
            self?.gameStates?.enter(PauseState.self)
        }
        camera.addChild(pauseButton)
        pauseButton.position = CGPoint(x: -0.5 * (size.width - pauseButton.size.width - leftPositionAdjustment) + 10, y: 0.5 * (size.height - pauseButton.size.height) - 10)
        pauseButton.zPosition = ZPositions.required
        
        //Add a label that will be used to display the current score in a cool retro font.
        let scoreDisplay = SKLabelNode(fontNamed: "VT323")
        scoreDisplay.text = "\(score)"
        scoreDisplay.position = CGPoint(x: 0, y: 0.5 * (size.height - scoreDisplay.frame.height) - 20)
        scoreDisplay.zPosition = ZPositions.required
        camera.addChild(scoreDisplay)
        
        scoreLabel = scoreDisplay
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
        stealChildren()
        
        showPlayerHealthBar()
        showPlayerReloadBar()
        
        if UserData.currentUser.wantsBackgroundMusic {
            playBackgroundMusic()
        }
        
        //The mothership is thick so that the player can't camp out where aliens come out and shoot them immediately (because the aliens can shoot from inside the mothersip and will be able to shoot the player first)
        let motherShip = MotherShip(size: CGSize.init(width: gamePlayArea.width * 2, height: 400), position: CGPoint.init(x: anchorPoint.x, y: placementArea.maxY), exits: 1, entityController: entityController)
        entityController.add(motherShip)
        
        addStarBackground()
    }
    
    private func stealChildren(){
        guard let editorNode = sceneEditorNode else {
            return
        }
        for child in editorNode.children {
            child.removeFromParent()
            if let tree = child as? TreeNode {
                let treeEntity = Tree(spriteNode: tree, entityController: entityController) //Badum tss.
                entityController.add(treeEntity)
            }
            if let rock = child as? RockNode {
                let rockEntity = Rock(spriteNode: rock, entityController: entityController)
                entityController.add(rockEntity)
            }
            if let smallBuilding = child as? SmallBuildingNode {
                let smallBuilding = Building(spriteNode: smallBuilding, health: 100, entityController: entityController)
                entityController.add(smallBuilding)
            }
            if let bigBuilding = child as? BigBuildingNode {
                let bigBuilding = Building(spriteNode: bigBuilding, health: 200, entityController: entityController)
                entityController.add(bigBuilding)
            }
            child.position.y += floorLevel - (floorNode?.size.height ?? 0)
            child.zPosition = ZPositions.low
        }
        sceneEditorNode = nil
    }
    
    //MARK: - UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        let dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        slidingWindowUpdate()
        if aliensDefeated() {
            gameStates?.enter(VictoryState.self)
        }
        if playerDefeated() {
            gameStates?.enter(DefeatState.self)
        }
        entityController.update(dt)

        updateCameraPosition()
    }
    
    //The player loses when the player dies or the whole city is wiped out.
    private func playerDefeated() -> Bool {
        guard entityController.playerAgent != nil else {
            return true
        }
        return entityController.getCivilianTargetAgents().count == 0
    }
    
    private func aliensDefeated() -> Bool {
        guard finishedSpawningEnemies else {
            return false
        }
        return entityController.getAlienEntities().count == 0
    }
    
    //NOTE: This is used instead of SKConstraints to update the camera position because when the scene to tried to update camera x position due to map wrapping below the minimum height, there was a super gross jump in which the camera had a difficult time tracking the player. This looks smooth because the camera doesn't translate accross space to track the player, it teleports (like the player does)
    private func updateCameraPosition(){
        guard let playerNode = playerSpriteNode, let floorNode = floorNode else {
            NSLog("Cannot position camera because the player or the floor could not be found.")
            return
        }
        camera?.position.x = playerNode.position.x
        //camera?.position.y = playerNode.position.y
        if playerNode.position.y - floorNode.position.y > minimumCameraHeight && playerNode.position.y < placementArea.maxY - minimumCameraHeight {
            camera?.position.y = playerNode.position.y
        }
    }
    
    private func slidingWindowUpdate(){
        guard let playerSprite = playerSpriteNode else {
            NSLog("Cannot update positions based on player position because the player has no position.")
            return
        }
        if playerSprite.position.x > lastPlayerPositionX {
            let nodesToUpdate = getNodesWithXcoordinatesBetween(min: playerSprite.position.x - gamePlayArea.width/2 - 500, max: playerSprite.position.x - gamePlayArea.width/2 - 30)
            for node in nodesToUpdate {
                node.position.x += gamePlayArea.width
            }
        }else if playerSprite.position.x < lastPlayerPositionX {
            let nodesToUpdate = getNodesWithXcoordinatesBetween(min: playerSprite.position.x + gamePlayArea.width/2 + 30, max: playerSprite.position.x + gamePlayArea.width/2 + 500)
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
    
}

// MARK: - HealthBar
extension GameScene {
    func showPlayerHealthBar() {
        guard let playerHealthComponent = entityController.playerAgent?.entity?.component(ofType: HealthComponent.self) else {
            NSLog("Not displaying player health bar because the player doesn't exist.")
            return
        }
        let healthBarHeight: CGFloat = 10
        let healthBarPosition = CGPoint(x: -size.width/4, y: size.height/2 - healthBarHeight)
        //let healthBarPosition = camera!.position
        let healthBar = DisplayedPercentageBar(initialSize: CGSize.init(width: size.width/3, height: healthBarHeight), color: .green, backgroundColor: .red, initialPosition: healthBarPosition, quantityToMonitor: playerHealthComponent)
        if let healthBarSprite = healthBar.component(ofType: PercentageBarComponent.self)?.sprite {
            camera?.addChild(healthBarSprite)
            healthBarSprite.zPosition = ZPositions.required
        }
        entityController.add(healthBar)
    }
    
    func showPlayerReloadBar() {
        guard let playerWeapon = entityController.playerAgent?.entity?.component(ofType: FireProjectileComponent.self) else {
            NSLog("Not displaying player reload bar because the player doesn't exist.")
            return
        }
        let reloadBarHeight: CGFloat = 10
        let reloadBarPosition = CGPoint(x: size.width/4, y: size.height/2 - reloadBarHeight)
        let reloadBar = DisplayedPercentageBar(initialSize: CGSize.init(width: size.width/3, height: reloadBarHeight), color: .blue, backgroundColor: .white, initialPosition: reloadBarPosition, quantityToMonitor: playerWeapon)
        if let reloadBarSprite = reloadBar.component(ofType: PercentageBarComponent.self)?.sprite {
            camera?.addChild(reloadBarSprite)
            reloadBarSprite.zPosition = ZPositions.required
        }
        entityController.add(reloadBar)
    }
}

//MARK: - Background
extension GameScene {
    func addStarBackground(){
        let backgroundTexture = textureAtlas.textureNamed(ResourceNames.starBackground)
        var backgroundHeight: CGFloat = 0
        while backgroundHeight < gamePlayArea.height {
            var rowWidth: CGFloat = 0
            var nextTilePosition = CGPoint(x: minX + backgroundTexture.size().width/2, y: floorLevel + backgroundHeight + backgroundTexture.size().width/2)
            while rowWidth < gamePlayArea.width {
                let backgroundTile = SKSpriteNode(texture: backgroundTexture)
                backgroundTile.position = nextTilePosition
                backgroundTile.zPosition = ZPositions.default
                addChild(backgroundTile)
                nextTilePosition.x += backgroundTile.size.width
                rowWidth += backgroundTile.size.width
            }
            backgroundHeight += backgroundTexture.size().height
        }
    }
}

//MARK: - Background Music
extension GameScene {
    func playBackgroundMusic(){
        let audioNode = SKAudioNode(fileNamed: ResourceNames.Sounds.backgroundMusic)
        audioNode.autoplayLooped = true
        audioNode.isPositional = false
        addChild(audioNode)
        audioNode.run(SKAction.play())
    }
}
