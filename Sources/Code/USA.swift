//
//  USA.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

final class USA: Country
{
    static let reference = USA()
    
    func roadType(forLimit limit: Int) -> RoadType
    {
        return limit <= 55 ? .insideCity : .outsideCity
    }
    
    func rule(onRoadType roadType: RoadType) -> Rule
    {
        // TODO
        return { offence in
            
            let delta = offence.delta
            
            switch delta
            {
            case 3...7:
                return .single(.financial(10))

            case 7...11:
                return .multiple([.financial(20), .points(1)])

            case 12...100:
                return .multiple([.financial(40), .points(3), .license(2)])

            default:
                return .none()
            }
            
        }
    }
}