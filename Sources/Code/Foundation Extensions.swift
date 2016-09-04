//
//  Foundation Extensions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

extension CollectionType
{
    func find(condition: (Self.Generator.Element) -> Bool) -> Self.Generator.Element?
    {
        for x in self where condition(x) { return x }
        return nil
    }
}

extension SequenceType
{
    func each(@noescape body: (Self.Generator.Element) throws -> Void) rethrows
    {
        try self.forEach(body)
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
