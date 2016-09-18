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
    
    func penalty(fromNode node: Node) -> Penalty?
    {
        guard let offence = Offence(node: node) else { return nil }
        
        let rule = self.rule(forLimit: node.speedLimit)
        return rule(offence)
    }

    func penalty(fromSpeed speed: Int, atLimit limit: Int) -> Penalty?
    {
        guard let offence = Offence(speed: speed, limit: limit) else { return nil }

        let rule = self.rule(forLimit: limit)
        return rule(offence)
    }
}

extension Locale
{
    static var currentCountry: Country {
        switch NSLocale.autoupdatingCurrent.identifier.lowercased()
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
