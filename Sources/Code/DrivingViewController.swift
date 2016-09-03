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
    @IBOutlet weak var punishmentsStackView: UIStackView!
    private var punishmentViews: [Punishment.PType : PunishmentView] = [:]
    
    private var realm: Realm!
    private var provider: NodeProvider!
    private let country = NSLocale.currentCountry()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupDataProvider()
        self.setupPunishmentViews()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.provider.startReceivingUpdates(self)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.provider.stopReceivingUpdates()
    }
    
    // MARK: - Setup
    private func setupDataProvider()
    {
        switch Database.realm()
        {
        case .error(let error) where error is Alertifiable:
            self.present(error: error as! Alertifiable)
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
//        self.punishmentViews.removeAll()
//        self.punishmentsStackView.subviews.each { $0.removeFromSuperview() }
//        
//        for ptype in Punishment.PType.all
//        {
//            let punishmentView = PunishmentView()
//            self.punishmentsStackView.addArrangedSubview(punishmentView)
//            self.punishmentViews[ptype] = punishmentView
//        }
    }
}

extension DrivingViewController: NodeUpdateReceiver
{
    func update(node node: Node)
    {
        self.speedLimitView.limit = node.speedLimit
        self.configure(withPenalty: self.country.penalty(fromNode: node))
    }
}

extension DrivingViewController
{
    private func configure(withPenalty penalty: Penalty?)
    {
        guard let penalty = penalty where penalty.shouldPunish else
        {
            self.clearPunishments()
            return
        }
        
        
    }
    
    private func clearPunishments()
    {
        
    }
}
