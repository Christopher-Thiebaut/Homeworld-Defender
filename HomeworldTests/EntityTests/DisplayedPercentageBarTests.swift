//
//  DisplayedPercentageBarTests.swift
//  HomeworldTests
//
//  Created by Christopher Thiebaut on 2/7/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import XCTest

@testable import Homeworld

class DisplayedPercentageBarTests: XCTestCase {
    
    var subject: DisplayedPercentageBar!
    var mockQuantity: MockPercentageBarQuantity!

    override func setUpWithError() throws {
        mockQuantity = MockPercentageBarQuantity()
        subject = DisplayedPercentageBar(
            initialSize: CGSize(width: 200, height: 10),
            color: .blue,
            backgroundColor: .white,
            initialPosition: .zero,
            quantityToMonitor: mockQuantity
        )
    }

    override func tearDownWithError() throws {
        mockQuantity = nil
        subject = nil
    }

    func testComponentConfiguration() throws {
        let percentageComponent = subject.component(ofType: PercentageBarComponent.self)
        let monitoredQuantity = percentageComponent?.quantityToMonitor
        XCTAssertEqual(monitoredQuantity?.maximumQuantity, mockQuantity.maximumQuantity)
        XCTAssertEqual(monitoredQuantity?.quantityRemaining, mockQuantity.quantityRemaining)
        
        XCTAssertNotNil(subject.component(ofType: SpriteComponent.self))
    }
}

class MockPercentageBarQuantity: PercentageBarQuantity {
    var quantityRemaining: CGFloat = 0.65
    
    var maximumQuantity: CGFloat = 0.99
}
