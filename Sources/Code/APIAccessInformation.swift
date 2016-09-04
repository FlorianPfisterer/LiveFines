//
//  APIAccessInformation.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Alamofire

protocol APIAccessInformation
{
    associatedtype InputDataType: Equatable, SignificanceComparable
    
    static var requestMethod: Alamofire.Method { get }
    static var baseURL: String { get }
    
    static func apiParameters(forInputData inputData: InputDataType) -> [String : AnyObject]
}