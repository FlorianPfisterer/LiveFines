//
//  URLRequestHandler.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import Alamofire

protocol URLRequestHandler
{
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: [String : AnyObject]?, completion: @escaping (DataResponse<Any>) -> Void)
}

struct AlamofireRequestHandler: URLRequestHandler
{
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: [String : AnyObject]?, completion: @escaping (DataResponse<Any>) -> Void)
    {
        Alamofire.request(url, method: method, parameters: parameters, headers: nil).responseJSON(completionHandler: completion)
    }
}
