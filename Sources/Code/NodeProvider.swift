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
    func update(node: Node)
    func update(speed: Int)
    func receivedInvalidData()
}

final class NodeProvider: NSObject
{
    // MARK: - Data Provider
    fileprivate let locationManager: CLLocationManager
    fileprivate var locationCache: CLLocation?
    fileprivate var isFetchingLocation = false
    
    fileprivate var speedlimitProvider: HereJSONDataProvider
    fileprivate var speedlimitCallbackId: Int?
    
    // MARK: - Other Private Properties
    fileprivate weak var updateReceiver: NodeUpdateReceiver?
    
    fileprivate let country: Country
    fileprivate var realm: Realm
    
    // MARK: - Initialization
    init(requestHandler: URLRequestHandler, realm: Realm)
    {
        self.locationManager = CLLocationManager()
        self.speedlimitProvider = HereJSONDataProvider(requestHandler: requestHandler)
        
        self.country = Locale.currentCountry
        self.realm = realm
        
        super.init()
        
        self.setupLocationManager()
        self.speedlimitCallbackId = self.speedlimitProvider.registerCallback(self.speedlimitUpdate)
    }
    
    // MARK: - Setup
    fileprivate func setupLocationManager()
    {
        self.locationManager.delegate = self
        self.locationManager.activityType = .automotiveNavigation
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 0
        
        self.locationManager.requestAlwaysAuthorization()
    }
}

extension NodeProvider
{
    // MARK: - Public Functions
    func startReceivingUpdates(_ receiver: NodeUpdateReceiver)
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
        if let id = self.speedlimitCallbackId { self.speedlimitProvider.unregisterCallback(with: id) }
        
        self.locationManager.stopUpdatingLocation()
        self.isFetchingLocation = false
    }
}

extension NodeProvider: CLLocationManagerDelegate
{
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last , location.horizontalAccuracy > 0 else
        {
            self.handle(error: .local(LocationError.noLocations))
            return 
        }

        self.speedUpdate(location.speed)
        
        // no significant input changes
        if let cache = self.locationCache , cache ≈ location { return }
        self.locationCache = location
        
        self.locationUpdate(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error)
    {
        self.handle(error: .local(LocationError.other(error.localizedDescription)))
    }
    
    // MARK: - Callbacks
    fileprivate func speedUpdate(_ speed: Double)
    {
        let roundedKmh = Int(speed * 3.6)
        self.updateReceiver?.update(speed: roundedKmh)
    }

    fileprivate func locationUpdate(_ location: CLLocation)
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
    
    func speedlimitUpdate(_ speedlimitResult: Result<(HereSpeedLimit, CLLocation)>)
    {
        switch speedlimitResult
        {
        case .error(let error):
            self.handle(error: error)
            self.updateReceiver?.receivedInvalidData()
            
        case .success((let speedLimit, let location)):
            print("API REQUEST --------------------------------------")
            let node = Node(location: location, speedLimit: speedLimit.kmh, linkId: speedLimit.linkId)
            Database.insert(object: node, intoRealm: self.realm)
            
            self.updateReceiver?.update(node: node)
        }
    }
}

extension NodeProvider
{
    // MARK: - Realm Querying
    fileprivate func query(forNodeAtLocation location: CLLocation) -> Result<Node>
    {
        let node = Node.node(closeToLocation: location, inRealm: self.realm)
        return node == nil ? .error(.local(LocationError.noMatchingNodes)) : .success(node!)
    }
}

extension NodeProvider
{
    fileprivate func handle(error: LFError)
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
