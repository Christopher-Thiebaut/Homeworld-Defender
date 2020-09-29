//
//  EntityControllerTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 9/28/20.
//  Copyright © 2020 Christopher Thiebaut. All rights reserved.
//

import XCTest
import SpriteKit
import GameplayKit
@testable import Homeworld

class EntityControllerTests: XCTestCase {
    
    var subject: EntityController!

    override func setUpWithError() throws {
        subject = EntityController(difficulty: .easy)
    }

    func testAddBuilding() throws {
        let node = SKSpriteNode()
        let testEntity = Building(spriteNode: node, health: 1, entityController: subject)
        let agent = PassiveAgent(spriteNode: node)
        testEntity.addComponent(agent)
        let teamComponent = TeamComponent(team: .environment)
        testEntity.addComponent(teamComponent)
        subject.add(testEntity)
        XCTAssert(subject.buildingAgents.contains(agent))
        XCTAssert(subject.entities.contains(testEntity))
    }
    
    func testRemoveRemovesSpriteFromParent() throws {
        let node = SKSpriteNode()
        let parent = SKSpriteNode()
        parent.addChild(node)
        
        let entity = GKEntity()
        let spriteComponent = SpriteComponent(spriteNode: node)
        entity.addComponent(spriteComponent)
        
        subject.remove(entity)
        XCTAssertNil(node.parent)
    }
    
    func testUpdateRemovesEntitiesInToRemove() throws {
        let entity = GKEntity()
        subject.toRemove.insert(entity)
        subject.update(1)
        XCTAssert(subject.toRemove.isEmpty)
    }
}

class FakeEntityControllerDelegate: EntityControllerDelegate {
    var floorLevel: CGFloat = 0
    
    var addedChildren = [SKNode]()
    func addChild(_ sprite: SKNode) {
        addedChildren.append(sprite)
    }
    
    var inputPoint: CGPoint?
    var outputPoint: CGPoint?
    func convert(_ point: CGPoint, from node: SKNode) -> CGPoint {
        inputPoint = point
        return outputPoint ?? .zero
    }
}
