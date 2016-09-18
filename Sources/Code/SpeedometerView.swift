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
    let displayView = DisplayView()

    fileprivate let scaleArc = CAShapeLayer()
    fileprivate let speedArc = CAShapeLayer()
    fileprivate let limitArc = CAShapeLayer()

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
        didSet { self.displayView.type = self.type.uppercased() }
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

    fileprivate func sharedInitialization()
    {
        self.backgroundColor = .clear

        // setup the display view
        [self.displayView].each { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        self.displayView.amountFont = UIFont.systemFont(ofSize: 43)
        self.displayView.typeFont = UIFont.systemFont(ofSize: 17)

        self.displayView.amount = max(0, self.speed)
        self.displayView.type = self.type
        self.displayView.innerMargin = -4

        NSLayoutConstraint(item: self.displayView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.displayView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: self.displayView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 83).isActive = true
        NSLayoutConstraint(item: self.displayView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70).isActive = true

        // setup the arcs
        [self.scaleArc, self.speedArc, self.limitArc].each { arc in
            arc.fillColor = UIColor.clear.cgColor
            arc.lineCap = kCALineCapButt
            self.layer.addSublayer(arc)
        }

        self.scaleArc.strokeColor = UIColor.white.cgColor
        self.scaleArc.lineWidth = self.scaleArcWidth

        self.speedArc.strokeColor = Constants.Color.green.cgColor
        self.speedArc.lineWidth = self.speedArcWidth

        self.limitArc.strokeColor = Constants.Color.red.cgColor
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
        self.scaleArc.path = scaleArcPath.cgPath

        let speedArcPath = UIBezierPath(arcCenter: arcCenter, radius: outerArcRadius - arcsMargin - self.speedArcWidth/2, startAngle: scaleStartAngle, endAngle: endAngle, clockwise: true)
        self.speedArc.path = speedArcPath.cgPath
        self.setupSpeedArc(animated: false)

        self.limitArc.path = speedArcPath.cgPath
        self.setupLimitArc(animated: false)
    }

    fileprivate func setupLimitArc(animated: Bool = false)
    {
        let limitArcStrokeMiddle = CGFloat(self.speedLimit) / CGFloat(self.maxSpeed)
        self.limitArc.strokeStart = limitArcStrokeMiddle - self.limitArcSpan/2
        self.limitArc.strokeEnd = limitArcStrokeMiddle + self.limitArcSpan/2
    }

    fileprivate func setupSpeedArc(animated: Bool = false)
    {
        self.speedArc.strokeEnd = min(CGFloat(self.speed) / CGFloat(self.maxSpeed), 1)
    }
}
