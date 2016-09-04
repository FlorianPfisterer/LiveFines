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
    func request(method: Alamofire.Method, _ url: URLStringConvertible, parameters: [String : AnyObject]?, completion: (Alamofire.Response<AnyObject, NSError>) -> Void)
}

struct AlamofireRequestHandler: URLRequestHandler
{
    func request(method: Alamofire.Method, _ url: URLStringConvertible, parameters: [String : AnyObject]?, completion: (Alamofire.Response<AnyObject, NSError>) -> Void)
    {
        Alamofire.request(method, url, parameters: parameters).responseJSON(completionHandler: completion)
    }
}
