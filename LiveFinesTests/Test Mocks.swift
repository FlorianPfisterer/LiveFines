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
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: [String : AnyObject]?, completion: @escaping (DataResponse<Any>) -> Void)
    {
        async(1) {
            let response = DataResponse<Any>(request: nil, response: nil, data: nil, result: Alamofire.Result.success(parameters!))
            completion(response)
        }
    }
}

final class TestAPIInformation: APIAccessInformation<String>
{
    typealias Input = String
    
    override var baseURL: String {
        return "test URL"
    }
    
    override var requestMethod: Alamofire.HTTPMethod {
        return .get
    }
    
    // returns inputData for "content" key
    override func apiParameters(for input: String) -> [String : Any]
    {
        return ["content" : input]
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
    func significantChanges(to: String) -> Bool
    {
        return self != to
    }
}
