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
    
    var removedEntity: GKEntity?
    
    override func setUpWithError() throws {
        subject = HealthComponent(
            health: healthAmount,
            removalDelegate: self
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
        subject?.changeHealthBy(-(healthAmount + 1))
        XCTAssert(removedEntity === entity)
    }
    
    //TODO: MAKE TESTABLE
//    func testImpactOnContact() {
//        let entity = GKEntity()
//        let impactFeedbackComponent = ImpactFeedbackComponent(feedbackStyle: .medium)
//        entity.addComponent(impactFeedbackComponent)
//        entity.addComponent(subject!)
//        subject?.changeHealthBy(-1)
//    }

}

extension HealthComponentTests: EntityRemovalDelegate {
    func remove(_ entity: GKEntity) {
        removedEntity = entity
    }
}
