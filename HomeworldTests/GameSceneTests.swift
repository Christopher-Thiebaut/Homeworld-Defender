//
//  GameSceneTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
import GameplayKit
@testable import Homeworld

class GameSceneTests: XCTestCase {
    
    var subject: GameScene!
    var mockEntityController: MockEntityController!
    var mockLevelNodeParser: MockLevelParser!

    override func setUpWithError() throws {
        mockEntityController = MockEntityController()
        mockLevelNodeParser = MockLevelParser()
        subject = GameScene(
            sceneEditorNode: SKNode(),
            visibleSize: CGSize(width: 200, height: 50),
            gamePlayAreaSize: CGSize(width: 2000, height: 500),
            entityController: mockEntityController,
            levelParser: mockLevelNodeParser,
            player: MockFighter.self
        )
    }

    override func tearDownWithError() throws {
        mockLevelNodeParser = nil
        mockEntityController = nil
        subject = nil
    }

    func testAwardPointsIncrementsScore() throws {
        let initialPoints = subject.score
        subject.awardPoints(5)
        XCTAssertEqual(initialPoints + 5, subject.score)
    }
    
    func testInitializationParsesLevelNode() {
        XCTAssertTrue(mockLevelNodeParser.parseEntitiesCalled)
    }
}

class MockFighter: HumanFighter {
    
}

class MockEntityController: NSObject, EntityController {
    var obstacles: Set<GKCircleObstacle> = []
    
    var difficultyLevel: Difficulty = Difficulty(difficulty: .easy)
    
    var playerAgent: GKAgent2D?
    
    var delegate: EntityControllerDelegate?
    
    func getAlienEntities() -> Set<GKAgent2D> {
        []
    }
    
    func getCivilianTargetAgents() -> Set<GKAgent2D> {
        []
    }
    
    var addedEntities = [GKEntity]()
    func add(_ entity: GKEntity) {
        addedEntities.append(entity)
    }
    
    func update(_ deltaTime: TimeInterval) {
    }
}

class MockLevelParser: LevelNodeParser {
    var parseEntitiesCalled = false
    func parseEntities(from node: SKNode, into scene: FloorContainer, withEntityController entityController: EntityController) {
        parseEntitiesCalled = true
    }
}
