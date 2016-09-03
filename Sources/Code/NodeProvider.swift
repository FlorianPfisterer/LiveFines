//
//  NodeProvider.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

protocol NodeUpdateReceiver: class, AlertPresenter
{
    func update(node node: Node)
}

final class NodeProvider: NSObject
{
    // MARK: - Data Provider
    private let locationManager: CLLocationManager
    private var locationCache: CLLocation?
    private var isFetchingLocation = false
    
    private var speedlimitProvider: HereJSONDataProvider
    private var speedlimitCallbackId: Int?
    
    // MARK: - Other Private Properties
    private weak var updateReceiver: NodeUpdateReceiver?
    
    private let country: Country
    private var realm: Realm
    
    // MARK: - Initialization
    init(requestHandler: URLRequestHandler, realm: Realm)
    {
        self.locationManager = CLLocationManager()
        self.speedlimitProvider = HereJSONDataProvider(requestHandler: requestHandler)
        
        self.country = NSLocale.currentCountry()
        self.realm = realm
        
        super.init()
        
        self.setupLocationManager()
        self.speedlimitCallbackId = self.speedlimitProvider.registerCallback(self.speedlimitUpdate)
    }
    
    // MARK: - Setup
    private func setupLocationManager()
    {
        self.locationManager.delegate = self
        self.locationManager.activityType = .AutomotiveNavigation
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 0
        
        self.locationManager.requestAlwaysAuthorization()
    }
}

extension NodeProvider
{
    // MARK: - Public Functions
    func startReceivingUpdates(receiver: NodeUpdateReceiver)
    {
        self.updateReceiver = receiver
        
        if !self.isFetchingLocation
        {
            self.isFetchingLocation = true
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func stopReceivingUpdates()
    {
        self.updateReceiver = nil
        
        // unregister Callbacks
        if let id = self.speedlimitCallbackId { self.speedlimitProvider.unregisterCallback(withId: id) }
        
        self.locationManager.stopUpdatingLocation()
        self.isFetchingLocation = false
    }
}

extension NodeProvider: CLLocationManagerDelegate
{
    // MARK: - Location Manager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last where location.horizontalAccuracy > 0 else
        {
            self.handle(error: .local(LocationError.noLocations))
            return 
        }
        
        // no significant input changes
        if let cache = self.locationCache where cache ≈ location { return }
        self.locationCache = location
        
        self.locationUpdate(location)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        self.handle(error: .local(LocationError.other(error.localizedDescription)))
    }
    
    // MARK: - Callbacks
    private func locationUpdate(location: CLLocation)
    {
        // query the database for similar location nodes
        let result = self.query(forNodeAtLocation: location)
        switch result
        {
        case .success(let node):
            Database.update(object: node.visit(), inRealm: self.realm)
            self.updateReceiver?.update(node: node)
            
        case .error(_):
            self.speedlimitProvider.updateInputData(location)   // request a new speedlimit
        }
    }
    
    func speedlimitUpdate(speedlimitResult: Result<(HereSpeedLimit, CLLocation)>)
    {
        switch speedlimitResult
        {
        case .error(let error):
            self.handle(error: error)
            
        case .success((let speedLimit, let location)):
            let node = Node(location: location, speedLimit: speedLimit.kmh, linkId: speedLimit.linkId)
            Database.insert(object: node, intoRealm: self.realm)
            
            self.updateReceiver?.update(node: node)
        }
    }
}

extension NodeProvider
{
    // MARK: - Realm Querying
    private func query(forNodeAtLocation location: CLLocation) -> Result<Node>
    {
        let node = Node.node(closeToLocation: location, inRealm: self.realm)
        return node == nil ? .error(.local(LocationError.noMatchingNodes)) : .success(node!)
    }
}

extension NodeProvider
{
    private func handle(error error: LFError)
    {
        switch error
        {
        case .user(let alertifiable):
            self.updateReceiver?.present(error: alertifiable, completion: nil)

        default:
            Log.error(error)
        }
    }
}