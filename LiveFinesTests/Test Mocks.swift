//
//  Test Mocks.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

@testable import LiveFines

struct TestURLRequestHandler: URLRequestHandler
{ 
    // test request function returns the parameters after 1 second
    func request(method: Alamofire.Method, _ url: URLStringConvertible, parameters: [String : AnyObject]?, completion: (Response<AnyObject, NSError>) -> Void)
    {
        async(1) {
            let response = Response<AnyObject, NSError>(request: nil, response: nil, data: nil, result: Alamofire.Result.Success(parameters!))
            completion(response)
        }
    }
}

struct TestAPIInformation: APIAccessInformation
{
    typealias InputDataType = String
    
    static var baseURL: String {
        return "test URL"
    }
    
    static var requestMethod: Alamofire.Method {
        return .GET
    }
    
    // returns inputData for "content" key
    static func apiParameters(forInputData inputData: String) -> [String : AnyObject]
    {
        return ["content" : inputData]
    }
}

struct TestJSONData: JSONDataType
{
    let content: String
    
    init?(json: JSON)
    {
        guard let content = json["content"].string else { return nil }
        self.content = content
    }
}

extension String: SignificanceComparable
{
    func significantChanges(to to: String) -> Bool
    {
        return self != to
    }
}
