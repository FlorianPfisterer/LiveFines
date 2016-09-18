//
//  ExpandedPunishmentsViewController.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 15.09.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit

private let punishmentViewHeight: CGFloat = 80
private let okayImageViewSize: CGFloat = 120

class ExpandedPunishmentsViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var mainContainerView: UIView!
    fileprivate let okayImageView = UIImageView()

    fileprivate var showsMainPunishment: Bool = false
    @IBOutlet weak var mainAmountLabel: UILabel!
    @IBOutlet weak var mainCurrencyLabel: UILabel!
    @IBOutlet weak var mainTypeLabel: UILabel!

    fileprivate var showsAdditionalPunishments: Int = 0 {
        didSet {
            self.stackViewHeightConstraint.constant = CGFloat(self.showsAdditionalPunishments) * punishmentViewHeight
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var upperAdditionalPunishmentView: AdditionalPunishmentView!
    @IBOutlet weak var lowerAdditionalPunishmentView: AdditionalPunishmentView!

    // MARK: - Private Properties
    var state: State = .okay {
        didSet {
            UIView.animate(withDuration: self.state == .okay ? 0.3 : 0.6, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.view.backgroundColor = self.state.color
                self.okayImageView.alpha = self.state == .okay ? 1 : 0
            }, completion: nil)
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureOkayImageView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    fileprivate func configureOkayImageView()
    {
        self.okayImageView.contentMode = .scaleAspectFit
        self.okayImageView.image = UIImage(named: "praiseIconInversed")
        self.okayImageView.translatesAutoresizingMaskIntoConstraints = false
        self.okayImageView.alpha = 0
        self.view.addSubview(self.okayImageView)

        self.okayImageView.constrainCenter(to: self.view)
        self.okayImageView.constrain(width: okayImageViewSize, height: okayImageViewSize)
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

    func updatePenalty(_ penalty: Penalty?)
    {
        // TODO state
        if let penalty = penalty, let financial = penalty[.financial]
        , penalty.shouldPunish
        {
            self.state = .fatal // TODO

            let restPunishments = penalty.allPunishments.filter({ $0 != financial })
            self.showMainPunishment(financial)
            self.showAdditionalPunishments(restPunishments)
        }
        else
        {
            self.clearPunishments()
        }
    }

    fileprivate func showMainPunishment(_ punishment: Punishment)
    {
        self.mainAmountLabel.text = "\(punishment.amount)"
        self.mainCurrencyLabel.text = "€"   // TODO
        self.mainTypeLabel.text = "\(punishment.plainTypeDescription)"

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.mainContainerView.alpha = 1
        }, completion: nil)
    }

    fileprivate func showAdditionalPunishments(_ punishments: [Punishment])
    {
        self.showsAdditionalPunishments = punishments.count // adjusts the stackview height

        switch punishments.count
        {
        case 0:
            self.upperAdditionalPunishmentView.alpha = 0
            self.lowerAdditionalPunishmentView.alpha = 0
            self.lowerAdditionalPunishmentView.isHidden = true

        case 1:
            self.upperAdditionalPunishmentView.configure(with: punishments[0])
            self.upperAdditionalPunishmentView.alpha = 1
            self.lowerAdditionalPunishmentView.alpha = 0
            self.lowerAdditionalPunishmentView.isHidden = true

        case 2:
            self.upperAdditionalPunishmentView.configure(with: punishments[0])
            self.upperAdditionalPunishmentView.alpha = 1
            self.lowerAdditionalPunishmentView.configure(with: punishments[1])
            self.lowerAdditionalPunishmentView.alpha = 1
            self.lowerAdditionalPunishmentView.isHidden = false


        default: return
        }
    }

    fileprivate func clearPunishments()
    {
        self.state = .okay
        self.showsAdditionalPunishments = 0
        self.upperAdditionalPunishmentView.alpha = 0
        self.lowerAdditionalPunishmentView.alpha = 0
        self.lowerAdditionalPunishmentView.isHidden = true

        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.mainContainerView.alpha = 0
        }, completion: nil)
    }
}
