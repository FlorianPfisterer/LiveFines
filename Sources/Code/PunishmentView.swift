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
    var isBlinking: Bool = false
    var punishment: Punishment? {
        didSet
        {
            if let punishment = self.punishment
            {
                if self.amount != punishment.amount { self.blink(forChange: punishment.amount - self.amount, newValue: punishment.amount) }
                self.amount = punishment.amount
                self.type = punishment.typeDescription.uppercaseString

                self.animate(show: true)
            }
            else
            {
                self.amount = 0
                self.animate(show: false)
            }
        }
    }

    private func blink(forChange change: Int, newValue: Int)
    {
        guard !self.isBlinking else { return }
        self.isBlinking = true

        // determine the correct blinking color
        var blinkColor: UIColor
        switch change
        {
        case let x where x < 0 && newValue == 0:
            blinkColor = Constants.Color.green  // should never happen, because if the amount is zero, the punishment should be nil

        case let x where x < 0: // amount goes down
            blinkColor = Constants.Color.orange

        default:        // amount goes up
            blinkColor = Constants.Color.red
        }

        let originalBackgroundColor = self.backgroundColor
        UIView.animateKeyframesWithDuration(0.8, delay: 0.1, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.15, animations: {
                self.backgroundColor = blinkColor
            })
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: {
                self.backgroundColor = originalBackgroundColor
            })
        }, completion: { _ in self.isBlinking = false })
    }
}
