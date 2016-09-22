//
//  OkayView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 03.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let descriptionFont = UIFont.systemFont(ofSize: 23, weight: UIFontWeightMedium)
private let outerMargin: CGFloat = 14
private let innerMargin: CGFloat = 13

class OkayView: UIView
{
    // MARK: - Subviews
    let imageView = UIImageView()
    fileprivate let descriptionLabel = UILabel()
    fileprivate let containerView = UIView()

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
            UIView.animate(withDuration: 0.3, animations: {
                self.animatedSubviews.each { $0.alpha = self.showMessage ? 1 : 0 }
            })
        }
    }

    var title: String? {
        get { return self.descriptionLabel.text ?? "" }
        set { self.descriptionLabel.text = newValue?.uppercased() }
    }

    // MARK: - Init
    init(image: UIImage)
    {
        super.init(frame: CGRect.zero)
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

    fileprivate func sharedInitialization()
    {
        self.backgroundColor = Constants.Color.darkGray
        self.tintColor = Constants.Color.green

        [self.imageView, self.descriptionLabel, self.containerView].each { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        self.containerView.backgroundColor = .clear
        self.addSubview(self.containerView)

        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = self.image
        self.imageView.tintColor = self.tintColor
        self.imageView.alpha = 0
        self.containerView.addSubview(self.imageView)

        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.font = descriptionFont
        self.descriptionLabel.textColor = .white
        self.descriptionLabel.alpha = 0
        self.containerView.addSubview(self.descriptionLabel)

        // constraints
        self.containerView.constrain(toEdgesOfView: self, margin: { attribute in
            switch attribute
            {
            case .top: return outerMargin
            case .bottom: return -outerMargin
            default: return nil
            }

        })
        NSLayoutConstraint(item: self.containerView, attribute: .centerX, relatedBy: .equal,
                           toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal,
                           toItem: self.imageView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        self.imageView.constrain(toEdgesOfView: self.containerView, margin: { attribute in
            switch attribute
            {
            case .top, .bottom, .leading: return 0
            default: return nil
            }
        })
        NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal,
                           toItem: self.descriptionLabel, attribute: .leading, multiplier: 1, constant: -innerMargin).isActive = true

        NSLayoutConstraint(item: self.descriptionLabel, attribute: .top, relatedBy: .equal,
                           toItem: self.imageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.descriptionLabel, attribute: .bottom, relatedBy: .equal,
                           toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.descriptionLabel, attribute: .trailing, relatedBy: .equal,
                           toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: -innerMargin).isActive = true
    }

    override func tintColorDidChange()
    {
        super.tintColorDidChange()
        self.imageView.tintColor = self.tintColor
    }
}
