//
//  Germany.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

final class Germany: Country
{
    static let reference = Germany()
    
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
            case 0...7:
                return .single(.financial(10))
                
            case 7...15:
                return .multiple([.financial(20), .points(1)])
                
            case 15...100:
                return .multiple([.financial(40), .points(3), .license(2)])
                
            default:
                return .none()
            }
            
        }
    }
}