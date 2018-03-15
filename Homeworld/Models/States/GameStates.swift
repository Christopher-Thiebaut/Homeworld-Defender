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
        playButton.zPosition = GameScene.ZPositions.required
        pauseBackground.zPosition = GameScene.ZPositions.high + 1
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
        scene.isPaused = true
        let overlay = buildOverlay()
        
        if let camera = scene.camera {
            camera.addChild(overlay)
        }else{
            scene.addChild(overlay)
        }
    }
    
    private func buildOverlay() -> SKSpriteNode {
        let background = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: scene.size)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = GameScene.ZPositions.high + 1
        
        let mainMenuLabel = SKLabelNode(fontNamed: "VT323")
        mainMenuLabel.text = "RETURN TO MENU"
        mainMenuLabel.fontColor = .red
        mainMenuLabel.fontSize = 25
        let mainMenuButton = ButtonNode(label: mainMenuLabel, action: returnToMainMenu)
        background.addChild(mainMenuButton)
        mainMenuButton.alpha = 1
        
        let messageLabel = SKLabelNode(fontNamed: "VT323")
        messageLabel.fontSize = 30
        messageLabel.text = message
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: 0, y: background.size.height/3.5)
        background.addChild(messageLabel)
        messageLabel.alpha = 1
        
        return background
    }
    
    private func returnToMainMenu(){
        guard let view = scene.view else { return }
        let mainMenu = MainMenuScene(size: view.frame.size)
        mainMenu.scaleMode = .aspectFill
        view.presentScene(mainMenu)
    }
}

class VictoryState: GameOverState {
    
    init(scene: GameScene){
        super.init(scene: scene, message: "CONGRATULATIONS, YOU SAVED THE WORLD.")
    }
}

class DefeatState: GameOverState {
    
    init(scene: GameScene){
        super.init(scene: scene, message: "YOU HAVE BEEN DEFEATED, HUMANITY IS DOOMED.")
    }
}
