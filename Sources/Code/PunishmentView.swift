//
//  PunishmentView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 24.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let mainColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
private let descriptionColor = UIColor(red: 106/255.0, green: 121/255.0, blue: 129/255.0, alpha: 1)

class PunishmentView: UIView
{
    private let amountLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    var punishment: Punishment? {
        didSet
        {
            if let punishment = self.punishment
            {
                self.amountLabel.text = "\(punishment.amount)"
                self.descriptionLabel.text = "\(punishment.description)"
                self.animate(show: true)
            }
            else
            {
                self.animate(show: false)
            }
        }
    }
    
    private func animate(show show: Bool)
    {
        UIView.animateWithDuration(0.3, animations: {
            self.hidden = !show
            self.amountLabel.alpha = show ? 1 : 0
            self.descriptionLabel.alpha = show ? 1 : 0  // TODO red / orange / ... blinking
        })
    }
}
