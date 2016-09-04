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
    @IBOutlet weak var speedLimitView: SpeedLimitView!
    @IBOutlet weak var speedometerView: SpeedometerView!

    @IBOutlet weak var punishmentsStackView: UIStackView!
    @IBOutlet weak var separatorBackgroundView: UIView!

    private var punishmentViews: [Punishment.PType : PunishmentView] = [:]
    private var okayView: OkayView!
    
    private var realm: Realm!
    private var provider: NodeProvider!
    private let country = NSLocale.currentCountry()

    // MARK: - View Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        self.separatorBackgroundView.alpha = 1
        print(self.okayView.imageView.height)

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

        self.okayView?.removeFromSuperview()
        self.punishmentViews.removeAll()
        self.punishmentsStackView.subviews.each { $0.removeFromSuperview() }
        
        for ptype in Punishment.PType.all
        {
            let punishmentView = PunishmentView()
            self.punishmentsStackView.addArrangedSubview(punishmentView)
            self.punishmentViews[ptype] = punishmentView
        }

        // create okay view
        self.okayView = OkayView(image: UIImage(named: "praiseIcon") ?? UIImage())
        self.okayView.hidden = true
        self.okayView.title = "Weiter so!"
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
    }

    func update(speed speed: Int)
    {
        self.speedometerView.speed = speed
        self.configure(withPenalty: self.country.penalty(fromSpeed: speed, limit: self.speedLimitView.limit))
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
    }
    
    private func clearPunishments()
    {
        self.okayView.animate(show: true)
        self.punishmentViews.values.each { $0.punishment = nil }
    }
}
