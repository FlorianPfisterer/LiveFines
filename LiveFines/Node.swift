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
    dynamic var id: String? = nil
    
    // 1. CLLocation Data
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var course: Double = 0
    
    // 2. API Data
    dynamic var speedLimit: Int = 0
    dynamic var streetId: String? = nil
 
    // 3. Experience Data
    dynamic var createdAt: NSDate? = nil
    dynamic var visitedAt: NSDate? = nil
    
    dynamic var speed: Double = 0
    
    // MARK: - Init
    convenience init(coordinate: CLLocationCoordinate2D, speedLimit: Int)
    {
        self.init()
        
        self.id = NSUUID().UUIDString
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.speedLimit = speedLimit
    }
}

extension Node
{
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func distance(to coordinate: CLLocationCoordinate2D) -> Double
    {
        return (coordinate - self.coordinate).length
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
