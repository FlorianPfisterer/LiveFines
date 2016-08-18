//
//  HereSpeedLimit.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HereSpeedLimit: JSONDataType
{
    private let metersPerSecond: Speed
    
    var kmh: Int {
        return Int(self.metersPerSecond * 3.6).roundToTen()
    }
    
    init?(json: JSON)
    {
        guard let speedLimit = json["response"]["link"][0]["speedLimit"].double else { return nil }
        self.metersPerSecond = speedLimit
    }
}