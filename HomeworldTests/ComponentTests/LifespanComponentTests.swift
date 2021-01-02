//
//  LifespanComponentTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 1/2/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
import GameplayKit
@testable import Homeworld

class LifespanComponentTests: XCTestCase {
    
    var subject: LifespanComponent!

    override func setUpWithError() throws {
        subject = LifespanComponent(lifespan: 30)
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testEntityDiesWhenExpired() throws {
        let entity = GKEntity()
        entity.addComponent(subject)
        entity.update(deltaTime: 30)
        XCTAssertNotNil(entity.component(ofType: Tombstone.self))
    }
}
