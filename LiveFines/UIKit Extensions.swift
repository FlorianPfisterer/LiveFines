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