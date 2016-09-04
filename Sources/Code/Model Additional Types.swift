//
//  Model Additional Types.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

typealias Speed = Double
typealias Rule = (Offence) -> Penalty

enum RoadType
{
    case insideCity
    case outsideCity
}
