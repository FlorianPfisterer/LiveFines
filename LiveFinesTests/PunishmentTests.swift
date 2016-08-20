//
//  PunishmentTests.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import XCTest
@testable import LiveFines

final class PunishmentTests: XCTestCase
{
    // MARK: - Test Equality
    func testEqualPunishmentTypesAreEqual()
    {
        let twenty: Punishment = .financial(20)
        let ten: Punishment = .financial(10)
        
        XCTAssertEqual(twenty, ten)
    }
    
    func testUnequalPunishmentTypesAreUnequal()
    {
        let license: Punishment = .license(1)
        let points: Punishment = .points(3)
        
        XCTAssertNotEqual(license, points)
    }
    
    // MARK: - Test Static Functions
    func testFinancialStaticFunction()
    {
        let punishment = Punishment.financial(10)
        XCTAssert(punishment.amount == 10 && punishment.type == .financial)
    }
    
    func testPointsStaticFunction()
    {
        let punishment = Punishment.points(10)
        XCTAssert(punishment.amount == 10 && punishment.type == .points)
    }
    
    func testLicenseStaticFunction()
    {
        let punishment = Punishment.license(10)
        XCTAssert(punishment.amount == 10 && punishment.type == .license)
    }
}