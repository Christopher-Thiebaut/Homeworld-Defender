//
//  ManualRotationComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol RotationControl: class {
    func angle() -> CGFloat
}

class ManualRotationComponent: GKComponent {
    
    var spriteNode: SKSpriteNode
    
    weak var rotationControl: RotationControl?
    
    init(spriteNode: SKSpriteNode, rotationControl: RotationControl){
        self.spriteNode = spriteNode
        self.rotationControl = rotationControl
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let rotationControl = rotationControl else {
            NSLog("A Manual Rotation Component cannot rotate this round because its rotation control does not exist. This was probably unintentional. Fix it.")
            return
        }
        
        spriteNode.zRotation = rotationControl.angle()
    }
}
