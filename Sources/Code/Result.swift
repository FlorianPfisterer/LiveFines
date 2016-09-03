//
//  Result.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

enum Result<T>
{
    case success(T)
    case error(LFError)
}

extension Result
{
    var optional: T? {
        switch self
        {
        case .success(let t):
            return t
            
        case .error(let error):
            Log.error(specify: error)
            return nil
        }
    }
}