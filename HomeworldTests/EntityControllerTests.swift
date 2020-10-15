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
        let testBuilding = getBuildingEntity()
        subject.add(testBuilding.entity)
        XCTAssert(subject.buildingAgents.contains(testBuilding.agent!))
        XCTAssert(subject.entities.contains(testBuilding.entity))
    }
    
    func testChangingSceneResetsEntitiesAndToRemove() {
        let e1 = GKEntity()
        let e2 = GKEntity()
        subject.add(e1)
        subject.add(e2)
        subject.remove(e2)
        let scene = FakeEntityControllerDelegate()
        subject.scene = scene
        XCTAssert(subject.entities.isEmpty)
        XCTAssert(subject.toRemove.isEmpty)
    }
    
    func testRemoveRemovesSpriteFromParent() throws {
        let building = getBuildingEntity()
        let parent = SKSpriteNode()
        parent.addChild(building.node)
        subject.add(building.entity)
        
        subject.remove(building.entity)
        XCTAssertNil(building.node.parent)
    }
    
    func testRemoveBuildingGetsRidOfAgent() throws {
        let building = getBuildingEntity()
        subject.add(building.entity)
        subject.remove(building.entity)
        XCTAssertFalse(subject.buildingAgents.contains(building.agent!))
    }
    
    func testUpdateRemovesEntitiesInToRemove() throws {
        let entity = GKEntity()
        subject.toRemove.insert(entity)
        subject.update(1)
        XCTAssert(subject.toRemove.isEmpty)
    }
    
    func testUpdateJumpsUpThingsBelowFloor() {
        let delegate = FakeEntityControllerDelegate()
        subject.scene = delegate
        delegate.outputPoint = CGPoint(x: 0, y: -100)
        let alien = getAlienEntity()
        let originalPosition = alien.node.position
        subject.add(alien.entity)
        
        let parent = SKSpriteNode()
        parent.addChild(alien.node)
        
        subject.update(1)
        XCTAssertEqual(CGPoint(x: originalPosition.x, y: originalPosition.y + 2000), alien.node.position)
    }
    
    func testContactNotification() {
        let nodeA = SKSpriteNode()
        let entityA = GKEntity()
        let spriteA = SpriteComponent(spriteNode: nodeA)
        entityA.addComponent(spriteA)
        let physicsA = SKPhysicsBody(circleOfRadius: 1)
        nodeA.physicsBody = physicsA
        
        let contactA = ContactHealthModifier(spriteNode: nodeA, changeHealthBy: 0, destroySelf: false, entityRemovalDelegate: subject)
        let delA = TestContactDelegate()
        contactA.delegate = delA
        entityA.addComponent(contactA)
        
        let nodeB = SKSpriteNode()
        let entityB = GKEntity()
        let spriteB = SpriteComponent(spriteNode: nodeB)
        entityB.addComponent(spriteB)
        let physicsB = SKPhysicsBody(circleOfRadius: 1)
        nodeB.physicsBody = physicsB
        
        let contactB = ContactHealthModifier(spriteNode: nodeB, changeHealthBy: 0, destroySelf: false, entityRemovalDelegate: subject)
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
    
    func testGetCivilianTargets() {
        let entities: [TestEntity] = [getBuildingEntity(), getBuildingEntity(), getAlienEntity(), getAlienEntity(), getAlienEntity()]
        entities.forEach {
            subject.add($0.entity)
        }
        XCTAssertEqual(subject.getCivilianTargetAgents().count, 2)
    }
    
    func testGetAliens() {
        let entities: [TestEntity] = [getBuildingEntity(), getBuildingEntity(), getAlienEntity(), getAlienEntity(), getAlienEntity()]
        entities.forEach {
            subject.add($0.entity)
        }
        XCTAssertEqual(subject.getAlienEntities().count, 3)
    }
    
    func getBuildingEntity() -> TestEntity {
        let node = SKSpriteNode()
        let entity = Building(spriteNode: node, health: 1, entityController: subject)
        return TestEntity(node: node, agent: entity.component(ofType: PassiveAgent.self)!, entity: entity)
    }
    
    func getAlienEntity() -> TestEntity {
        let node = SKSpriteNode()
        let sprite = SpriteComponent(spriteNode: node)
        
        let agent = RaiderAgent(
            findTargets: { [] },
            findObstacles: { [] },
            findEnemy: { nil },
            distanceFromAvoid: 0,
            maxSpeed: 0,
            maxAcceleration: 0,
            radius: 0,
            entityController: subject
        )
        
        let team = TeamComponent(team: .alien)
        
        let entity = GKEntity()
        entity.addComponent(sprite)
        entity.addComponent(agent)
        entity.addComponent(team)
        
        return TestEntity(node: node, agent: agent, entity: entity)
    }
    
    func testUpdateIsCalledOnComponentSystems() {
        let componentSystem = SpyComponentSystem(componentClass: HealthComponent.self)
        subject = EntityController(difficulty: .easy, componentSystems: [componentSystem])
        let entity = getBuildingEntity()
        subject.add(entity.entity)
        subject.update(1)
        subject.update(2)
        XCTAssert(componentSystem.addComponentEntities.first === entity.entity)
        XCTAssertEqual(componentSystem.updateDTs, [1, 2])
    }
    
    func testComponentsAreRemovedForRemovedEnitities() {
        let componentSystem = SpyComponentSystem(componentClass: HealthComponent.self)
        subject = EntityController(difficulty: .easy, componentSystems: [componentSystem])
        let entity = getBuildingEntity()
        subject.add(entity.entity)
        subject.remove(entity.entity)
        subject.update(1)
        XCTAssertTrue(componentSystem.removeComponentEntities.contains(entity.entity))
    }
    
    func testRemovingHumanFighterSetsPlayerAgentToNil() {
        let fighter = HumanFighter(entityController: subject, propulsionControl: FakePropulsion(), rotationControl: FakeRotation())
        subject.add(fighter)
        XCTAssertNotNil(subject.playerAgent)
        subject.remove(fighter)
        XCTAssertNil(subject.playerAgent)
    }
    
    func testRemovingAlienRemovesFromAgentGroup() {
        let alien = getAlienEntity()
        subject.add(alien.entity)
        XCTAssert(subject.getAlienEntities().contains(alien.agent!))
        subject.remove(alien.entity)
        XCTAssertTrue(subject.getAlienEntities().isEmpty)
    }
    
    func testRemovingBuildingRemovesFromAgentGroup() {
        let building = getBuildingEntity()
        subject.add(building.entity)
        XCTAssert(subject.getCivilianTargetAgents().contains(building.agent!))
        subject.remove(building.entity)
        XCTAssert(subject.getCivilianTargetAgents().isEmpty)
    }
    
    func testEntityWithObstacleAddedToObstaclesAndRemoved() {
        let building = getBuildingEntity()
        subject.add(building.entity)
        XCTAssertEqual(subject.obstacles.count, 1)
        subject.remove(building.entity)
        XCTAssert(subject.obstacles.isEmpty)
    }
}

struct TestEntity {
    var node: SKSpriteNode
    var agent: GKAgent2D?
    var entity: GKEntity
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

class SpyComponentSystem: GKComponentSystem<GKComponent> {
    var addComponentEntities = [GKEntity]()
    
    override func addComponent(foundIn entity: GKEntity) {
        super.addComponent(foundIn: entity)
        addComponentEntities.append(entity)
    }
    
    var removeComponentEntities = [GKEntity]()
    override func removeComponent(foundIn entity: GKEntity) {
        super.removeComponent(foundIn: entity)
        removeComponentEntities.append(entity)
    }
    
    var updateDTs = [TimeInterval]()
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        updateDTs.append(seconds)
    }
}

class FakePropulsion: PropulsionControl {
    func shouldApplyThrust() -> Bool {
        false
    }
    
    func magnitude() -> CGFloat {
        0
    }
}

class FakeRotation: RotationControl {
    func angle() -> CGFloat {
        0
    }
}
