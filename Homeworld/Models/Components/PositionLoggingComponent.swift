//
//  PositionLoggingComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PositionLoggingComponent: GKComponent {
    
    var lastPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node else {
            NSLog("Position Logging component cannot log position because it has none.")
            return
        }
        if spriteNode.position != lastPosition {
            lastPosition = spriteNode.position
            NSLog("Position: (\(lastPosition.x), \(lastPosition.y)")
        }
    }
    
}
