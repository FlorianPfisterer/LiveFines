//
//  Constant.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 19.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)

struct Constants
{
    struct Color
    {
        static let red = UIColor(red: 0.92, green: 0.19, blue: 0.39, alpha: 1.00)
        static let orange = UIColor(red: 0.96, green: 0.52, blue: 0.11, alpha: 1.00)
        static let green = UIColor(red: 0.62, green: 0.77, blue: 0.15, alpha: 1.00)

        static let darkGray = UIColor(red: 35/255.0, green: 43/255.0, blue: 49/255.0, alpha: 1.00)
        static let lightGray = UIColor(red: 0.31, green: 0.35, blue: 0.37, alpha: 1.00)
    }
    
    struct Config
    {
        static let coordinateSpan: Double = 0.003
        static let courseSpan: Double = 15
        static let speedSpan: Int = 12
        static let speedLimitMax: Double = 60  // m/s

        static var speedLimitMaxKmh: Int {
            return Int(Config.speedLimitMax * 3.6)
        }
        
        static func courseRange(forCourse course: Double) -> (min: Double, max: Double)
        {
            var min = course - Config.courseSpan
            var max = course + Config.courseSpan
            
            if course > (360 - Config.courseSpan)
            {
                max = max.truncatingRemainder(dividingBy: 360)
            }
            else if course < Config.courseSpan
            {
                min = 360 - (Config.courseSpan - course)
            }
            
            return (min, max)
        }
        
        static func coordinateRange(forDegrees degrees: Double) -> (min: Double, max: Double)
        {
            return (degrees - Config.coordinateSpan, degrees + Config.coordinateSpan)
        }
        
        static func speedRange(forSpeed speed: Int) -> (min: Int, max: Int)
        {
            return (speed - Config.speedSpan, speed + Config.speedSpan)
        }
    }
}
