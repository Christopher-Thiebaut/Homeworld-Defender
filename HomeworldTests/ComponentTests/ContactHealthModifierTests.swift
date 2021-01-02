//
//  ContactHealthModifierTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 10/15/20.
//  Copyright © 2020 Christopher Thiebaut. All rights reserved.
//

import XCTest
import SpriteKit
import GameplayKit

@testable import Homeworld

class ContactHealthModifierTests: XCTestCase {
    var subject: ContactHealthModifier!
    let healthEffect = -100
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        subject = ContactHealthModifier(
            changeHealthBy: healthEffect,
            destroySelf: true,
            doNotHarm: [.environment]
        )
    }

    func testCollidingWithAHostileEntityRemovesHealth() {
        let entity = GKEntity()
        let health = HealthComponent(health: 500)
        entity.addComponent(health)
        subject?.contactDetectedWith(entity: entity)
        XCTAssertEqual(health.health, 400)
    }
    
    func testDestroySelf() {
        let subjectEntity = GKEntity()
        subjectEntity.addComponent(subject)
        
        let otherEntity = GKEntity()
        
        subject?.contactDetectedWith(entity: otherEntity)
        
        XCTAssertNotNil(subjectEntity.component(ofType: Tombstone.self))
    }
}
