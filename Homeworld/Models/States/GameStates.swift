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
        let playTexture = SKTexture(image: #imageLiteral(resourceName: "play"))
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
        return stateClass is PauseState.Type
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
