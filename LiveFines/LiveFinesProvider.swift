//
//  LiveFinesProvider.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

protocol LiveFinesUpdateReceiver: class
{
    func update(node node: Node)
}

final class LiveFinesProvider: NSObject
{
    // MARK: - Data Provider
    private let locationManager: CLLocationManager
    private var locationCache: CLLocation?
    private var isFetchingLocation = false
    
    private var speedlimitProvider: HereJSONDataProvider
    private var speedlimitCallbackId: Int?
    
    // MARK: - Other Private Properties
    private weak var updateReceiver: LiveFinesUpdateReceiver?
    
    private var drivingData: DrivingData
    private let country: Country
    private var realm: Realm
    
    // MARK: - Initialization
    init(requestHandler: URLRequestHandler, realm: Realm)
    {
        self.locationManager = CLLocationManager()
        self.speedlimitProvider = HereJSONDataProvider(requestHandler: requestHandler)
        
        self.drivingData = DrivingData()
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
        
        self.locationManager.requestAlwaysAuthorization()
    }
}

extension LiveFinesProvider
{
    // MARK: - Public Functions
    func startReceivingUpdates(receiver: LiveFinesUpdateReceiver)
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
    }
}

extension LiveFinesProvider: CLLocationManagerDelegate
{
    // MARK: - Location Manager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last where location.horizontalAccuracy > 0 else
        {
            print("ERROR")
            return // TODO
        }
        
        // no significant input changes
        if let cache = self.locationCache where cache ≈ location { return }
        self.locationCache = location
        
        self.locationUpdate(location)
    }
    
    // MARK: - Callbacks
    private func locationUpdate(location: CLLocation)
    {
        let result = self.query(forNodesAtLocation: location)
        switch result
        {
        case .success(let nodes):
            guard !nodes.isEmpty else { fatalError() }
            self.updateReceiver?.update(node: nodes.first!)
            
        case .error(_):
            self.speedlimitProvider.updateInputData(location)   // request a new speedlimit
        }
    }
    
    func speedlimitUpdate(speedlimitResult: Result<(HereSpeedLimit, CLLocation)>)
    {
        switch speedlimitResult
        {
        case .error(let error): print(error)
        case .success((let speedLimit, let location)):
            let node = Node(coordinate: location.coordinate, speedLimit: speedLimit.kmh)
            Database.insert(node: node, intoRealm: self.realm)
            self.updateReceiver?.update(node: node)
        }
    }
}

extension LiveFinesProvider
{
    // MARK: - Realm Querying
    private func query(forNodesAtLocation location: CLLocation) -> Result<[Node]>
    {
        let nodes = self.realm.nodes(closeToLocation: location)
        return nodes.isEmpty ? .error(.other("No Nodes Found")) : .success(nodes)
    }
}