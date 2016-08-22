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
    @IBInspectable var borderWidth: CGFloat = 30 {
        didSet
        {
            self.borderLayer.lineWidth = self.borderWidth
        }
    }
    
    // MARK: - Private Subviews etc.
    var borderLayer: CAShapeLayer
    
    // MARK: - Init
    override init(frame: CGRect)
    {
        self.borderLayer = CAShapeLayer()
        super.init(frame: frame)
        
        self.sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.borderLayer = CAShapeLayer()
        super.init(coder: aDecoder)
        
        self.sharedInitialization()
    }
    
    private func sharedInitialization()
    {
        self.applyDesign()
        //self.layer.addSublayer(self.borderLayer)
    }
    
    private func applyDesign()
    {
        self.backgroundColor = .whiteColor()
        self.clipsToBounds = true
        
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.blackColor().CGColor
        
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
        self.layer.cornerRadius = min(self.height, self.width) / 2
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