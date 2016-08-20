//
//  Location Extensions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation
{
    var kmh: Int {
        return Int(self.speed + 3.6)
    }
}

extension CLLocationCoordinate2D
{
    var waypointString: String {
        return "\(self.latitude),\(self.longitude)"
    }
    
    var length: Double {
        return sqrt(self.latitude * self.latitude + self.longitude * self.longitude)
    }
}

func - (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> CLLocationCoordinate2D
{
    return CLLocationCoordinate2D(latitude: lhs.latitude - rhs.latitude, longitude: lhs.longitude - rhs.longitude)
}