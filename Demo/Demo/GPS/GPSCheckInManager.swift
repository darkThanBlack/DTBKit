//
//  GPSCheckInManager.swift
//  Demo
//
//  Created by moonShadow on 2023/12/4
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import CoreLocation

struct CheckInLimitModel {
    
    
}

class GPSCheckInManager: NSObject {
    
    static let shared = GPSCheckInManager()
    private override init() {}
    
    func stopMonitor() {
        loc.monitoredRegions.forEach({ loc.stopMonitoring(for: $0) })
    }
    
    func addMonitor(lati: CLLocationDegrees, longi: CLLocationDegrees, radius: CLLocationDistance) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lati, longitude: longi), radius: radius, identifier: UUID().uuidString)
        loc.startMonitoring(for: region)
    }
    
    func startMonitor() {
        
    }
    
    private lazy var loc: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        // CLCircularRegion(center: <#T##CLLocationCoordinate2D#>, radius: <#T##CLLocationDistance#>, identifier: <#T##String#>)
        return manager
    }()
    
}

extension GPSCheckInManager: CLLocationManagerDelegate {
    
}
