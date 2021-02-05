//
//  AirfoilComponentTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/5/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Homeworld

class AirfoilComponentTests: XCTestCase {

    func testAirfoilProducesLift() throws {
        let physicsBody = SKPhysicsBody(circleOfRadius: 1)
        let initialVelocity = CGVector(dx: 2, dy: 0)
        physicsBody.velocity = initialVelocity
        let subject = AirfoilComponent(physicsBody: physicsBody, liftRatio: 2)
        
        subject.update(deltaTime: 1)
        
        XCTAssertEqual(physicsBody.velocity, CGVector(dx: 2, dy: initialVelocity.dx * subject.liftRatio))
    }
}
