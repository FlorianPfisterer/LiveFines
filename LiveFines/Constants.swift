//
//  Constant.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 19.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

struct Constants
{
    struct Color
    {
        static let red = UIColor(red: 0.92, green: 0.19, blue: 0.39, alpha: 1.00)
        
        
    }
    
    struct Config
    {
        static let coordinateSpan: Double = 0.003
        static let courseSpan: Double = 20
        static let speedSpan: Int = 12
        
        static func courseRange(forCourse course: Double) -> (min: Double, max: Double)
        {
            var min = course - Config.courseSpan
            var max = course + Config.courseSpan
            
            if course > (360 - Config.courseSpan)
            {
                max = max % 360
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