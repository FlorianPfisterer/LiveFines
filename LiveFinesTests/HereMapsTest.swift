//
//  HereMapsTest.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LiveFines

final class HereMapsTests: XCTestCase
{
    var requestHandler: AlamofireRequestHandler!
    var dataProvider: HereJSONDataProvider!
    
    override func setUp()
    {
        super.setUp()
        
        self.requestHandler = AlamofireRequestHandler()
        self.dataProvider = HereJSONDataProvider(requestHandler: requestHandler)
    }
    
    func testHereAPIReturnsCorrectSpeedLimit()
    {
        let expectation = self.expectationWithDescription("Here Maps API should return the correct speed limit: 70")
        let location = CLLocation(latitude: 48.611442, longitude: 8.881654)
        
        self.dataProvider.registerCallback { result in
            switch result
            {
            case .error(let error):
                XCTFail("\(error)")
                
            case .success((let speedLimit, let fromLocation)):
                XCTAssertEqual(speedLimit.kmh, 70)
                XCTAssertEqual(location, fromLocation)
                expectation.fulfill()
            }
        }
        
        self.dataProvider.updateInputData(location)
        
        self.waitForExpectationsWithTimeout(4) { error in
            if let error = error { print(error.localizedDescription) }
        }
    }
}