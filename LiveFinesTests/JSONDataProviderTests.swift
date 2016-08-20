//
//  JSONDataProviderTests.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import XCTest
@testable import LiveFines

final class JSONDataProviderTests: XCTestCase
{
    var handler: TestURLRequestHandler!
    var dataProvider: JSONDataProvider<String, TestJSONData, TestAPIInformation>!
    
    override func setUp()
    {
        super.setUp()
        
        self.handler = TestURLRequestHandler()
        self.dataProvider = JSONDataProvider<String, TestJSONData, TestAPIInformation>(TestAPIInformation.self, requestHandler: self.handler)
    }
    
    // MARK: - Test Callback Management
    func testJSONProviderCallsCallback()
    {
        let expectation = self.expectationWithDescription("JSONDataProvider should call a callback that has been registered")
        
        _ = self.dataProvider.registerCallback({ result in
            switch result
            {
            case .success(_):
                expectation.fulfill()
                
            case .error(let error):
                XCTFail("\(error)")
            }
        })
        self.dataProvider.updateInputData("Hello")  // should call the callback after about 1 second (with .Success)
        
        self.waitForExpectationsWithTimeout(3) { error in
            if let error = error
            {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func testJSONProviderDoesNotCallCallback()
    {
        let expectation = self.expectationWithDescription("JSONDataProvider should not call a callback that has been unregistered")
        
        let id = self.dataProvider.registerCallback({ _ in
            XCTFail("Should not called a callback that has been unregistered")
        })
        self.dataProvider.unregisterCallback(withId: id)
        
        self.dataProvider.updateInputData("Hello")
        async(2) {
            // if the callback hasn't been called yet; fulfill the expectation
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(3) { error in
            if let error = error
            {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Output
    func testJSONProviderReturnsRightOutput()
    {
        let expectation = self.expectationWithDescription("JSONDataProvider should return the correct result")
        let input = "testInput"
        
        self.dataProvider.registerCallback { result in
            switch result
            {
            case .success((let output, let fromInput)):
                XCTAssertEqual(output.content, input)
                XCTAssertEqual(input, fromInput)
                expectation.fulfill()
                
            case .error(let error):
                XCTFail("\(error)")
            }
        }
        
        self.dataProvider.updateInputData(input)
        
        self.waitForExpectationsWithTimeout(3) { error in
            if let error = error
            {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
}
