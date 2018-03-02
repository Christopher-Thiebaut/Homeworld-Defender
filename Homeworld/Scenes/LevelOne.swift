//
//  LevelOne.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/1/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class LevelOne: GameScene {
    
    override init<T>(visibleSize: CGSize, gamePlayAreaSize: CGSize, player: T.Type) where T : HumanFighter {
        super.init(visibleSize: visibleSize, gamePlayAreaSize: gamePlayAreaSize, player: player)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        buildFloor()
        //buildDemoCity(buildingWidth: 30)
    }
    
    func setupEnvironment(){
        buildFloor()
    }
    
    func buildFloor() {
        var position = minX
        let floorTexture = SKTexture(image: #imageLiteral(resourceName: "ground"))
        let floorTextureWidth = floorNode.size.height + 5
        while position < maxX {
            let newFloorTile = SKSpriteNode(texture: floorTexture, color: .white, size: CGSize(width: floorTextureWidth, height: floorTextureWidth))
            newFloorTile.position = CGPoint(x: position , y: floorLevel)
            position += floorTextureWidth
            addChild(newFloorTile)
        }
    }
    
}
