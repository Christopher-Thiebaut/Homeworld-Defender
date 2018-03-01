//
//  ScoreDeathComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ScoreDeathComponent: GKComponent {
    
    weak var gameScene: GameScene?
    let pointValue: Int
    
    init(gameScene: GameScene, pointValue: Int) {
        self.gameScene = gameScene
        self.pointValue = pointValue
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scoreDeath(){
        gameScene?.score += pointValue
    }
    
}
