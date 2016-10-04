//
//  CircularTransition.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 22.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

class CircularTransition: NSObject
{
    // MARK: - Configurations
    fileprivate var duration: TimeInterval = 0.3

    var circleColor = UIColor.white
    var transitionMode: CircularTransitionMode = .present

    // MARK: - Views & Layout
    fileprivate var circle = UIView()

    var startingPoint = CGPoint.zero {
        didSet {
            self.circle.center = self.startingPoint
        }
    }
}

extension CircularTransition: UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView

        switch self.transitionMode
        {
        case .present:
            guard let presentedView = transitionContext.view(forKey: .to) else { return }

            let viewCenter = presentedView.center
            let viewSize = presentedView.frame.size

            self.circle = UIView()
            self.circle.frame = self.circleFrame(at: viewCenter, size: viewSize, startPoint: self.startingPoint)
            self.circle.center = self.startingPoint
            self.circle.layer.cornerRadius = self.circle.bounds.size.width / 2
            self.circle.backgroundColor = self.circleColor
            self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(self.circle)

            presentedView.center = self.startingPoint
            presentedView.alpha = 0
            presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            containerView.addSubview(presentedView)

            UIView.animate(withDuration: self.duration, animations: {
                self.circle.transform = CGAffineTransform.identity
                presentedView.transform = CGAffineTransform.identity
                presentedView.alpha = 1
                presentedView.center = viewCenter   // reset the center
            }, completion: { success in
                transitionContext.completeTransition(success)
            })

        case .pop, .dismiss:
            let transitionModeKey: UITransitionContextViewKey = self.transitionMode == .pop ? .to : .from
            guard let returningView = transitionContext.view(forKey: transitionModeKey) else { return }

            let viewCenter = returningView.center
            let viewSize = returningView.frame.size

            self.circle.frame = self.circleFrame(at: viewCenter, size: viewSize, startPoint: self.startingPoint)
            self.circle.layer.cornerRadius = self.circle.bounds.size.width / 2
            self.circle.center = self.startingPoint

            UIView.animate(withDuration: self.duration, animations: {
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningView.center = self.startingPoint
                returningView.alpha = 0

                if self.transitionMode == .pop
                {
                    containerView.insertSubview(returningView, belowSubview: returningView)
                    containerView.insertSubview(self.circle, belowSubview: returningView)
                }
            }, completion: { success in

                returningView.center = viewCenter
                returningView.removeFromSuperview()
                self.circle.removeFromSuperview()

                transitionContext.completeTransition(success)
            })

            return
        }
    }

    fileprivate func circleFrame(at center: CGPoint, size: CGSize, startPoint: CGPoint) -> CGRect
    {
        let xLength = fmax(startPoint.x, size.width - startPoint.x)
        let yLength = fmax(startPoint.y, size.height - startPoint.y)

        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2      // radius so the whole screen is covered * 2
        let newSize = CGSize(width: offsetVector, height: offsetVector)

        return CGRect(origin: CGPoint.zero, size: newSize)
    }
}

// MARK: - Additional Types
extension CircularTransition
{
    enum CircularTransitionMode: Int
    {
        case present
        case dismiss
        case pop
    }
}
