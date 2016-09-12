//
//  DrivingViewController Animations.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 06.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let animationDuration: NSTimeInterval = 0.4
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

    internal func transition(to state: ViewState)
    {
        let isExpanded = state == .expanded

        UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseOut, animations: {
            self.expandSpeedLimitView(isExpanded)
            self.expandSpeedometerView(isExpanded)
        }, completion: nil)

    }

    private func expandSpeedLimitView(expand: Bool = true)
    {
        guard expand else
        {
            self.speedLimitView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 0), CGAffineTransformMakeScale(1, 1))
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
            self.speedometerView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 0), CGAffineTransformMakeScale(1, 1))
            self.speedometerView.displayView.amountLabel.transform = CGAffineTransformMakeScale(1, 1)
            self.speedometerView.displayView.typeLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
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
}
