//
//  SignificanceComparable.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 17.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation

protocol SignificanceComparable
{
    func significantChanges(to to: Self) -> Bool
}

infix operator >> { }
func >> <T: SignificanceComparable>(lhs: T, rhs: T) -> Bool
{
    return lhs.significantChanges(to: rhs)
}

extension CLLocation: SignificanceComparable
{
    func significantChanges(to to: CLLocation) -> Bool
    {
        return false    // TODO
    }
}