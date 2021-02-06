//
//  SceneBuilderNodes.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import SpriteKit

class TreeNode: SKSpriteNode, SceneEditorNode {
    var nodeType: SceneEditorNodeType = .tree
}

class RockNode: SKSpriteNode, SceneEditorNode {
    var nodeType: SceneEditorNodeType = .rock
}

class SmallBuildingNode: SKSpriteNode, SceneEditorNode {
    var nodeType: SceneEditorNodeType = .smallBuilding
}

class BigBuildingNode: SKSpriteNode, SceneEditorNode {
    var nodeType: SceneEditorNodeType = .largeBuilding
}

class RepairFactoryNode: SKSpriteNode, SceneEditorNode {
    var nodeType: SceneEditorNodeType = .repairFactory
}
