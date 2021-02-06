//
//  JoystickNodeTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/6/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest
import SpriteKit

@testable import Homeworld

class JoystickNodeTests: XCTestCase {
    
    var subject: JoystickNode!
    let size = CGSize(width: 100, height: 100)

    override func setUpWithError() throws {
        subject = JoystickNode(size: size)
    }

    override func tearDownWithError() throws {
        subject = nil
    }

    func testPostInitializationProperties() throws {
        assertInitialBallProperties()
        assertInitialRodProperties()
        assertInitialJoystickProperties()
    }
    
    func assertInitialBallProperties() {
        let ball = subject.ball
        let expectedSize = CGSize(
            width: size.width/2.2,
            height: size.height/2.2
        )
        CGSizeAssertEqual(ball.size, expectedSize)
        CGFloatAssertEqual(ball.zPosition, 0.5)
        XCTAssertTrue(ball.parent === subject)
    }
    
    func assertInitialRodProperties() {
        let rod = subject.rod
        let expectedSize = CGSize(
            width: size.width/11,
            height: size.height/11
        )
        CGSizeAssertEqual(rod.size, expectedSize)
        CGFloatAssertEqual(rod.zRotation, 0)
        CGFloatAssertEqual(rod.zPosition, 0.25)
        XCTAssertTrue(rod.parent === subject)
    }
    
    func assertInitialJoystickProperties() {
        CGSizeAssertEqual(subject.size, size)
        XCTAssertTrue(subject.isUserInteractionEnabled)
        XCTAssertEqual(subject.center, .zero)
        CGFloatAssertEqual(subject.trackingDistance, size.width/1.5)
        CGFloatAssertEqual(subject.joystickAngle, 0)
        CGFloatAssertEqual(subject.distanceOffCenter, 0)
    }
}

func CGSizeAssertEqual(
    _ s1: CGSize,
    _ s2: CGSize,
    tolerance: CGFloat = 0.0001,
    file: StaticString = #file,
    line: UInt = #line
) {
    CGFloatAssertEqual(
        s1.height, s2.height,
        tolerance: tolerance,
        file: file,
        line: line
    )
    CGFloatAssertEqual(
        s1.width, s2.width,
        tolerance: tolerance,
        file: file,
        line: line
    )
}

func CGFloatAssertEqual(
    _ f1: CGFloat,
    _ f2: CGFloat,
    tolerance: CGFloat = 0.0001,
    file: StaticString = #file,
    line: UInt = #line
) {
    let upperBound = f1 + tolerance
    let lowerBound = f1 - tolerance
    if f2 > upperBound {
        XCTFail(
            "\(f2) is more than \(tolerance) greater than \(f1)",
            file: file,
            line: line
        )
    }
    if f2 < lowerBound {
        XCTFail(
            "\(f2) is more than \(tolerance) less than \(f1)",
            file: file,
            line: line
        )
    }
}
