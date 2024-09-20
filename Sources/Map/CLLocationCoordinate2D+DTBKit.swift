//
//  CLLocationCoordinate2D+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/12/12
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import CoreLocation

/// Add type mark to reduce conversion frequency.
///
/// 支持链式转换，并尽量减少转换频率。
public struct DTBKitCoordinate2DTransfer {
    
    ///
    public enum Types {
        /// 世界大地坐标系(1984)
        case WGS_84
        /// 中国国家测绘局坐标系(2002)
        case GCJ_02
        /// 百度坐标系(2009)
        case BD_09
    }
    
    public let type: Types
    
    private let coordinate: CLLocationCoordinate2D
    
    public init(wgs coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.type = .WGS_84
    }
    
    public init(gcj coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.type = .GCJ_02
    }
    
    public init(bd coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.type = .BD_09
    }
    
    ///
    public var toWGS: CLLocationCoordinate2D {
        switch type {
        case .WGS_84:  return coordinate
        case .GCJ_02:  return CLLocationCoordinate2D.dtb.getWGSFromGCJ(coordinate)
        case .BD_09:   return CLLocationCoordinate2D.dtb.getWGSFromBD(coordinate)
        }
    }
    
    ///
    public var toGCJ: CLLocationCoordinate2D {
        switch type {
        case .WGS_84:  return CLLocationCoordinate2D.dtb.getGCJFromWGS(coordinate)
        case .GCJ_02:  return coordinate
        case .BD_09:   return CLLocationCoordinate2D.dtb.getGCJFromBD(coordinate)
        }
    }
    
    ///
    public var toBD: CLLocationCoordinate2D {
        switch type {
        case .WGS_84:  return CLLocationCoordinate2D.dtb.getBDFromWGS(coordinate)
        case .GCJ_02:  return CLLocationCoordinate2D.dtb.getBDFromGCJ(coordinate)
        case .BD_09:   return coordinate
        }
    }
}

/// Chain tranform
///
/// 链式转换
extension DTBKitWrapper where Base == CLLocationCoordinate2D {
    
    /// Mark it as WGS
    ///
    /// For example:
    /// ```
    ///  let p = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)  // WGS
    ///  let result = p.dtb.isWGS.toGCJ  // GCJ
    /// ```
    public var isWGS: DTBKitCoordinate2DTransfer {
        return DTBKitCoordinate2DTransfer(wgs: self.value)
    }
    
    /// Mark it as GCJ
    ///
    /// For example:
    /// ```
    ///  let p = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)  // GCJ
    ///  let result = p.dtb.isGCJ.toWGS  // WGS
    /// ```
    public var isGCJ: DTBKitCoordinate2DTransfer {
        return DTBKitCoordinate2DTransfer(gcj: self.value)
    }
    
    /// Mark it as BD
    ///
    /// For example:
    /// ```
    ///  let p = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)  // BD
    ///  let result = p.dtb.isBD.toGCJ  // GCJ
    /// ```
    public var isBD: DTBKitCoordinate2DTransfer {
        return DTBKitCoordinate2DTransfer(bd: self.value)
    }
}

///
extension DTBKitStaticWrapper where T == CLLocationCoordinate2D {
    
    /// WGS-84 --> GCJ-02
    public func getGCJFromWGS(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        /// 投影因子
        let a: Double = 6378245.0
        /// 偏心率
        let ee: Double = 0.00669342162296594323
        
        /// 纬度
        func getLatitudeWith(x: Double, y: Double) -> Double {
            var lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y
            lat += 0.2 * sqrt(fabs(x))
            lat += (20.0 * sin(6.0 * x * .pi)) * 2.0 / 3.0
            lat += (20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0
            lat += (20.0 * sin(y * .pi)) * 2.0 / 3.0
            lat += (40.0 * sin(y / 3.0 * .pi)) * 2.0 / 3.0
            lat += (160.0 * sin(y / 12.0 * .pi)) * 2.0 / 3.0
            lat += (320.0 * sin(y * .pi / 30.0)) * 2.0 / 3.0
            return lat
        }
        
        /// 经度
        func getLongitudeWith(x: Double, y: Double) -> Double {
            var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y
            lon +=  0.1 * sqrt(fabs(x))
            lon += (20.0 * sin(6.0 * x * .pi)) * 2.0 / 3.0
            lon += (20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0
            lon += (20.0 * sin(x * .pi)) * 2.0 / 3.0
            lon += (40.0 * sin(x / 3.0 * .pi)) * 2.0 / 3.0
            lon += (150.0 * sin(x / 12.0 * .pi)) * 2.0 / 3.0
            lon += (300.0 * sin(x / 30.0 * .pi)) * 2.0 / 3.0
            return lon
        }
        
        var result  = CLLocationCoordinate2D()
        var adjustLatitude  = getLatitudeWith(x: p.longitude - 105.0, y: p.latitude - 35.0)
        var adjustLongitude = getLongitudeWith(x: p.longitude - 105.0, y:p.latitude - 35.0)
        let radLatitude     = p.latitude / 180.0 * .pi
        var magic           = sin(radLatitude)
        magic               = 1 - ee * magic * magic
        let sqrtMagic       = sqrt(magic)
        adjustLatitude      = (adjustLatitude * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * .pi)
        adjustLongitude     = (adjustLongitude * 180.0) / (a / sqrtMagic * cos(radLatitude) * .pi)
        
        result.latitude     = p.latitude + adjustLatitude
        result.longitude    = p.longitude + adjustLongitude
        return result
    }
    
    /// GCJ-02 --> WGS-84
    public func getWGSFromGCJ(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        /// 判断 target 是否在 p1 和 p2 之间
        func isContains(target: CLLocationCoordinate2D, point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Bool {
            let latitudeIn = (target.latitude >= min(point1.latitude, point2.latitude)) && (target.latitude <= max(point1.latitude, point2.latitude))
            let longitudeIn = (target.longitude >= min(point1.longitude,point2.longitude)) && (target.longitude <= max(point1.longitude, point2.longitude))
            return latitudeIn && longitudeIn
        }
        
        // Binary search
        let threshold = 0.00001
        
        var minLat = p.latitude - 0.5
        var maxLat = p.latitude + 0.5
        var minLng = p.longitude - 0.5
        var maxLng = p.longitude + 0.5
        
        var delta = 1.0
        let maxIteration = 30
        
        while(true) {
            let leftBottom  = getGCJFromWGS(CLLocationCoordinate2D(latitude: minLat, longitude: minLng))
            let rightBottom = getGCJFromWGS(CLLocationCoordinate2D(latitude: minLat, longitude : maxLng))
            let leftUp      = getGCJFromWGS(CLLocationCoordinate2D(latitude: maxLat, longitude: minLng))
            let midPoint    = getGCJFromWGS(CLLocationCoordinate2D(latitude: ((minLat + maxLat) / 2), longitude: ((minLng + maxLng) / 2)))
            delta = fabs(midPoint.latitude - p.latitude) + fabs(midPoint.longitude - p.longitude)
            
            if (maxIteration <= 1) || (delta <= threshold) {
                return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2)
            }
            
            if isContains(target: p, point1: leftBottom, point2: midPoint) {
                maxLat = (minLat + maxLat) / 2
                maxLng = (minLng + maxLng) / 2
            } else if isContains(target: p, point1: rightBottom, point2: midPoint) {
                maxLat = (minLat + maxLat) / 2
                minLng = (minLng + maxLng) / 2
            } else if isContains(target: p, point1: leftUp, point2: midPoint) {
                minLat = (minLat + maxLat) / 2
                maxLng = (minLng + maxLng) / 2
            } else {
                minLat = (minLat + maxLat) / 2
                minLng = (minLng + maxLng) / 2
            }
        }
    }
    
    /// GCJ --> Baidu
    public func getBDFromGCJ(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude)
        + 0.00002 * sqrt(p.latitude * .pi)
        let t = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * .pi)
        var result = CLLocationCoordinate2D()
        result.latitude   = (z * sin(t) + 0.006)
        result.longitude  = (z * cos(t) + 0.0065)
        return result
    }
    
    /// Baidu --> GCJ
    public func getGCJFromBD(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x_pi: Double = .pi * 3000.0 / 180.0
        
        let x = p.longitude - 0.0065
        let y = p.latitude - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let t = atan2(y, x) - 0.000003 * cos(x *  x_pi)
        var result = CLLocationCoordinate2D()
        result.latitude  = z * sin(t)
        result.longitude = z * cos(t)
        return result
    }
    
    /// WGS --> Baidu
    public func getBDFromWGS(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return getBDFromGCJ(getGCJFromWGS(p))
    }
    
    /// Baidu --> WGS
    public func getWGSFromBD(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return getBDFromGCJ(getGCJFromWGS(p))
    }
    
    /// 不在中国区域内 (估算)
    public func notInChina(_ p: CLLocationCoordinate2D) -> Bool {
        return (p.longitude < 72.004) || (p.longitude > 137.8347) || (p.latitude < 0.8293) || (p.latitude > 55.8271)
    }
    
    /// 获取两点之间的距离 (米)
    public func distanceBetween(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) -> CLLocationDistance {
        /// 地球平均半径
        let r = 6371004.0
        
        let dd = Double.pi / 180.0
        let x1 = p1.latitude * dd
        let x2 = p2.latitude * dd
        let y1 = p1.longitude * dd
        let y2 = p2.longitude * dd
        
        let t = 2 - 2 * cos(x1) * cos(x2) * cos(y1 - y2) - 2 * sin(x1) * sin(x2)
        let distance = Double(2) * Double(r) * asin(sqrt(t) / 2)
        return distance
    }
}
