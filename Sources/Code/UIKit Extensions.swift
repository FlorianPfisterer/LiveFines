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
    
    var radius: CGFloat {
        return min(self.height, self.width) / 2
    }
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