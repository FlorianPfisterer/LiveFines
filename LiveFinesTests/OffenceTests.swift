//
//  OffenceTests.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import XCTest
@testable import LiveFines

final class OffenceTests: XCTestCase
{
    // MARK: - Test Computed Properties
    func testCorrectDelta()
    {
        let offence = Offence(speed: 34, limit: 30)
        XCTAssertNotNil(offence)
        XCTAssertEqual(offence!.delta, 4)
    }
}