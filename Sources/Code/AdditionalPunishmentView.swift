//
//  AdditionalPunishmentView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 16.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

@IBDesignable
final class AdditionalPunishmentView: UIView
{
    // MARK: - IBInspectables
    @IBInspectable var amount: String = "1" {
        didSet { self.amountLabel.text = self.amount }
    }
    @IBInspectable var type: String = "PUNKT" {
        didSet { self.typeLabel.text = self.type.uppercaseString }
    }

    // MARK: - Subviews
    private let amountLabel = UILabel()
    private let typeLabel = UILabel()
    private let plusImageView = UIImageView()

    // MARK: - Init
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.sharedInitialization()
    }

    private func sharedInitialization()
    {
        self.amountLabel.text = self.amount
        self.amountLabel.font = UIFont.systemFontOfSize(57, weight: UIFontWeightMedium)
        self.typeLabel.text = self.type
        self.typeLabel.font = UIFont.systemFontOfSize(33, weight: UIFontWeightMedium)

        [self.amountLabel, self.typeLabel].each { label in
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
        }

        self.plusImageView.translatesAutoresizingMaskIntoConstraints = false
        self.plusImageView.contentMode = .ScaleAspectFit
        self.plusImageView.image = UIImage(named: "plusIcon")
        self.addSubview(self.plusImageView)

        // constraints
        [self.plusImageView, self.amountLabel, self.typeLabel].each { subview in
            NSLayoutConstraint(item: subview, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0).active = true
        }

        NSLayoutConstraint(item: self.plusImageView, attribute: .Width, relatedBy: .Equal,
                           toItem: self.plusImageView, attribute: .Height, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self.plusImageView, attribute: .Width, relatedBy: .Equal,
                           toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20).active = true
        self.plusImageView.constrain(toEdgesOfView: self, margin: { $0 == .Leading ? 20 : nil })

        NSLayoutConstraint(item: self.amountLabel, attribute: .Leading, relatedBy: .Equal,
                           toItem: self.plusImageView, attribute: .Trailing, multiplier: 1, constant: 20).active = true

        NSLayoutConstraint(item: self.typeLabel, attribute: .Trailing, relatedBy: .Equal,
                           toItem: self, attribute: .Trailing, multiplier: 1, constant: -40).active = true
    }
}

// MARK: - Public Configuration
extension AdditionalPunishmentView
{
    func configure(with punishment: Punishment)
    {
        self.amount = punishment.amountDescription
        self.type = punishment.typeDescription
    }
}
