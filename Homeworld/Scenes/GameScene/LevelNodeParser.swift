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

protocol BaseLineNode: SKNode {
    var floorLevel: CGFloat { get }
}

protocol LevelNodeParser {
    func parseEntities(
        from node: SKNode,
        into scene: BaseLineNode,
        withEntityController entityController: EntityController
    )
}

enum SceneEditorNodeType {
    case tree
    case rock
    case smallBuilding
    case largeBuilding
}

protocol SceneEditorNode: SKSpriteNode {
    var nodeType: SceneEditorNodeType { get }
}

protocol SceneEditorNodeFactory {
    func createEntity(for node: SceneEditorNode) -> GKEntity
}

class LevelNodeParserImp: LevelNodeParser {
    private let sceneEditorNodeFactory: SceneEditorNodeFactory
    
    init(factory: SceneEditorNodeFactory) {
        self.sceneEditorNodeFactory = factory
    }
    
    func parseEntities(
        from node: SKNode,
        into scene: BaseLineNode,
        withEntityController entityController: EntityController
    ) {
        for node in node.children.compactMap({ $0 as? SceneEditorNode }) {
            node.removeFromParent()
            let entity = sceneEditorNodeFactory.createEntity(for: node)
            node.position.y += scene.floorLevel - 10
            entityController.add(entity)
        }
    }
}
