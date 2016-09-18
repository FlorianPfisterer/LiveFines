//
//  Functions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Dispatch Handy Functions
func async(_ delay: Double = 0, block: @escaping () -> Void)
{
    if delay <= 0
    {
        DispatchQueue.main.async(execute: block)
    }
    else
    {
        let after: DispatchTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: after, execute: block)
    }
}

// MARK: - Log & Debug
private enum PrintTag: String
{
    case info
    case error
}

private func print(tag: PrintTag, description: String)
{
    print("\(tag.rawValue.uppercased()): \(description)")
}

struct Log
{
    static func info(_ description: String)
    {
        print(tag: .info, description: description)
    }
    
    static func error(_ error: LFError)
    {
        print(tag: .error, description: error.description)
    }
    
    static func error(specify errorType: Swift.Error)
    {
        switch errorType
        {
        case let error as RealmSwift.Error:    // Realm
            self.error(.realm(error))
            
        default:
            self.error(.local(errorType))
        }
    }
}
