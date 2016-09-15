//
//  ExpandedPunishmentsViewController.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 15.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

class ExpandedPunishmentsViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var mainAmountLabel: UILabel!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var mainTypeLabel: UILabel!

    

    // MARK: - Private Properties
    var state: State = .okay {
        didSet { self.view.backgroundColor = self.state.color }
    }

    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
}

// MARK: - Penalty Updates
extension ExpandedPunishmentsViewController
{
    enum State
    {
        case okay
        case medium
        case fatal

        var color: UIColor {
            switch self
            {
            case .okay: return Constants.Color.green
            case .medium: return Constants.Color.orange
            case .fatal: return Constants.Color.red
            }
        }
    }

    func updatePenalty(penalty: Penalty?)
    {

    }
}
