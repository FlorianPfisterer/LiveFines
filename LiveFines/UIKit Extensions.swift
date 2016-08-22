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