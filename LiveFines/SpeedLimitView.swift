//
//  SpeedLimitView.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 22.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import UIKit

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
    @IBInspectable var fontWeigth: CGFloat = 0.6 {
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
    @IBInspectable var limit: Int = 0 {
        didSet
        {
            self.contentLabel.text = "\(self.limit)"
        }
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
        self.contentLabel.font = UIFont.systemFontOfSize(self.fontSize, weight: self.fontWeigth)
        self.contentLabel.text = "\(self.limit)"
        
        self.addSubview(self.contentLabel)
        
        self.applyDesign()
    }
    
    // MARK: - UI Setup
    private func applyDesign()
    {
        self.backgroundColor = .whiteColor()
        self.clipsToBounds = true
        
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = self.radius/2
        
        self.borderLayer.lineWidth = self.borderWidth
        self.borderLayer.strokeColor = Constants.Color.red.CGColor
        self.borderLayer.fillColor = UIColor.whiteColor().CGColor
    }
}

extension SpeedLimitView
{
    // MARK: - Drawing Lifecycle
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layer.cornerRadius = self.radius / 2
        self.contentLabel.frame = self.bounds
    }
    
    override func drawRect(rect: CGRect)
    {
        self.applyDesign()
        
        let arcRadius = self.radius - self.marginWidth - self.borderWidth / 2
        let arcPath = UIBezierPath(arcCenter: self.innerCenter, radius: arcRadius, startAngle: 0, endAngle: -0.000001, clockwise: true)
        self.borderLayer.path = arcPath.CGPath
        
        self.layer.cornerRadius = min(self.height, self.width) / 2
    }
}