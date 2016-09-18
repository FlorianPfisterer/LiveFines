//
//  HereJSONDataProvider.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation

final class HereJSONDataProvider: JSONDataProvider<CLLocation, HereSpeedLimit>
{
    init(requestHandler: URLRequestHandler)
    {
        super.init(apiInformation: HereAPIAccessInformation.reference, requestHandler: requestHandler)
    }
}
