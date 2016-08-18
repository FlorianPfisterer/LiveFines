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
            case 0...2:
                return .none()
                
            case 3...10:
                return .single(.financial(10))
                
            case 11...20:
                return .single(.financial(20))
                
            case 21...30:
                return .multiple([.financial(30), .points(1)])
                
            case 31...40:
                return .multiple([.financial(60), .points(2), .license(3)])
                
            default:
                return .none()
            }
            
        }
    }
}