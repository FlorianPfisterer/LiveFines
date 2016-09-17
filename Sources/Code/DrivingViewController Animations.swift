//
//  DrivingViewController Animations.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 06.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let expandAnimationDuration: NSTimeInterval = 0.4
private let standardAnimationDuration: NSTimeInterval = 0.5
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

    private var availableWidth: CGFloat {
        return self.view.width - 3*horizontalMargin
    }

    private var expandedSpeedlimitBottom: CGFloat {
        return 2*verticalMargin + self.availableWidth * 0.53
    }

    internal func transition(to state: ViewState)
    {
        let isExpanded = state == .expanded

        UIView.animateWithDuration(isExpanded ? expandAnimationDuration : standardAnimationDuration, delay: 0, options: .CurveEaseInOut, animations: {
            self.expandSpeedLimitView(isExpanded)
            self.expandSpeedometerView(isExpanded)
            self.expandPunishmentStackView(isExpanded)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    private func expandSpeedLimitView(expand: Bool = true)
    {
        guard expand else
        {
            self.speedLimitView.transform = CGAffineTransformIdentity
            return
        }

        let availableWidth = self.availableWidth
        let targetFrame = CGRect(x: horizontalMargin,
                                 y: verticalMargin,
                                 width: availableWidth * 0.53,
                                 height: availableWidth * 0.53)
        let sizeMultiplier = targetFrame.width / self.speedLimitView.width
        let translationVector = targetFrame.outerCenter - self.speedLimitView.frame.outerCenter

        let scale = CGAffineTransformMakeScale(sizeMultiplier, sizeMultiplier)
        let translation = CGAffineTransformMakeTranslation(translationVector.dx, translationVector.dy)
        self.speedLimitView.transform = CGAffineTransformConcat(scale, translation)
    }

    private func expandSpeedometerView(expand: Bool = true)
    {
        guard expand else
        {
            self.speedometerView.transform = CGAffineTransformIdentity
            self.speedometerView.displayView.amountLabel.transform = CGAffineTransformIdentity
            self.speedometerView.displayView.typeLabel.transform = CGAffineTransformIdentity
            return
        }

        let availableWidth = self.availableWidth
        let targetFrame = CGRect(x: self.view.width - horizontalMargin - availableWidth * 0.47,
                                 y: verticalMargin + 12,
                                 width: availableWidth * 0.47,
                                 height: availableWidth * 0.47)
        let sizeMultiplier = targetFrame.width / self.speedometerView.height
        let translationVector = targetFrame.outerCenter - self.speedometerView.frame.outerCenter

        let scale = CGAffineTransformMakeScale(sizeMultiplier, sizeMultiplier)
        let translation = CGAffineTransformMakeTranslation(translationVector.dx, translationVector.dy)
        self.speedometerView.transform = CGAffineTransformConcat(scale, translation)

        self.speedometerView.displayView.amountLabel.transform = CGAffineTransformMakeScale(speedometerDisplayViewScale, speedometerDisplayViewScale)
        self.speedometerView.displayView.typeLabel.transform = CGAffineTransformConcat(
            CGAffineTransformMakeScale(speedometerDisplayViewTypeScale, speedometerDisplayViewTypeScale),
            CGAffineTransformMakeTranslation(0, speedometerDisplayViewTypeYTranslation))
    }

    private func expandPunishmentStackView(expand: Bool = true)
    {
        // stackview with background
        self.punishmentsStackView.alpha = expand ? 0 : 1
        self.separatorBackgroundView.alpha = expand ? 0 : 1

        self.upperSeparatorView.alpha = expand ? 0 : 1

        guard expand else
        {
            // separator lines
            self.upperSeparatorView.transform = CGAffineTransformIdentity
            self.lowerSeparatorView.transform = CGAffineTransformIdentity

            self.punishmentsStackView.transform = CGAffineTransformIdentity
            self.separatorBackgroundView.transform = CGAffineTransformIdentity

            self.expandedPunishmentsController?.view.transform = CGAffineTransformIdentity
            return
        }

        // separator lines
        let upperYTranslation = -(self.upperSeparatorView.frame.origin.y - self.expandedSpeedlimitBottom)
        self.upperSeparatorView.transform = CGAffineTransformMakeTranslation(0, upperYTranslation)
        let lowerYTranslation = self.view.height - self.lowerSeparatorView.lowerLeft.y + 3
        self.lowerSeparatorView.transform = CGAffineTransformMakeTranslation(0, lowerYTranslation)

        // stackview with background
        let stackViewTranslation: CGFloat = lowerYTranslation + self.punishmentsStackView.height
        self.punishmentsStackView.transform = CGAffineTransformMakeTranslation(0, stackViewTranslation)
        self.separatorBackgroundView.transform = CGAffineTransformMakeTranslation(0, stackViewTranslation)

        // expandedPunishmentsVC
        guard let expandedVCY: CGFloat = self.expandedPunishmentsController?.view.frame.origin.y else { return }
        let expandedVCYTranslation = self.expandedSpeedlimitBottom - expandedVCY
        self.expandedPunishmentsController?.view.transform = CGAffineTransformMakeTranslation(0, expandedVCYTranslation)

        self.expandedPunishmentsVCHeightConstraint?.constant = abs(expandedVCYTranslation)
        self.expandedPunishmentsController?.view.layoutIfNeeded()
    }
}
