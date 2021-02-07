//
//  HealthComponentTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 10/15/20.
//  Copyright © 2020 Christopher Thiebaut. All rights reserved.
//

import XCTest
import GameplayKit

@testable import Homeworld

class HealthComponentTests: XCTestCase {
    
    var subject: HealthComponent?
    let healthAmount = 1000
    
    override func setUpWithError() throws {
        subject = HealthComponent(
            health: healthAmount
        )
    }
    
    func testDoDamageAndHeal() {
        subject?.changeHealthBy(-100)
        XCTAssertEqual(subject?.health, healthAmount - 100)
        subject?.changeHealthBy(200)
        XCTAssertEqual(subject?.health, healthAmount)
    }
    
    func testKillEntity() {
        let entity = GKEntity()
        entity.addComponent(subject!)
        subject?.changeHealthBy(-healthAmount)
        XCTAssertNotNil(entity.component(ofType: Tombstone.self))
    }
}
