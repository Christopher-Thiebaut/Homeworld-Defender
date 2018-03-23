//
//  GameStates.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class GameStateMachine: GKStateMachine {
    
    override init(states: [GKState]) {
        super.init(states: states)
        NotificationCenter.default.addObserver(self, selector: #selector(appStatePause), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appStatePause), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    fileprivate static func toggleUserInteraction(`in` node: SKNode){
        for child in node.children {
            child.isUserInteractionEnabled = !child.isUserInteractionEnabled
            toggleUserInteraction(in: child)
        }
    }
    
    @objc func appStatePause() {
        //The application wants to automagically resume when the app enters the foreground. This is not good as the player's thumb will not be on the control and they may crash when they expected to be paused.
        if let state = currentState as? PauseState{
            state.scene.isPaused = true
        }
        if let state = currentState as? GameOverState {
            state.scene.isPaused = true
        }
        enter(PauseState.self)
        
    }
}

class PauseState: GKState {
    
    let scene: GameScene
    var pauseOverlay: SKNode
    
    init(scene: GameScene){
        self.scene = scene
        pauseOverlay = SKNode()
        super.init()
        pauseOverlay = buildPauseOverlay()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.isPaused = true
        
        //Toggle user interaction to disable controls in the scene.
        GameStateMachine.toggleUserInteraction(in: scene)
        
        //Puts pause overlay over controls and content while the game is paused.
        if let camera = scene.camera {
            camera.addChild(pauseOverlay)
        }else{
            scene.addChild(pauseOverlay)
            pauseOverlay.position = scene.anchorPoint
        }
    }
    
    private func buildPauseOverlay() -> SKNode {
        //let playTexture = SKTexture(image: #imageLiteral(resourceName: "play"))
        let playTexture = SKTextureAtlas(named: ResourceNames.mainSpriteAtlasName).textureNamed(ResourceNames.resumeName)
        let buttonSize = CGSize(width: 2 * playTexture.size().width, height: 2 * playTexture.size().height)
        let playButton = ButtonNode(texture: playTexture, size: buttonSize) { [weak self] in
            self?.stateMachine?.enter(PlayState.self)
        }
        let pauseBackground = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: scene.size)
        pauseBackground.addChild(playButton)
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.zPosition = GameScene.ZPositions.required + 2
        pauseBackground.zPosition = GameScene.ZPositions.required + 1
        playButton.alpha = 1
        return pauseBackground
    }
}

class PlayState: GKState {
    
    let scene: GameScene
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PauseState.Type || stateClass is GameOverState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        guard let previous = previousState as? PauseState else {
            return
        }
        previous.pauseOverlay.removeFromParent()
        GameStateMachine.toggleUserInteraction(in: scene)
        scene.isPaused = false
    }
}

class GameOverState: GKState {
    
    let scene: GameScene
    let message: String
    
    init(scene: GameScene, message: String) {
        self.scene = scene
        self.message = message
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {[weak self] in
            self?.scene.isPaused = true
        })
        let overlay = buildOverlay()
        
        if let camera = scene.camera {
            camera.addChild(overlay)
        }else{
            scene.addChild(overlay)
        }
        
        if scene.score > UserData.currentUser.highScore {
            UserData.currentUser.highScore = scene.score
        }
    }
    
    private func buildOverlay() -> SKSpriteNode {
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: scene.size)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = GameScene.ZPositions.required + 1
        
        var nodes: [SKNode] = []
        
        let messageLabel = makeLabel(with: message, fontSize: 60, fontColor: .red)
        nodes.append(messageLabel)
        
        let scoreBreakDownLabel = makeLabel(with: "SCORE BREAKDOWN:")
        nodes.append(scoreBreakDownLabel)
        
        let baseScoreLabel = makeLabel(with: "BASE SCORE: \(scene.score/Int(scene.entityController.difficultyLevel.getScoreMultiplier()))")
        nodes.append(baseScoreLabel)
        
        let difficultyMultiplierLabel = makeLabel(with: "\(scene.entityController.difficultyLevel.difficulty.rawValue.uppercased()) DIFFICULTY: \(scene.entityController.difficultyLevel.getScoreMultiplier())x MULTIPLIER")
        nodes.append(difficultyMultiplierLabel)
        
        let finalScoreLabel = makeLabel(with: "FINAL SCORE: \(scene.score)")
        nodes.append(finalScoreLabel)
        
        let mainMenuLabel = makeLabel(with: "RETURN TO MENU", fontSize: 40, fontColor: .red)
        let mainMenuButton = ButtonNode(label: mainMenuLabel, action: returnToMainMenu)
        nodes.append(mainMenuButton)
        
        let desiredHeight = background.size.height - 100
        var labelsTotalHeight: CGFloat = 0
        for label in nodes {
            labelsTotalHeight += label.calculateAccumulatedFrame().height
        }
        let totalEmptySpace = desiredHeight - labelsTotalHeight
        let emptySpaceBetweenLabels = totalEmptySpace/(CGFloat(nodes.count) - 1)
        
        var nextLabelTop: CGFloat = desiredHeight/2
        
        for label in nodes {
            label.position = CGPoint(x: 0, y: nextLabelTop - label.calculateAccumulatedFrame().height/2)
            nextLabelTop -= label.calculateAccumulatedFrame().height + emptySpaceBetweenLabels
            background.addChild(label)
        }
        
        return background
    }
    
    private func returnToMainMenu(){
        guard let view = scene.view else { return }
        let mainMenu = MainMenuScene(size: view.frame.size)
        mainMenu.scaleMode = .aspectFill
        view.presentScene(mainMenu)
    }
    
    private func makeLabel(with text: String, andPosition position: CGPoint = CGPoint(x: 0, y: 0), fontSize: CGFloat = 30, fontColor: UIColor = .white) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "VT323")
        label.text = text
        label.position = position
        label.fontColor = fontColor
        label.fontSize = fontSize
        label.alpha = 1
        return label
    }
}

class VictoryState: GameOverState {
    
    init(scene: GameScene){
        super.init(scene: scene, message: "CONGRATULATIONS, YOU SAVED THE WORLD.")
    }
}

class DefeatState: GameOverState {
    
    init(scene: GameScene){
        super.init(scene: scene, message: "GAME OVER.")
    }
}
