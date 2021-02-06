//
//  GameSceneTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
@testable import Homeworld

class GameSceneTests: XCTestCase {
    
    var subject: GameScene!

    override func setUpWithError() throws {
        subject = GameScene(
            visibleSize: CGSize(width: 200, height: 50),
            gamePlayAreaSize: CGSize(width: 2000, height: 500),
            player: MockFighter.self
        )
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testAwardPointsIncrementsScore() throws {
        let initialPoints = subject.score
        subject.awardPoints(5)
        XCTAssertEqual(initialPoints + 5, subject.score)
    }
}

class MockFighter: HumanFighter {
    
}
