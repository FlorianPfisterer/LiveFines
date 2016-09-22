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
        return UIAlertAction(title: Localization.Plain.okay, style: .default, handler: nil)
    }
}

extension UIViewController: AlertPresenter
{
    func present(error: Alertifiable, completion: (() -> Void)? = nil)
    {
        self.present(error.alert, animated: true, completion: { _ in completion?() })
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
    static let edges: [NSLayoutAttribute] = [.leading, .top, .trailing, .bottom]
}

extension UIView
{
    // constraint
    func constrain(toEdgesOfView view: UIView, margin: @escaping (NSLayoutAttribute) -> CGFloat?)
    {
        NSLayoutAttribute.edges.each { attribute in
            if let constant = margin(attribute)
            {
                NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: constant).isActive = true
            }
        }
    }

    func constrainCenter(to view: UIView)
    {
        [NSLayoutAttribute.centerX, .centerY].each { attribute in
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal,
                toItem: view, attribute: attribute, multiplier: 1, constant: 0).isActive = true
        }
    }

    func constrain(width: CGFloat? = nil, height: CGFloat? = nil)
    {
        if let width = width
        {
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width).isActive = true
        }
        if let height = height
        {
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height).isActive = true
        }
    }
}

extension UIBezierPath
{
    func drawn(to point: CGPoint) -> UIBezierPath
    {
        self.addLine(to: point)
        return self
    }

    func moved(to point: CGPoint) -> UIBezierPath
    {
        self.move(to: point)
        return self
    }
}

protocol Showable
{
    var animatedSubviews: [UIView] { get }
    var setAlphaToZero: Bool { get }
    func animate(show: Bool)
}

extension UIView: Showable
{
    var animatedSubviews: [UIView] { return [] }
    var setAlphaToZero: Bool { return true }

    // MARK: - UI Update
    func animate(show: Bool)
    {
        guard self.isHidden != !show else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.isHidden = !show
            self.animatedSubviews.each { view in
                view.alpha = (show || !self.setAlphaToZero) ? 1 : 0
            }
        })
    }
}

extension UIColor
{
    func mixed(with color: UIColor, by fraction: CGFloat) -> UIColor
    {
        guard let c1 = self.cgColor.components, let c2 = color.cgColor.components else
        {
            return self
        }

        let factor = min(1, max(0, fraction))

        let r = CGFloat(c1[0] + (c2[0] - c1[0]) * factor)
        let g = CGFloat(c1[1] + (c2[1] - c1[1]) * factor)
        let b = CGFloat(c1[2] + (c2[2] - c1[2]) * factor)
        let a = CGFloat(c1[3] + (c2[3] - c1[3]) * factor)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
