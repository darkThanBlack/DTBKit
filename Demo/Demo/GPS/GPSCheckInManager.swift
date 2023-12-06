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
    
    func checkOnce() {
        if let first = loc.monitoredRegions.first {
            loc.requestState(for: first)
        }
    }
    
    func addMonitor(lati: CLLocationDegrees, longi: CLLocationDegrees, radius: CLLocationDistance) {
        let identifier = UUID().uuidString
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lati, longitude: longi), radius: radius, identifier: identifier)
        loc.startMonitoring(for: region)
        
        print("region added: identifier=\(identifier)")
    }
    
    private lazy var loc: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }()
}

extension GPSCheckInManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: identifier=\(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: identifier=\(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("didDetermineState: identifier=\(region.identifier), state=\(state)")
    }
}
