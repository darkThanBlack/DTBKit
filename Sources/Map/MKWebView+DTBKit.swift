//
//  MKWebView+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/12/12
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import MapKit

extension Wrapper where Base: MKMapView {
    
    ///
    public func getZoomLevel() -> Int {
        return Int(log2(360.0 * (Double(me.frame.size.width / 256.0) / me.region.span.longitudeDelta)) + 1.0)
    }
    
    ///
    public func setZoomLevel(_ value: Int, animated: Bool = true) {
        let span = MKCoordinateSpan(
            latitudeDelta: 0,
            longitudeDelta: 360.0 / pow(2, Double(value)) * Double(me.frame.size.width) / 256.0
        )
        let region = MKCoordinateRegion(center: me.centerCoordinate, span: span)
        me.setRegion(region, animated: animated)
    }

}
