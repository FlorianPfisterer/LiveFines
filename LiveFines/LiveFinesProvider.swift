//
//  LiveFinesProvider.swift
//  LiveFines
//
//  Created by Florian Pfisterer on 18.08.16.
//  Copyright © 2016 Florian Pfisterer. All rights reserved.
//

import Foundation
import CoreLocation

protocol LiveFinesUpdateReceiver: class
{
    func updateData(result: Result<Int>)
}

final class LiveFinesProvider: NSObject
{
    // MARK: - Data Provider
    private let locationManager: CLLocationManager
    
    private var speedlimitProvider: HereJSONDataProvider
    private var speedlimitCallbackId: Int?
    
    // MARK: - Other Private Properties
    private weak var updateReceiver: LiveFinesUpdateReceiver?
    
    private var drivingData: DrivingData
    private let country: Country
    
    // MARK: - Initialization
    init(requestHandler: URLRequestHandler)
    {
        self.locationManager = CLLocationManager()
        self.speedlimitProvider = HereJSONDataProvider(requestHandler: requestHandler)
        
        self.drivingData = DrivingData()
        self.country = NSLocale.currentCountry()
        
        super.init()
        
        self.speedlimitCallbackId = self.speedlimitProvider.registerCallback(self.speedlimitUpdate)
    }
}

extension LiveFinesProvider
{
    // MARK: - Public Functions
    func startReceivingUpdates(receiver: LiveFinesUpdateReceiver)
    {
        self.updateReceiver = receiver
          // TODO start the process with location updates
    }
    
    func stopReceivingUpdates()
    {
        self.updateReceiver = nil
        
        // unregister Callbacks
        if let id = self.speedlimitCallbackId { self.speedlimitProvider.unregisterCallback(withId: id) }
    }
}

extension LiveFinesProvider
{
    // MARK: - Callbacks
    func speedlimitUpdate(speedlimitResult: Result<HereSpeedLimit>)
    {
        
    }
}