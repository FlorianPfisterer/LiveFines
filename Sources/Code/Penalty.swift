//
//  Penalty.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation

struct Penalty
{
    private let punishments: Set<Punishment>
    
    var shouldPunish: Bool { return !self.punishments.isEmpty }
    
    // MARK: - Init
    init()  // none
    {
        self.punishments = []
    }
    
    init(_ punishment: Punishment)
    {
        self.punishments = [punishment]
    }
    
    init(multiple punishments: Set<Punishment>)
    {
        self.punishments = punishments
    }
    
    init(multiple punishments: [Punishment])
    {
        self.punishments = Set(punishments)
    }
}

extension Penalty
{
    subscript(punishmentType: Punishment.PType) -> Punishment? {
        return self.punishments.find { $0.type == punishmentType }
    }

    var allPunishments: [Punishment] {
        return Array(self.punishments)
    }
}

extension Penalty
{
    // MARK: Static Convenience
    static func none() -> Penalty
    {
        return Penalty()
    }
    
    static func single(punishment: Punishment) -> Penalty
    {
        return Penalty(punishment)
    }
    
    static func multiple(punishments: [Punishment]) -> Penalty
    {
        return Penalty(multiple: punishments)
    }
}
