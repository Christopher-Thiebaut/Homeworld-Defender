//
//  SceneEditorFactory.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum SceneEditorNodeType {
    case tree
    case rock
    case smallBuilding
    case largeBuilding
    case repairFactory
}

protocol SceneEditorNode: SKSpriteNode {
    var nodeType: SceneEditorNodeType { get }
}

protocol SceneEditorNodeFactory {
    func createEntity(for node: SceneEditorNode) -> GKEntity
}

class SceneEditorFactoryImp: SceneEditorNodeFactory {
    func createEntity(for node: SceneEditorNode) -> GKEntity {
        switch node.nodeType {
        case .tree:
            return Tree(spriteNode: node)
        case .rock:
            return Rock(spriteNode: node)
        case .smallBuilding:
            return Building(spriteNode: node, health: 100)
        case .largeBuilding:
            return Building(spriteNode: node, health: 200)
        case .repairFactory:
            return RepairFactory(
                spriteNode: node,
                health: 200,
                baseRepairFrequency: 30,
                variation: 5,
                restoreHealth: 50
            )
        }
    }
}
