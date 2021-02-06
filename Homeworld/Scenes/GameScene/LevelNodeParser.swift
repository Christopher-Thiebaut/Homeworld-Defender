//
//  LevelNodeParser.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

protocol FloorContainer {
    var floorLevel: CGFloat { get }
}

protocol LevelNodeParser {
    func parseEntities(
        from node: SKNode,
        into scene: FloorContainer,
        withEntityController entityController: EntityController
    )
}

class LevelNodeParserImp: LevelNodeParser {
    private let sceneEditorNodeFactory: SceneEditorNodeFactory
    
    init(factory: SceneEditorNodeFactory) {
        self.sceneEditorNodeFactory = factory
    }
    
    func parseEntities(
        from node: SKNode,
        into scene: FloorContainer,
        withEntityController entityController: EntityController
    ) {
        for node in node.children.compactMap({ $0 as? SceneEditorNode }) {
            node.removeFromParent()
            let entity = sceneEditorNodeFactory.createEntity(for: node)
            node.position.y += scene.floorLevel - 10
            node.zPosition = GameScene.ZPositions.low
            entityController.add(entity)
        }
    }
}
