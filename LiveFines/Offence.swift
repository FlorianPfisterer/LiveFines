//
//  Offence.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

struct Offence
{
    private let speed: Int
    private let limit: Int
    
    // MARK: - Init
    init?(speed: Int, limit: Int)
    {
        if speed <= limit
        {
            return nil
        }
        self.speed = speed
        self.limit = limit
    }
    
    init?(drivingData: DrivingData)
    {
        guard let offence = Offence(speed: drivingData.speed, limit: drivingData.limit) else
        {
            return nil
        }
        self = offence
    }
}

extension Offence
{
    var delta: Int {
        return self.speed - self.limit
    }
}

extension Offence: Equatable { }
func == (lhs: Offence, rhs: Offence) -> Bool
{
    return lhs.speed == rhs.speed && lhs.limit == rhs.limit
}