//
//  APIAccessInformation.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Alamofire

class APIAccessInformation<Input> where Input: Equatable, Input: SignificanceComparable
{
    var baseURL: String {
        return "localhost"
    }
    var requestMethod: Alamofire.HTTPMethod {
        return .get
    }

    func apiParameters(for input: Input) -> [String : Any]
    {
        return [:]  // implemented by subclass
    }
}
