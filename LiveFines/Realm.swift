//
//  Realm.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

extension Realm
{
    // MARK: - General
    func write(object object: Object) throws
    {
        try self.write { self.add(object) }
    }
}

extension Realm
{
    func node(closeToLocation location: CLLocation) -> Node?
    {
        let coordinate = location.coordinate
        let (minLongitude, maxLongitude) = (coordinate.longitude - Constants.Config.coordinateSpan, coordinate.longitude + Constants.Config.coordinateSpan)
        let (minLatitude, maxLatitude) = (coordinate.latitude - Constants.Config.coordinateSpan, coordinate.latitude + Constants.Config.coordinateSpan)
        
        let results = self.objects(Node.self)
                    .filter("longitude >= %f AND longitude < %f AND latitude >= %f AND latitude < %f", minLongitude, maxLongitude, minLatitude, maxLatitude)
        
        // sort by the closes Node first
        let nodes = Array(results).sort({ $0.distance(to: coordinate) < $1.distance(to: coordinate) })
        return nodes.first
    }
}