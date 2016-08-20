//
//  Other Errors.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

enum HereError: ErrorType
{
    case noSpeedLimit
    case noLinkId
}

enum LocationError: ErrorType
{
    case noLocations
    case noMatchingNodes
    case other(String)
}