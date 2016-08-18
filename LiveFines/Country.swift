//
//  Country.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

protocol Country    // TODO (independent from UIKit) - layout for speed sign
{
    func roadType(forLimit limit: Int) -> RoadType
    func rule(onRoadType roadType: RoadType) -> Rule
}

extension Country
{
    func rule(forLimit limit: Int) -> Rule
    {
        return self.rule(onRoadType: self.roadType(forLimit: limit))
    }
}

extension NSLocale
{
    static func currentCountry() -> Country
    {
        switch NSLocale.autoupdatingCurrentLocale().localeIdentifier.lowercaseString
        {
        case "de":
            return Germany.reference
            
        case "us":
            return USA.reference
            
        default:
            return USA.reference
        }
    }
}
