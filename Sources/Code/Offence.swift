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
    fileprivate let speed: Int
    fileprivate let limit: Int
    
    // MARK: - Init
    init?(speed: Int, limit: Int)
    {
        guard limit > 0 else { return nil }
        if speed <= limit
        {
            return nil
        }
        self.speed = speed
        self.limit = limit
    }
    
    init?(node: Node)
    {
        guard let offence = Offence(speed: node.speed, limit: node.speedLimit) else
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
