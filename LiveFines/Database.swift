//
//  Database.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import RealmSwift

final class Database
{
    func realm() -> Realm?
    {
        do { return try Realm() }
        catch { return nil }
    }
}