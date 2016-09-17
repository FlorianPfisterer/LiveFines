//
//  UIKit Extensions.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 20.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

extension UIAlertAction
{
    static var okay: UIAlertAction {
        return UIAlertAction(title: Localization.Plain.okay, style: .Default, handler: nil)
    }
}

extension UIViewController: AlertPresenter
{
    func present(error error: Alertifiable, completion: (() -> Void)? = nil)
    {
        self.presentViewController(error.alert, animated: true, completion: { _ in completion?() })
    }
}

extension UIView
{
    var width: CGFloat {
        return self.bounds.size.width
    }
    
    var height: CGFloat {
        return self.bounds.size.height
    }
    
    var innerCenter: CGPoint {
        return CGPoint(x: self.width/2, y: self.height/2)
    }

    var upperRight: CGPoint {
        return CGPoint(x: self.frame.origin.x + self.width, y: self.frame.origin.y)
    }

    var lowerLeft: CGPoint {
        return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.height)
    }
    
    var radius: CGFloat {
        return min(self.height, self.width) / 2
    }
}

extension CGRect
{
    var outerCenter: CGPoint {
        return CGPoint(x: self.origin.x + self.size.width/2,
                       y: self.origin.y + self.size.height/2)
    }

    var lowerOuterCenter: CGPoint {
        return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y + self.size.height)
    }
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGVector
{
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

extension NSLayoutAttribute
{
    static let edges: [NSLayoutAttribute] = [.Leading, .Top, .Trailing, .Bottom]
}

extension UIView
{
    // constraint
    func constrain(toEdgesOfView view: UIView, margin: (NSLayoutAttribute) -> CGFloat?)
    {
        NSLayoutAttribute.edges.each { attribute in
            if let constant = margin(attribute)
            {
                NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: view, attribute: attribute, multiplier: 1, constant: constant).active = true
            }
        }
    }

    func constrainCenter(to view: UIView)
    {
        [NSLayoutAttribute.CenterX, .CenterY].each { attribute in
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal,
                toItem: view, attribute: attribute, multiplier: 1, constant: 0).active = true
        }
    }

    func constrain(width width: CGFloat? = nil, height: CGFloat? = nil)
    {
        if let width = width
        {
            NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal,
                               toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width).active = true
        }
        if let height = height
        {
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal,
                               toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height).active = true
        }
    }
}

extension UIBezierPath
{
    func draw(to point: CGPoint) -> UIBezierPath
    {
        self.addLineToPoint(point)
        return self
    }

    func move(to point: CGPoint) -> UIBezierPath
    {
        self.moveToPoint(point)
        return self
    }
}

protocol Showable
{
    var animatedSubviews: [UIView] { get }
    var setAlphaToZero: Bool { get }
    func animate(show show: Bool)
}

extension UIView: Showable
{
    var animatedSubviews: [UIView] { return [] }
    var setAlphaToZero: Bool { return true }

    // MARK: - UI Update
    func animate(show show: Bool)
    {
        guard self.hidden != !show else { return }
        UIView.animateWithDuration(0.3, animations: {
            self.hidden = !show
            self.animatedSubviews.each { view in
                view.alpha = (show || !self.setAlphaToZero) ? 1 : 0
            }
        })
    }
}