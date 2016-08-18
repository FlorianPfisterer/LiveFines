//
//  Punishment.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

struct Punishment
{
    // MARK: - Subtypes
    enum PType: Hashable, Equatable
    {
        case financial
        case points
        case license
    }
    
    // MARK: - Properties
    let type: PType
    let amount: Int
    
    // MARK: - Init
    init(type: PType, amount: Int)
    {
        self.type = type
        self.amount = amount
    }
}

extension Punishment: Hashable
{
    var hashValue: Int {
        return self.type.hashValue
    }
    
    var description: String {
        return "\(self.amount)"
    }
}

// MARK: - Convenience Static Functions
extension Punishment
{
    static func financial(amount: Int) -> Punishment
    {
        return Punishment(type: .financial, amount: amount)
    }
    
    static func points(count: Int) -> Punishment
    {
        return Punishment(type: .points, amount: count)
    }
    
    static func license(months: Int) -> Punishment
    {
        return Punishment(type: .license, amount: months)
    }
}

// MARK: - Functions
func == (lhs: Punishment, rhs: Punishment) -> Bool
{
    return lhs.hashValue == rhs.hashValue
}
