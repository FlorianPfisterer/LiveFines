//
//  AppDelegate.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.cleanupNodes()
        return true
    }
}

extension AppDelegate
{
    fileprivate func cleanupNodes()
    {
        // query for nodes that should be deleted and delete them
        switch Database.realm()
        {
        case .success(let realm):
            realm.objects(Node.self).filter  { $0.shouldBeDeleted() }.each { realm.delete($0) }

        default: return
        }
    }
}
