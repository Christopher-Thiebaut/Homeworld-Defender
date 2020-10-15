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
    var subject: ContactHealthModifier?
    var node: SKSpriteNode?
    let healthEffect = -100
    
    //EntityRemovalDelegate
    var removedEntity: GKEntity?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        node = SKSpriteNode()
        subject = ContactHealthModifier(
            spriteNode: node!,
            changeHealthBy: healthEffect,
            destroySelf: true,
            doNotHarm: [.environment],
            entityRemovalDelegate: self
        )
    }
    //TODO: FINISH TESTING ENTITY AFTER ISSUES CREATING HEALTH COMPONENT ARE RESOLVED
//    func testCollidingWithAHostileEntityRemovesHealth() {
//        let entity = GKEntity()
//        let health = HealthComponent(health: <#T##Int#>, entityController: <#T##EntityController#>)
//    }
}

extension ContactHealthModifierTests: EntityRemovalDelegate {
    func remove(_ entity: GKEntity) {
        removedEntity = entity
    }
}
