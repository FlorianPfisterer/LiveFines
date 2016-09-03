//
//  DisplayView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 24.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let mainColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
private let descriptionColor = Constants.Color.lightGray

private let verticalMargin: CGFloat = 9

class DisplayView: UIView
{
    // MARK: - Subviews
    internal let amountLabel = UILabel()
    internal let typeLabel = UILabel()

    override var animatedSubviews: [UIView] {
        return [self.amountLabel, self.typeLabel]
    }

    // MARK: - Internal Configuration
    internal var amountFont = UIFont.systemFontOfSize(36)
    internal var typeFont = UIFont.systemFontOfSize(13)

    // MARK: - Public UI Set Variables
    var amount: Int {
        get { return Int(self.amountLabel.text ?? "0") ?? 0 }
        set { self.amountLabel.text = "\(newValue)" }
    }

    var type: String {
        get { return self.typeLabel.text ?? "" }
        set { self.typeLabel.text = newValue }
    }

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
        self.backgroundColor = Constants.Color.darkGray

        // setup labels
        [self.amountLabel, self.typeLabel].each { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .Center
            self.addSubview(label)

            NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal,
                toItem: self, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        }

        // configure
        self.amountLabel.font = self.amountFont
        self.amountLabel.textColor = mainColor
        self.typeLabel.font = self.typeFont
        self.typeLabel.textColor = descriptionColor

        // layout
        NSLayoutConstraint(item: self.amountLabel, attribute: .Top, relatedBy: .Equal,
                           toItem: self, attribute: .Top, multiplier: 1, constant: verticalMargin).active = true
        NSLayoutConstraint(item: self.typeLabel, attribute: .Top, relatedBy: .Equal,
                           toItem: self.amountLabel, attribute: .Bottom, multiplier: 1, constant: 2).active = true
        NSLayoutConstraint(item: self.typeLabel, attribute: .Bottom, relatedBy: .Equal,
                           toItem: self, attribute: .Bottom, multiplier: 1, constant: -verticalMargin).active = true

    }
}
