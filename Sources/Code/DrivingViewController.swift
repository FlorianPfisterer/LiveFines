//
//  DrivingViewController.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 22.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate let expandedPunishmentVCIdentifier = "ExpandedPunishmentsViewController"
fileprivate let expandTimeout: TimeInterval = 1
fileprivate let standardTimeout: TimeInterval = 3

fileprivate let motivators = ["Weiter so !", "Super !", "So ist's brav !", "Gut so !", "Brav !", "Du fährst günstig !", "Fantastisch !", "Gute Fahrt !"]

class DrivingViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var speedLimitView: SpeedLimitView!
    @IBOutlet weak var speedometerView: SpeedometerView!

    @IBOutlet weak var punishmentsStackView: UIStackView!
    @IBOutlet weak var separatorBackgroundView: UIView!

    @IBOutlet weak var upperSeparatorView: UIView!
    @IBOutlet weak var lowerSeparatorView: UIView!
    
    // MARK: - Private Variables
    internal var expandedPunishmentsController: ExpandedPunishmentsViewController?
    internal var expandedPunishmentsVCHeightConstraint: NSLayoutConstraint?

    fileprivate var punishmentViews: [Punishment.PType : PunishmentView] = [:]
    fileprivate var okayView: OkayView!
    
    fileprivate var realm: Realm!
    fileprivate var provider: NodeProvider!
    fileprivate let country = Locale.currentCountry

    fileprivate var punishedSince: TimeInterval?
    fileprivate var okaySince: TimeInterval?
    internal var state: ViewState = .standard {
        didSet
        {
            guard oldValue != self.state else { return }
            self.transition(to: self.state)

            if self.state == .standard
            {
                self.okayView.title = motivators.randomElement
            }
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.Color.darkGray

        self.setupDataProvider()
        self.setupPunishmentViews()
        self.setupExpandedPunishmentController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.provider?.startReceivingUpdates(self)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

//        self.speedLimitView.hidden = true
//        self.separatorBackgroundView.hidden = true
//        self.punishmentsStackView.hidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.provider?.stopReceivingUpdates()
    }
    
    // MARK: - Setup
    fileprivate func setupDataProvider()
    {
        switch Database.realm()
        {
        case .error(let error as Alertifiable):
            self.present(error: error)
            return
            
        case .error(let error):
            Log.error(error)
            return
            
        case .success(let realm):
            self.realm = realm
            self.provider = NodeProvider(requestHandler: AlamofireRequestHandler(), realm: realm)
        }
    }
    
    fileprivate func setupPunishmentViews()
    {
        self.separatorBackgroundView.alpha = 0
//
//        self.okayView?.removeFromSuperview()
//        self.punishmentViews.removeAll()
//        self.punishmentsStackView.subviews.each { $0.removeFromSuperview() }
//        
        for ptype in Punishment.PType.all
        {
            let punishmentView = PunishmentView()
            punishmentView.isHidden = true
            self.punishmentsStackView.addArrangedSubview(punishmentView)
            self.punishmentViews[ptype] = punishmentView
        }

        self.speedometerView.speedLimit = -100

        // create okay view
        self.okayView = OkayView(image: UIImage(named: "praiseIcon") ?? UIImage())
        self.okayView.showMessage = false
        self.okayView.title = motivators.randomElement
        self.punishmentsStackView.insertArrangedSubview(self.okayView, at: 0)
    }

    fileprivate func setupExpandedPunishmentController()
    {
        guard let storyboard = self.storyboard,
              let expandedPunishmentsVC = storyboard.instantiateViewController(withIdentifier: expandedPunishmentVCIdentifier) as? ExpandedPunishmentsViewController else
        {
            print("ERROR: couldn't instantiate ExpandedPunishmentsVC!")
            return
        }

        expandedPunishmentsVC.willMove(toParentViewController: self)
        self.view.addSubview(expandedPunishmentsVC.view)
        self.addChildViewController(expandedPunishmentsVC)
        expandedPunishmentsVC.didMove(toParentViewController: self)

        // add constraints
        expandedPunishmentsVC.view.translatesAutoresizingMaskIntoConstraints = false
        expandedPunishmentsVC.view.constrain(toEdgesOfView: self.view, margin: { attribute in
            switch attribute
            {
            case .leading, .trailing: return 0
            default: return nil
            }
        })

        NSLayoutConstraint(item: expandedPunishmentsVC.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

        let heightConstraint = NSLayoutConstraint(item: expandedPunishmentsVC.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 460)
        heightConstraint.isActive = true
        self.expandedPunishmentsVCHeightConstraint = heightConstraint

        self.expandedPunishmentsController = expandedPunishmentsVC
    }
}

// MARK: - Node Updates
extension DrivingViewController: NodeUpdateReceiver
{
    func update(node: Node)
    {
        self.speedLimitView.limit = node.speedLimit // TODO update animation?
        self.speedometerView.speedLimit = node.speedLimit
        let penalty = self.country.penalty(fromNode: node)
        self.configure(withPenalty: penalty)
    }

    func update(speed: Int)
    {
        self.speedometerView.speed = speed
        let penalty = self.country.penalty(fromSpeed: speed, atLimit: self.speedLimitView.limit)
        self.configure(withPenalty: penalty)
    }

    func receivedInvalidData()
    {
        // TODO timeout
        self.speedLimitView.limit = -1
        self.speedometerView.speedLimit = -100
        self.okayView.showMessage = false
        self.configure(withPenalty: nil)
    }
}

extension DrivingViewController
{
    fileprivate func configure(withPenalty penalty: Penalty?)
    {
        self.updateViewState(for: penalty)
        self.expandedPunishmentsController?.updatePenalty(penalty)
        
        if let penalty = penalty , penalty.shouldPunish
        {
            self.okayView.animate(show: false)

            // set up the punishment views properly
            for ptype in Punishment.PType.all
            {
                self.punishmentViews[ptype]?.punishment = penalty[ptype]    // hides or shows the view
            }
        }
        else
        {
            self.clearPunishments()
        }

        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            self.separatorBackgroundView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func clearPunishments()
    {
        self.okayView.animate(show: true)
        self.okayView.showMessage = self.speedLimitView.state != .unknown
        self.punishmentViews.values.each { $0.punishment = nil }
    }

    fileprivate func updateViewState(for penalty: Penalty?)
    {
        if let penalty = penalty, penalty.shouldPunish
        {
            if let punishedSince = self.punishedSince, TimeInterval.now >= punishedSince + expandTimeout, self.state != .expanded
            {
                self.state = .expanded
                self.punishedSince = nil
            }
            else if self.state == .standard
            {
                self.punishedSince = TimeInterval.now
            }
        }
        else if let okaySince = self.okaySince
        {
            if TimeInterval.now >= okaySince + standardTimeout
            {
                self.okaySince = nil
                self.state = .standard
            }
        }
        else if self.state == .expanded
        {
            self.okaySince = TimeInterval.now
        }
    }
}
