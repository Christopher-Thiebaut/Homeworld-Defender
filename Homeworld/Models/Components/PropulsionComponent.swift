//
//  RocketComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol PropulsionControl: class {
    func shouldApplyThrust() -> Bool
    ///The PropulsionControl should not attempt to scale the magnitude of the applied force with the mass of the object being moved as that is the responsibility of the PropulsionComponent.
    func magnitude() -> CGFloat
}

///This component allows for manually applying forces to an entity's physics body (if any) in the direction the entity's SpriteNode is currently facing. This should not be used for AI players with an agent, as the agent will move that entity by other means.
class PropulsionComponent: NonDecodableComponent {
    
    var spriteNode: SKSpriteNode
    var physicsBody: SKPhysicsBody
    weak var control: PropulsionControl?
    
    init?(spriteNode: SKSpriteNode, control: PropulsionControl){
        guard let physicsBody = spriteNode.physicsBody else {
            NSLog("PropulsionComponent can only be used with a physics body. I mean, what does it even mean to apply a force to something with no mass.")
            return nil
        }
        self.spriteNode = spriteNode
        self.physicsBody = physicsBody
        self.control = control
        super.init()
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let control = control else {
            NSLog("A propulsion control did not apply thrust this update cycle because it has no control object. It's probably supposed to have one.")
            return
        }
    
        if control.shouldApplyThrust() {
            let playerRotation = spriteNode.zRotation
            let scale = control.magnitude() * physicsBody.mass
            let angle = Float(playerRotation)
            let dx = CGFloat(cosf(angle))
            let dy = CGFloat(sinf(angle))
            physicsBody.applyForce(CGVector.init(dx: dx * scale, dy: dy * scale))
        }
    }
    
    private func speed(velocity: CGVector) -> CGFloat {
        return hypot(velocity.dx, velocity.dy)
    }
}
