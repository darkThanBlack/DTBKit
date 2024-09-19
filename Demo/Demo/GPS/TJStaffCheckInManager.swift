//
//  TJStaffCheckInManager.swift
//  XMBundleLN
//
//  Created by moonShadow on 2023/12/7
//  Copyright © 2023 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import CoreLocation

//import Butterfly_Business

///
struct TJStaffCheckInRegionModel {
    
    /// GCJ02
    let region: CLCircularRegion
    
    let id: Int64
    
    let name: String?
    
    init(region: CLCircularRegion, id: Int64, name: String?) {
        self.region = region
        self.id = id
        self.name = name
    }
    
}

///
class TJStaffCheckInManager: NSObject {
    
    private var regions: [TJStaffCheckInRegionModel] = []
    
    private var currentRegionKey: String? = nil
    
    var currentRegion: TJStaffCheckInRegionModel? {
        return regions.first(where: { $0.region.identifier == currentRegionKey })
    }
    
    func stopMonitor() {
        regions.removeAll()
    }
    
    func addMonitor(list: [TJStaffCheckInRegionModel]) {
        self.regions += list
    }
    
    func checkRegionContains(coordinate: CLLocationCoordinate2D) {
        if let model = regions.first(where: { $0.region.contains(coordinate) }) {
            currentRegionKey = model.region.identifier
            print("MOON__LOG  is in region id=\(model.region.identifier)")
        } else {
            currentRegionKey = nil
            print("MOON__LOG  not in all...")
        }
    }
    
    func startLocation() {
        loc.startUpdatingLocation()
    }
    
    func stopLocation() {
        loc.stopUpdatingLocation()
    }
    
    private lazy var loc: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        return manager
    }()
}

extension TJStaffCheckInManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        print("MOON__LOG  lati=\(coordinate.latitude), longti=\(coordinate.longitude)")
        
        // FIXME:
//        checkRegionContains(coordinate: coordinate.dtb.isWGS.toGCJ)
        checkRegionContains(coordinate: coordinate)
    }
}
