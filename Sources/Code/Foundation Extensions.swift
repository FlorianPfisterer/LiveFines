//
//  Foundation Extensions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

extension Collection
{
    func find(_ condition: (Self.Iterator.Element) -> Bool) -> Self.Iterator.Element?
    {
        for x in self where condition(x) { return x }
        return nil
    }
}

extension Sequence
{
    func each(_ body: (Self.Iterator.Element) throws -> Void) rethrows
    {
        try self.forEach(body)
    }
}

extension Array
{
    var randomElement: Element {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
}

// MARK: - Primitive Types
extension Int
{
    func roundToTen() -> Int
    {
        let diff = self % 10
        return diff >= 5 ? self + (10-diff) : self - diff
    }
}

extension TimeInterval
{
    static var now: TimeInterval {
        return Date().timeIntervalSinceReferenceDate
    }
}
