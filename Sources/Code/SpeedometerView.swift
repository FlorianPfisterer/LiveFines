//
//  SpeedometerView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 03.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let scaleStartAngle: CGFloat = 5/6 * π
private let endAngle: CGFloat = π / 6

private let arcsMargin: CGFloat = 10

@IBDesignable
class SpeedometerView: UIView
{
    // MARK: - Subviews
    private let displayView = DisplayView()

    private let scaleArc = CAShapeLayer()
    private let speedArc = CAShapeLayer()
    private let limitArc = CAShapeLayer()

    // MARK: - Public Configuration
    @IBInspectable var speed: Int = 0 {
        didSet
        {
            self.displayView.amount = max(self.speed, 0)
            self.setupSpeedArc(animated: true)
        }
    }
    @IBInspectable var speedLimit: Int = 120 {
        didSet
        {
            self.setupLimitArc(animated: true)
        }
    }
    @IBInspectable var maxSpeed: Int = 200 {
        didSet
        {
            self.setupLimitArc(animated: true)
            self.setupSpeedArc(animated: true)
        }
    }

    @IBInspectable var type: String = "KM/H" {
        didSet { self.displayView.type = self.type.uppercaseString }
    }

    @IBInspectable var scaleArcWidth: CGFloat = 2
    @IBInspectable var speedArcWidth: CGFloat = 13
    
    @IBInspectable var limitArcWidth: CGFloat = 40
    @IBInspectable var limitArcSpan: CGFloat = 0.015

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
        self.backgroundColor = .clearColor()

        // setup the display view
        [self.displayView].each { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        self.displayView.amountFont = UIFont.systemFontOfSize(43)
        self.displayView.typeFont = UIFont.systemFontOfSize(17)

        self.displayView.amount = self.speed
        self.displayView.type = self.type
        self.displayView.innerMargin = -4

        NSLayoutConstraint(item: self.displayView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self.displayView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -25).active = true
        NSLayoutConstraint(item: self.displayView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 83).active = true
        NSLayoutConstraint(item: self.displayView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 70).active = true

        // setup the arcs
        [self.scaleArc, self.speedArc, self.limitArc].each { arc in
            arc.fillColor = UIColor.clearColor().CGColor
            arc.lineCap = kCALineCapButt
            self.layer.addSublayer(arc)
        }

        self.scaleArc.strokeColor = UIColor.whiteColor().CGColor
        self.scaleArc.lineWidth = self.scaleArcWidth

        self.speedArc.strokeColor = Constants.Color.green.CGColor
        self.speedArc.lineWidth = self.speedArcWidth

        self.limitArc.strokeColor = Constants.Color.red.CGColor
        self.limitArc.lineWidth = self.limitArcWidth
    }
}

extension SpeedometerView
{
    override func layoutSubviews()
    {
        super.layoutSubviews()

        let arcCenter = CGPoint(x: self.innerCenter.x, y: self.innerCenter.y + 20)

        // create the proper arc
        let outerArcRadius = self.radius - 2
        let scaleArcPath = UIBezierPath(arcCenter: arcCenter, radius: outerArcRadius, startAngle: scaleStartAngle, endAngle: endAngle, clockwise: true)
        self.scaleArc.path = scaleArcPath.CGPath

        let speedArcPath = UIBezierPath(arcCenter: arcCenter, radius: outerArcRadius - arcsMargin - self.speedArcWidth/2, startAngle: scaleStartAngle, endAngle: endAngle, clockwise: true)
        self.speedArc.path = speedArcPath.CGPath
        self.setupSpeedArc(animated: false)

        self.limitArc.path = speedArcPath.CGPath
        self.setupLimitArc(animated: false)
    }

    private func setupLimitArc(animated animated: Bool = false)
    {
        let limitArcStrokeMiddle = CGFloat(self.speedLimit) / CGFloat(self.maxSpeed)
        self.limitArc.strokeStart = limitArcStrokeMiddle - self.limitArcSpan/2
        self.limitArc.strokeEnd = limitArcStrokeMiddle + self.limitArcSpan/2
    }

    private func setupSpeedArc(animated animated: Bool = false)
    {
        self.speedArc.strokeEnd = min(CGFloat(self.speed) / CGFloat(self.maxSpeed), 1)
    }
}
