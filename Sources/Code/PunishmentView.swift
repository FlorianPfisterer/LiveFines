//
//  PunishmentView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 03.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

class PunishmentView: DisplayView
{
    var punishment: Punishment? {
        didSet
        {
            if let punishment = self.punishment
            {
                self.amount = punishment.amount
                self.type = punishment.description.uppercaseString
                self.animate(show: true)
            }
            else
            {
                self.animate(show: false)
            }
        }
    }
}
