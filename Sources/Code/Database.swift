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
        do
        {
            return .success(try Realm())
        }
        catch let error as RealmSwift.Error
        {
            return .error(.realm(error))
        }
        catch
        {
            return .error(.local(error))
        }
    }

    static func insert(object: Object, intoRealm realm: Realm)
    {
        do
        {
            try realm.write(object: object)
        }
        catch
        {
            Log.error(specify: error)
        }
    }
    
    static func update(object: @autoclosure () -> Object, inRealm realm: Realm)
    {
        do
        {
            try realm.update(object: object)
        }
        catch
        {
            Log.error(specify: error)
        }
    }
}
