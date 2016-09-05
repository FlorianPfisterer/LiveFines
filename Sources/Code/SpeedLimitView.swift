//
//  SpeedLimitView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 22.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import UIKit

private let unknownSpeedlimitSign: String = "?"
private let unlimitedStartAngle: CGFloat = π * (7/4)
private let unlimitedEndAngle: CGFloat = π * (3/4)

@IBDesignable
class SpeedLimitView: UIView
{
    // MARK: - Design Customization
    @IBInspectable var marginWidth: CGFloat = 4 { didSet { self.setNeedsDisplay() } }
    @IBInspectable var fontSize: CGFloat = 100 {
        didSet
        {
            self.contentLabel.font = UIFont.systemFontOfSize(self.fontSize, weight: self.fontWeigth)
        }
    }

    @IBInspectable var fontWeigth: CGFloat = 0.34 {
        didSet
        {
            self.contentLabel.font = UIFont.systemFontOfSize(self.fontSize, weight: self.fontWeigth)
        }
    }

    @IBInspectable var borderWidth: CGFloat = 28
    @IBInspectable var unlimitedBorderWidth: CGFloat = 15
    private var currentBorderWidth: CGFloat = 28 {
        didSet { self.borderLayer.lineWidth = self.currentBorderWidth }
    }

    @IBInspectable var limit: Int = -1 {
        didSet { self.updatedLimit() }
    }

    @IBInspectable var unlimitedLineWidth: CGFloat = 6
    
    // MARK: - Private Subviews etc.
    private let borderLayer = CAShapeLayer()
    private let linesLayer = CAShapeLayer()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        return label
    }()

    var state: State = .unknown {
        didSet { self.applyDesign() }
    }

    enum State
    {
        case limited
        case unlimited
        case unknown
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
        self.currentBorderWidth = self.borderWidth

        self.layer.addSublayer(self.borderLayer)
        self.borderLayer.strokeColor = Constants.Color.red.CGColor  //  default
        self.borderLayer.fillColor = UIColor.whiteColor().CGColor

        self.linesLayer.lineCap = kCALineCapButt
        self.linesLayer.strokeColor = UIColor.blackColor().CGColor
        self.linesLayer.lineWidth = self.unlimitedLineWidth

        self.contentLabel.font = UIFont.systemFontOfSize(self.fontSize, weight: self.fontWeigth)
        self.contentLabel.backgroundColor = .clearColor()
        
        self.addSubview(self.contentLabel)

        self.backgroundColor = .whiteColor()
        self.clipsToBounds = true
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true

        self.updatedLimit()
    }
    
    // MARK: - UI Setup
    private func applyDesign()
    {
        switch self.state
        {
        case .unknown:
            // TODO
            self.linesLayer.removeFromSuperlayer()
            self.contentLabel.text = unknownSpeedlimitSign
            self.currentBorderWidth = self.borderWidth

        case .limited:
            self.linesLayer.removeFromSuperlayer()
            self.contentLabel.text = "\(self.limit)"
            self.currentBorderWidth = self.borderWidth
            self.borderLayer.strokeColor = Constants.Color.red.CGColor

        case .unlimited:
            self.contentLabel.text = ""
            self.borderLayer.strokeColor = UIColor.blackColor().CGColor
            self.currentBorderWidth = self.unlimitedLineWidth
            self.layer.addSublayer(self.linesLayer)
        }
    }
}

extension SpeedLimitView
{
    // MARK: - Drawing Lifecycle
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layer.cornerRadius = self.radius
        self.contentLabel.frame = self.bounds
    }
    
    override func drawRect(rect: CGRect)
    {
        let arcRadius = self.radius - self.marginWidth - self.currentBorderWidth / 2
        let arcPath = UIBezierPath(arcCenter: self.innerCenter, radius: arcRadius, startAngle: 0, endAngle: -0.000001, clockwise: true)
        self.borderLayer.path = arcPath.CGPath

        if self.state == .unlimited
        {
            let linePath = UIBezierPath()

            for offset: CGFloat in [0, 0.08, -0.08, 0.16, -0.16]
            {
                let radiusOffset: CGFloat = abs(offset) * 30 + self.marginWidth
                linePath.move(to: self.point(forAngle: unlimitedStartAngle + offset, withRadiusOffset: radiusOffset))
                linePath.draw(to: self.point(forAngle: unlimitedEndAngle - offset, withRadiusOffset: radiusOffset))
            }

            self.linesLayer.path = linePath.CGPath
        }
    }

    private func point(forAngle angle: CGFloat, withRadiusOffset offset: CGFloat = 0) -> CGPoint
    {
        let x = self.innerCenter.x + cos(angle) * (self.radius - offset)
        let y = self.innerCenter.y + sin(angle) * (self.radius - offset)
        return CGPoint(x: x, y: y)
    }
}

extension SpeedLimitView
{
    private func updatedLimit()
    {
        switch self.limit
        {
        case let x where x <= 0:
            self.state = .unknown

        case let x where x <= Constants.Config.speedLimitMaxKmh:
            self.state = .limited

        case let x where x > Constants.Config.speedLimitMaxKmh:    // greater than max => unlimited
            self.state = .unlimited

        default: return
        }
    }
}
