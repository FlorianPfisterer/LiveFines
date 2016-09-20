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
        return { offence in
            let delta = offence.delta
            let inside = roadType == .insideCity

            switch delta
            {
            case 0...5: return .none()

            case 6...10:
                return .single(.financial(inside ? 15 : 10))

            case 11...15:
                return .single(.financial(inside ? 25 : 20))

            case 16...20:
                return .single(.financial(inside ? 30 : 35))

            case 21...25:
                return .multiple([.financial(inside ? 80 : 70), .points(1)])

            case 26...30:
                return .multiple([.financial(inside ? 100 : 80), .points(1), .license(1)])

            case 31...40:
                return .multiple([.financial(inside ? 160 : 120), .points(inside ? 2 : 1), .license(1)])

            case 41...50:
                return .multiple([.financial(inside ? 200 : 160), .points(2), .license(1)])

            case 51...60:
                return .multiple([.financial(inside ? 280 : 240), .points(2), .license(inside ? 2 : 1)])

            case 61...70:
                return .multiple([.financial(inside ? 480 : 440), .points(2), .license(inside ? 3 : 2)])

            case let x where x > 70:
                return .multiple([.financial(inside ? 680 : 600), .points(2), .license(3)])

            default:
                return .none()
            }
            
        }
    }
}
