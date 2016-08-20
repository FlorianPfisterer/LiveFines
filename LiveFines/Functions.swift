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
func async(delay: Double = 0, block: () -> Void)
{
    if delay <= 0
    {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    else
    {
        let after: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(after, dispatch_get_main_queue(), block)
    }
}

// MARK: - Log & Debug
private enum PrintTag: String
{
    case info
    case error
}

private func print(tag tag: PrintTag, description: String)
{
    print("\(tag.rawValue.uppercaseString): \(description)")
}

struct Log
{
    static func info(description: String)
    {
        print(tag: .info, description: description)
    }
    
    static func error(error: LFError)
    {
        print(tag: .error, description: error.description)
    }
    
    static func error(specify errorType: ErrorType)
    {
        switch errorType
        {
        case let error as Error:    // Realm
            self.error(.realm(error))
            
        default:
            self.error(.local(errorType))
        }
    }
}