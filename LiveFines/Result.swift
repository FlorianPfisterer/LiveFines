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