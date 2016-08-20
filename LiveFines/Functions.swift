//
//  Functions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

// MARK: - Dispatch Handy Functions
func async(delay: Double = 0, block: () -> Void)
{
    if delay <= 0
    {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    else
    {
        let after: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(after, dispatch_get_main_queue(), block)
    }
}