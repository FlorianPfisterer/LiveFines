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
        didSet { self.typeLabel.text = self.type.uppercased() }
    }

    // MARK: - Subviews
    fileprivate let amountLabel = UILabel()
    fileprivate let typeLabel = UILabel()
    fileprivate let plusImageView = UIImageView()

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

    fileprivate func sharedInitialization()
    {
        self.amountLabel.text = self.amount
        self.amountLabel.font = UIFont.systemFont(ofSize: 57, weight: UIFontWeightMedium)
        self.typeLabel.text = self.type
        self.typeLabel.font = UIFont.systemFont(ofSize: 33, weight: UIFontWeightMedium)

        [self.amountLabel, self.typeLabel].each { label in
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
        }

        self.plusImageView.translatesAutoresizingMaskIntoConstraints = false
        self.plusImageView.contentMode = .scaleAspectFit
        self.plusImageView.image = UIImage(named: "plusIcon")
        self.addSubview(self.plusImageView)

        // constraints
        [self.plusImageView, self.amountLabel, self.typeLabel].each { subview in
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        }

        NSLayoutConstraint(item: self.plusImageView, attribute: .width, relatedBy: .equal,
                           toItem: self.plusImageView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.plusImageView, attribute: .width, relatedBy: .equal,
                           toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20).isActive = true
        self.plusImageView.constrain(toEdgesOfView: self, margin: { $0 == .leading ? 20 : nil })

        NSLayoutConstraint(item: self.amountLabel, attribute: .leading, relatedBy: .equal,
                           toItem: self.plusImageView, attribute: .trailing, multiplier: 1, constant: 20).isActive = true

        NSLayoutConstraint(item: self.typeLabel, attribute: .trailing, relatedBy: .equal,
                           toItem: self, attribute: .trailing, multiplier: 1, constant: -40).isActive = true
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
