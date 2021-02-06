//
//  LevelNodeParserTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
import SpriteKit
import GameplayKit

@testable import Homeworld

class LevelNodeParserTests: XCTestCase {
    
    var subject: LevelNodeParser!
    var mockEntityController: MockEntityController!
    var mockFactory: MockSceneEditorNodeFactory!

    override func setUpWithError() throws {
        mockEntityController = MockEntityController()
        mockFactory = MockSceneEditorNodeFactory()
        subject = LevelNodeParserImp(factory: mockFactory)
    }

    override func tearDownWithError() throws {
        mockFactory = nil
        mockEntityController = nil
        subject = nil
    }

    func testParseEntities() throws {
        let levelNode = SKNode()
        let nodes = [
            TreeNode(),
            BigBuildingNode(),
            SmallBuildingNode(),
            RockNode()
        ]
        let originalPositions = nodes.map { $0.position }
        nodes.forEach { levelNode.addChild($0) }
        
        let sceneNode = TestBaseLineNode()
        subject.parseEntities(
            from: levelNode,
            into: sceneNode,
            withEntityController: mockEntityController
        )
        
        let addedEntities = mockEntityController.addedEntities
        XCTAssertEqual(addedEntities.count, nodes.count)
        
        let newPositions = nodes.map { $0.position }
        for offset in originalPositions.indices {
            let originalPosition = originalPositions[offset]
            let newPosition = newPositions[offset]
            let expectedYPositionChange = sceneNode.floorLevel - 10
            XCTAssertEqual(newPosition.y, originalPosition.y + expectedYPositionChange)
        }
    }
}

class TestBaseLineNode: SKNode, BaseLineNode {
    var floorLevel: CGFloat = 0
}

class MockSceneEditorNodeFactory: SceneEditorNodeFactory {
    var requestedNodes = [SceneEditorNode]()
    var returnValue = GKEntity()
    func createEntity(for node: SceneEditorNode) -> GKEntity {
        requestedNodes.append(node)
        return returnValue
    }
}
