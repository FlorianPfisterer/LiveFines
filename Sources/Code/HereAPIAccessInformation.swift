//
//  HereAPIAccessInformation.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

private let appId = "Qd4a8YBWlFjVWxik2bTm"
private let appCode = "bCqAd4B8AD6MCTpM9Yh0cw"

struct HereAPIAccessInformation: APIAccessInformation
{
    typealias InputDataType = CLLocation
    
    // MARK: - Properties
    static var baseURL: String {
        return "http://route.st.nlp.nokia.com/routing/7.2/getlinkinfo.json"
    }
    
    static var requestMethod: Alamofire.Method {
        return .GET
    }
    
    // MARK: - Parameter Building
    enum Key: String
    {
        case appId = "app_id"
        case appCode = "app_code"
        case waypoint = "waypoint"
    }
    
    static func apiParameters(forInputData inputData: CLLocation) -> [String : AnyObject]
    {
        var parameters = [String : AnyObject]()
        
        parameters[Key.appCode.rawValue] = appCode
        parameters[Key.appId.rawValue] = appId
        parameters[Key.waypoint.rawValue] = inputData.coordinate.waypointString
        
        return parameters
    }
}