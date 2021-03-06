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
    
    dynamic var speed: Int = 0
    
    // 2. API Data
    dynamic var linkId: String = ""
    dynamic var speedLimit: Int = 0
 
    // 3. Experience Data
    dynamic var createdAt: Date? = nil
    dynamic var visitedAt: Date? = nil
    
    // MARK: - Init
    convenience init(location: CLLocation, speedLimit: Int, linkId: String)
    {
        self.init()
        
        self.id = UUID().uuidString
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        self.linkId = linkId
        self.speedLimit = speedLimit
        self.speed = location.kmh
        self.course = location.course
        
        let now = Date()
        self.createdAt = now
        self.visitedAt = now
    }
}

extension Node
{
    // MARK: - Realm Configuration
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    override static func indexedProperties() -> [String]
    {
        return ["latitude", "longitude", "linkId"]
    }
}

extension Node
{
    // MARK: - Public Access
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    func distance(to coordinate: CLLocationCoordinate2D) -> Double
    {
        return (coordinate - self.coordinate).length
    }

    @discardableResult
    func visit() -> Node
    {
        self.visitedAt = Date()
        return self
    }

    func shouldBeDeleted() -> Bool
    {
        // checks if node has expired and should be deleted
        guard let createdAt = self.createdAt else { return false }

        let difference = Date().timeIntervalSinceReferenceDate - createdAt.timeIntervalSinceReferenceDate
        return difference >= Constants.Config.nodeExpirationInterval
    }
}
