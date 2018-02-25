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
    
    private var lastTouchLocation: CGPoint? = nil
    
    private var player: SKNode?
    
    private var thrustButton: SKNode?

    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player")
        thrustButton = self.childNode(withName: "thrust_button")
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    private func touchWasIn(node: SKNode?) -> Bool {
        guard let lastTouch = lastTouchLocation, let node = node else {
            return false
        }
        return node.contains(lastTouch)
    }
    
    private func handleTouches(touches: Set<UITouch>){
        for touch in touches {
            let touchLocation = touch.location(in: self)
            lastTouchLocation = touchLocation
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches: touches)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if touchWasIn(node: thrustButton){
            guard let playerRotation = player?.zRotation else {
                NSLog("Failed to apply impulse to player because the player's orientation could not be determined")
                return
            }
            let scale = 100.0
            let angle = Float(playerRotation)
            let dx = Double(cosf(angle))
            let dy = Double(sinf(angle))
            player?.physicsBody?.applyImpulse(CGVector.init(dx: dx * scale, dy: dy * scale))
            lastTouchLocation = nil
        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
}
