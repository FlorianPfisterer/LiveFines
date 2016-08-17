//
//  Node.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class Node: Object
{
    dynamic var id: Int = 0
    
    // 1. CLLocation Data
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var course: Double = 0
    
    // 2. API Data
    dynamic var speedLimit: Double = 0
    dynamic var streetId: String? = nil
 
    // 3. Experience Data
    dynamic var createdAt: NSDate? = nil
    dynamic var updatedAt: NSDate? = nil
    
    dynamic var speed: Double = 0
}

extension Node
{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

extension Node
{
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    override static func indexedProperties() -> [String]
    {
        return ["latitude", "longitude", "streedId"]
    }
}
