//
//  PenaltyTests.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import XCTest
@testable import LiveFines

final class PenaltyTests: XCTestCase
{
    // MARK: - Test Integrity
    func testPenaltyReturnsPunishment()
    {
        let financial: Punishment = .financial(10)
        let license: Punishment = .license(2)
        let punishments = [financial, license]
        let penalty = Penalty(multiple: punishments)
        
        XCTAssertEqual(penalty[.financial], financial)
        XCTAssertNotNil(penalty[.license])
    }
}
