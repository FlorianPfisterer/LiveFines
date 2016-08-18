//
//  Location Extensions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D
{
    var waypointString: String {
        return "\(self.latitude),\(self.longitude)"
    }
}