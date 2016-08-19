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
    // MARK: - General
    static func realm() -> Result<Realm>
    {
        do { return .success(try Realm()) }
        catch { return .error(.other("\(error)")) }
    }
}

extension Database
{
    static func insert(node node: Node, intoRealm realm: Realm)
    {
        do
        {
            try realm.write(object: node)
        }
        catch
        {
            print("ERROR: \(error)")    // TODO
        }
    }
}