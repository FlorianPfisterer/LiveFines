//
//  Node Queries.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

extension Node
{
    static func node(closeToLocation location: CLLocation, inRealm realm: Realm) -> Node?
    {
        let coordinate = location.coordinate
        let (minLongitude, maxLongitude) = Constants.Config.coordinateRange(forDegrees: coordinate.longitude)
        let (minLatitude, maxLatitude) = Constants.Config.coordinateRange(forDegrees: coordinate.latitude)
        
        let (minCourse, maxCourse) = Constants.Config.courseRange(forCourse: location.course)
        let (minSpeed, maxSpeed) = Constants.Config.speedRange(forSpeed: location.kmh)

        print("FOUND: \(realm.objects(Node.self).count) objects!")
        
        let results = realm.objects(Node.self)
            .filter("longitude >= %f AND longitude < %f AND latitude >= %f AND latitude < %f AND course >= %f AND course < %f AND speed >= %d AND speed < %d",
                    minLongitude, maxLongitude,
                    minLatitude, maxLatitude,
                    minCourse, maxCourse,
                    minSpeed, maxSpeed)
        
        // sort by the closes Node first
        let nodes = Array(results).sort({ $0.distance(to: coordinate) < $1.distance(to: coordinate) })
        return nodes.first
    }
}