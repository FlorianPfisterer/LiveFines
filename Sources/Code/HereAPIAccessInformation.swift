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

final class HereAPIAccessInformation: APIAccessInformation<CLLocation>
{
    static var reference = HereAPIAccessInformation()
    
    // MARK: - Properties
    override var baseURL: String {
        return "https://route.api.here.com/routing/7.2/getlinkinfo.json"
    }
    
    override var requestMethod: Alamofire.HTTPMethod {
        return .get
    }
    
    // MARK: - Parameter Building
    enum Key: String
    {
        case appId = "app_id"
        case appCode = "app_code"
        case waypoint = "waypoint"
    }
    
    override func apiParameters(for input: CLLocation) -> [String : Any]
    {
        var parameters = [String : Any]()
        
        parameters[Key.appCode.rawValue] = Secrets.appCode
        parameters[Key.appId.rawValue] = Secrets.appId
        parameters[Key.waypoint.rawValue] = input.coordinate.waypointString
        
        return parameters
    }
}
