//
//  SceneEditorNodeFactoryTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
import GameplayKit
@testable import Homeworld

class SceneEditorNodeFactoryTests: XCTestCase {
    var subject: SceneEditorNodeFactory!
    
    override func setUpWithError() throws {
        subject = SceneEditorFactoryImp()
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testCreateTree() throws {
        let tree = subject.createEntity(for: TreeNode())
        XCTAssertTrue(tree is Tree)
    }
    
    func testCreateRock() throws {
        let rock = subject.createEntity(for: RockNode())
        XCTAssertTrue(rock is Rock)
    }
    
    func testCreateSmallBuilding() throws {
        let building = subject.createEntity(for: SmallBuildingNode())
        assertBuilding(building, hasHealth: 100)
    }
    
    func testCreateLargeBuilding() throws {
        let building = subject.createEntity(for: BigBuildingNode())
        assertBuilding(building, hasHealth: 200)
    }
    
    func testCreateRepairFactory() throws {
        let factory = subject.createEntity(for: RepairFactoryNode())
        assertBuilding(factory, hasHealth: 200)
        XCTAssertTrue(factory is RepairFactory)
    }
    
    func assertBuilding(_ entity: GKEntity, hasHealth expectedHealth: Int) {
        XCTAssertTrue(entity is Building)
        let health = entity.component(ofType: HealthComponent.self)?.health
        XCTAssertEqual(health, expectedHealth)
    }
}

