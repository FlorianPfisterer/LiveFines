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

    @IBInspectable var borderWidth: CGFloat = 30 {
        didSet
        {
            self.borderLayer.lineWidth = self.borderWidth
        }
    }

    @IBInspectable var limit: Int = -1 {
        didSet { self.updatedLimit() }
    }
    
    // MARK: - Private Subviews etc.
    private let borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

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
        self.layer.addSublayer(self.borderLayer)
        self.borderLayer.lineWidth = self.borderWidth
        self.borderLayer.strokeColor = Constants.Color.red.CGColor  //  default
        self.borderLayer.fillColor = UIColor.whiteColor().CGColor

        self.contentLabel.font = UIFont.systemFontOfSize(self.fontSize, weight: self.fontWeigth)
        self.contentLabel.backgroundColor = .clearColor()
        
        self.addSubview(self.contentLabel)

        self.backgroundColor = .whiteColor()
        self.clipsToBounds = true
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = self.radius

        self.updatedLimit()
    }
    
    // MARK: - UI Setup
    private func applyDesign()
    {
        switch self.state
        {
        case .unknown:
            // TODO
            self.contentLabel.text = unknownSpeedlimitSign

        case .limited:
            self.contentLabel.text = "\(self.limit)"
            self.borderLayer.strokeColor = Constants.Color.red.CGColor

        case .unlimited:
            self.contentLabel.text = ""
            self.borderLayer.strokeColor = Constants.Color.lightGray.CGColor    // TODO
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
        let arcRadius = self.radius - self.marginWidth - self.borderWidth / 2
        let arcPath = UIBezierPath(arcCenter: self.innerCenter, radius: arcRadius, startAngle: 0, endAngle: -0.000001, clockwise: true)
        self.borderLayer.path = arcPath.CGPath

        self.layer.cornerRadius = self.radius
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

        default:
            fatalError()
        }
    }
}