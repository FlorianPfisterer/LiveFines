//
//  DrivingViewController.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 22.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import UIKit
import RealmSwift

class DrivingViewController: UIViewController
{
    // MARK: - IBOutlets
    @IBOutlet weak var speedLimitView: SpeedLimitView!
    @IBOutlet weak var speedometerView: SpeedometerView!

    @IBOutlet weak var punishmentsStackView: UIStackView!
    @IBOutlet weak var separatorBackgroundView: UIView!

    @IBOutlet weak var upperSeparatorView: UIView!
    @IBOutlet weak var lowerSeparatorView: UIView!

    @IBOutlet weak var expandedContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandedPunishmentsContainer: UIView!
    
    // MARK: - Private Variables
    private var punishmentViews: [Punishment.PType : PunishmentView] = [:]
    private var okayView: OkayView!
    
    private var realm: Realm!
    private var provider: NodeProvider!
    private let country = NSLocale.currentCountry()

    internal var state: ViewState = .standard {
        didSet
        {
            guard oldValue != self.state else { return }
            self.transition(to: self.state)
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.expandedContainerHeightConstraint.constant = 0
        self.view.backgroundColor = Constants.Color.darkGray

        self.setupDataProvider()
        self.setupPunishmentViews()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.provider?.startReceivingUpdates(self)
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

//        self.speedLimitView.hidden = true
//        self.separatorBackgroundView.hidden = true
//        self.punishmentsStackView.hidden = true
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.provider?.stopReceivingUpdates()
    }
    
    // MARK: - Setup
    private func setupDataProvider()
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
    
    private func setupPunishmentViews()
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
            punishmentView.hidden = true
            self.punishmentsStackView.addArrangedSubview(punishmentView)
            self.punishmentViews[ptype] = punishmentView
        }

        self.speedometerView.speedLimit = -100

        // create okay view
        self.okayView = OkayView(image: UIImage(named: "praiseIcon") ?? UIImage())
        self.okayView.showMessage = false
        self.okayView.title = "Weiter so!"  // TODO Localize
        self.punishmentsStackView.insertArrangedSubview(self.okayView, atIndex: 0)
    }
}

extension DrivingViewController: NodeUpdateReceiver
{
    func update(node node: Node)
    {
        self.speedLimitView.limit = node.speedLimit // TODO update animation?
        self.speedometerView.speedLimit = node.speedLimit
        self.configure(withPenalty: self.country.penalty(fromNode: node))

        self.state = (node.speed > node.speedLimit) ? .expanded : .standard
    }

    func update(speed speed: Int)
    {
        self.speedometerView.speed = speed
        self.configure(withPenalty: self.country.penalty(fromSpeed: speed, atLimit: self.speedLimitView.limit))
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
    private func configure(withPenalty penalty: Penalty?)
    {
        if let penalty = penalty where penalty.shouldPunish
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

        UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseIn, animations: {
            self.separatorBackgroundView.alpha = 1
        }, completion: nil)
    }
    
    private func clearPunishments()
    {
        self.okayView.animate(show: true)
        self.okayView.showMessage = self.speedLimitView.state != .unknown
        self.punishmentViews.values.each { $0.punishment = nil }
    }
}
