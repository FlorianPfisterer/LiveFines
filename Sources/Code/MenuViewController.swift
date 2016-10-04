//
//  MenuViewController.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 22.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var menuToggleButton: UIButton!


}

// MARK: - IBActions
extension MenuViewController
{
    @IBAction func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
