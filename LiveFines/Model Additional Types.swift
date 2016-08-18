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

struct DrivingData: Equatable
{
    var speed: Int
    var limit: Int
    
    init()
    {
        self.speed = 0
        self.limit = 0
    }
    
    init(speed: Int, limit: Int)
    {
        self.speed = speed
        self.limit = limit
    }
}

func == (lhs: DrivingData, rhs: DrivingData) -> Bool
{
    return lhs.speed == rhs.speed && lhs.limit == rhs.limit
}
