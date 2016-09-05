//
//  OkayView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 03.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let descriptionFont = UIFont.systemFontOfSize(21)
private let outerMargin: CGFloat = 14
private let innerMargin: CGFloat = 13

class OkayView: UIView
{
    // MARK: - Subviews
    let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let containerView = UIView()

    override var animatedSubviews: [UIView] {
        return [self.imageView, self.descriptionLabel]
    }

    var image: UIImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }

    var showMessage: Bool = false {
        didSet
        {
            guard oldValue != self.showMessage || !oldValue else { return }
            UIView.animateWithDuration(0.3, animations: {
                self.animatedSubviews.each { $0.alpha = self.showMessage ? 1 : 0 }
            })
        }
    }

    var title: String? {
        get { return self.descriptionLabel.text ?? "" }
        set { self.descriptionLabel.text = newValue?.uppercaseString }
    }

    // MARK: - Init
    init(image: UIImage)
    {
        super.init(frame: CGRectZero)
        self.image = image
        self.sharedInitialization()
    }

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
        self.tintColor = Constants.Color.green

        [self.imageView, self.descriptionLabel, self.containerView].each { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = self.image
        self.imageView.tintColor = self.tintColor
        self.imageView.alpha = 0

        self.descriptionLabel.textAlignment = .Center
        self.descriptionLabel.font = descriptionFont
        self.descriptionLabel.textColor = .whiteColor()
        self.descriptionLabel.alpha = 0

        // constraints
        NSLayoutConstraint(item: self.imageView, attribute: .Width, relatedBy: .Equal,
                           toItem: self.imageView, attribute: .Height, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self.imageView, attribute: .CenterX, relatedBy: .Equal,
                           toItem: self, attribute: .CenterX, multiplier: 0.65, constant: 0).active = true
        self.imageView.constrain(toEdgesOfView: self, margin: { attribute in
            switch attribute
            {
            case .Top: return outerMargin
            case .Bottom: return -outerMargin
            default: return nil
            }
        })
        NSLayoutConstraint(item: self.imageView, attribute: .Trailing, relatedBy: .Equal,
                           toItem: self.descriptionLabel, attribute: .Leading, multiplier: 1, constant: -innerMargin).active = true
        NSLayoutConstraint(item: self.descriptionLabel, attribute: .Top, relatedBy: .Equal,
                           toItem: self.imageView, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self.descriptionLabel, attribute: .Bottom, relatedBy: .Equal,
                           toItem: self.imageView, attribute: .Bottom, multiplier: 1, constant: 0).active = true
    }

    override func tintColorDidChange()
    {
        super.tintColorDidChange()
        self.imageView.tintColor = self.tintColor
    }
}
