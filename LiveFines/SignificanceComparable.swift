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

infix operator ≈ { }
func ≈ <T: SignificanceComparable>(lhs: T, rhs: T) -> Bool
{
    return !(lhs >> rhs)
}

extension CLLocation: SignificanceComparable
{
    func significantChanges(to to: CLLocation) -> Bool
    {
        let coordinate = self.coordinate
        let toCoordinate = to.coordinate
        return abs(toCoordinate.latitude - coordinate.latitude) > Constants.Config.coordinateSpan ||
               abs(toCoordinate.longitude - coordinate.longitude) > Constants.Config.coordinateSpan
    }
}