//
//  DebuggingBeacon.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/28/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class DebugginBeacon: GKEntity {
    
    override init() {
        super.init()
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "enemy01"))
        let spriteComponent = SpriteComponent(texture: texture, color: .white, size: texture.size())
        addComponent(spriteComponent)
        
        let positionLoggingComponent = PositionLoggingComponent()
        addComponent(positionLoggingComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
