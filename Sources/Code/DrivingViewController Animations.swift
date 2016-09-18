//
//  DrivingViewController Animations.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 06.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let expandAnimationDuration: TimeInterval = 0.4
private let standardAnimationDuration: TimeInterval = 0.5
private let horizontalMargin: CGFloat = 23
private let verticalMargin: CGFloat = 20

private let speedometerDisplayViewScale: CGFloat = 1.7
private let speedometerDisplayViewTypeScale: CGFloat = 1.3
private let speedometerDisplayViewTypeYTranslation: CGFloat = 15

extension DrivingViewController
{
    enum ViewState
    {
        case standard
        case expanded
    }

    fileprivate var availableWidth: CGFloat {
        return self.view.width - 3*horizontalMargin
    }

    fileprivate var expandedSpeedlimitBottom: CGFloat {
        return 2*verticalMargin + self.availableWidth * 0.53
    }

    internal func transition(to state: ViewState)
    {
        let isExpanded = state == .expanded

        UIView.animate(withDuration: isExpanded ? expandAnimationDuration : standardAnimationDuration, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.expandSpeedLimitView(isExpanded)
            self.expandSpeedometerView(isExpanded)
            self.expandPunishmentStackView(isExpanded)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    fileprivate func expandSpeedLimitView(_ expand: Bool = true)
    {
        guard expand else
        {
            self.speedLimitView.transform = CGAffineTransform.identity
            return
        }

        let availableWidth = self.availableWidth
        let targetFrame = CGRect(x: horizontalMargin,
                                 y: verticalMargin,
                                 width: availableWidth * 0.53,
                                 height: availableWidth * 0.53)
        let sizeMultiplier = targetFrame.width / self.speedLimitView.width
        let translationVector = targetFrame.outerCenter - self.speedLimitView.frame.outerCenter

        let scale = CGAffineTransform(scaleX: sizeMultiplier, y: sizeMultiplier)
        let translation = CGAffineTransform(translationX: translationVector.dx, y: translationVector.dy)
        self.speedLimitView.transform = scale.concatenating(translation)
    }

    fileprivate func expandSpeedometerView(_ expand: Bool = true)
    {
        guard expand else
        {
            self.speedometerView.transform = CGAffineTransform.identity
            self.speedometerView.displayView.amountLabel.transform = CGAffineTransform.identity
            self.speedometerView.displayView.typeLabel.transform = CGAffineTransform.identity
            return
        }

        let availableWidth = self.availableWidth
        let targetFrame = CGRect(x: self.view.width - horizontalMargin - availableWidth * 0.47,
                                 y: verticalMargin + 12,
                                 width: availableWidth * 0.47,
                                 height: availableWidth * 0.47)
        let sizeMultiplier = targetFrame.width / self.speedometerView.height
        let translationVector = targetFrame.outerCenter - self.speedometerView.frame.outerCenter

        let scale = CGAffineTransform(scaleX: sizeMultiplier, y: sizeMultiplier)
        let translation = CGAffineTransform(translationX: translationVector.dx, y: translationVector.dy)
        self.speedometerView.transform = scale.concatenating(translation)

        self.speedometerView.displayView.amountLabel.transform = CGAffineTransform(scaleX: speedometerDisplayViewScale, y: speedometerDisplayViewScale)
        self.speedometerView.displayView.typeLabel.transform = CGAffineTransform(scaleX: speedometerDisplayViewTypeScale, y: speedometerDisplayViewTypeScale).concatenating(CGAffineTransform(translationX: 0, y: speedometerDisplayViewTypeYTranslation))
    }

    fileprivate func expandPunishmentStackView(_ expand: Bool = true)
    {
        // stackview with background
        self.punishmentsStackView.alpha = expand ? 0 : 1
        self.separatorBackgroundView.alpha = expand ? 0 : 1

        self.upperSeparatorView.alpha = expand ? 0 : 1

        guard expand else
        {
            // separator lines
            self.upperSeparatorView.transform = CGAffineTransform.identity
            self.lowerSeparatorView.transform = CGAffineTransform.identity

            self.punishmentsStackView.transform = CGAffineTransform.identity
            self.separatorBackgroundView.transform = CGAffineTransform.identity

            self.expandedPunishmentsController?.view.transform = CGAffineTransform.identity
            return
        }

        // separator lines
        let upperYTranslation = -(self.upperSeparatorView.frame.origin.y - self.expandedSpeedlimitBottom)
        self.upperSeparatorView.transform = CGAffineTransform(translationX: 0, y: upperYTranslation)
        let lowerYTranslation = self.view.height - self.lowerSeparatorView.lowerLeft.y + 3
        self.lowerSeparatorView.transform = CGAffineTransform(translationX: 0, y: lowerYTranslation)

        // stackview with background
        let stackViewTranslation: CGFloat = lowerYTranslation + self.punishmentsStackView.height
        self.punishmentsStackView.transform = CGAffineTransform(translationX: 0, y: stackViewTranslation)
        self.separatorBackgroundView.transform = CGAffineTransform(translationX: 0, y: stackViewTranslation)

        // expandedPunishmentsVC
        guard let expandedVCY: CGFloat = self.expandedPunishmentsController?.view.frame.origin.y else { return }
        let expandedVCYTranslation = self.expandedSpeedlimitBottom - expandedVCY
        self.expandedPunishmentsController?.view.transform = CGAffineTransform(translationX: 0, y: expandedVCYTranslation)

        self.expandedPunishmentsVCHeightConstraint?.constant = abs(expandedVCYTranslation)
        self.expandedPunishmentsController?.view.layoutIfNeeded()
    }
}
