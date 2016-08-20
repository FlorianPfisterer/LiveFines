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
    
    func update(@autoclosure object object: () -> Object) throws
    {
        try self.write { self.add(object(), update: true) }
    }
}