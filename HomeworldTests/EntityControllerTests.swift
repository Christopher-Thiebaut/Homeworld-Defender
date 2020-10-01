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
    
    func testUpdateJumpsUpThingsBelowFloor() {
        let delegate = FakeEntityControllerDelegate()
        delegate.outputPoint = CGPoint(x: 0, y: -100)
        
        subject.scene = delegate
        
        let entity = GKEntity()
        let spriteComp = SpriteComponent(spriteNode: SKSpriteNode())
        let originalPosition = spriteComp.node.position
        entity.addComponent(spriteComp)
        
        let parent = SKSpriteNode()
        parent.addChild(spriteComp.node)
        
        subject.add(entity)
        
        subject.update(1)
        XCTAssertEqual(CGPoint(x: originalPosition.x, y: originalPosition.y + 2000), spriteComp.node.position)
    }
    
    func testContactNotification() {
        let nodeA = SKSpriteNode()
        let entityA = GKEntity()
        let spriteA = SpriteComponent(spriteNode: nodeA)
        entityA.addComponent(spriteA)
        let physicsA = SKPhysicsBody(circleOfRadius: 1)
        nodeA.physicsBody = physicsA
        
        let contactA = ContactHealthModifier(spriteNode: nodeA, changeHealthBy: 0, destroySelf: false, entityController: subject)
        let delA = TestContactDelegate()
        contactA.delegate = delA
        entityA.addComponent(contactA)
        
        let nodeB = SKSpriteNode()
        let entityB = GKEntity()
        let spriteB = SpriteComponent(spriteNode: nodeB)
        entityB.addComponent(spriteB)
        let physicsB = SKPhysicsBody(circleOfRadius: 1)
        nodeB.physicsBody = physicsB
        
        let contactB = ContactHealthModifier(spriteNode: nodeB, changeHealthBy: 0, destroySelf: false, entityController: subject)
        let delB = TestContactDelegate()
        contactB.delegate = delB
        entityB.addComponent(contactB)
        
        subject.add(entityA)
        subject.add(entityB)
        
        let contact = TestableContact(bodyA: physicsA, bodyB: physicsB)
        subject.began(contact)
        
        XCTAssert(delA.contactedEntities.contains(entityB))
        XCTAssert(delB.contactedEntities.contains(entityA))
    }
}

struct TestableContact: PhysicsContact {
    var bodyA: SKPhysicsBody
    
    var bodyB: SKPhysicsBody
}

class TestContactDelegate: ContactHealthModifierDelegate {
    var contactedEntities = [GKEntity]()
    
    func contactDetected(with entity: GKEntity) {
        contactedEntities.append(entity)
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
