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
    
    /// WGS84
    let region: CLCircularRegion

    let id: Int64

    let name: String?

//    init?(addressVO: EmployeeAttendanceAddressVO) {
//        guard addressVO.state != .ON,
//            let addressId = addressVO.id,
//              let lati = addressVO.latitude, lati > 0,
//              let longi = addressVO.longitude, longi > 0,
//              let radius = addressVO.attendanceRange, radius > 0 else {
//            return nil
//        }
//        self.id = addressId
//
//        let center = XMLBSUtil.transformGCJToWGS(location: CLLocationCoordinate2D(latitude: lati, longitude: longi))
//        self.region = CLCircularRegion(center: center, radius: CLLocationDistance(radius), identifier: UUID().uuidString)
//        self.name = addressVO.title
//    }
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
        
        if let model = regions.first(where: { $0.region.contains(coordinate) }) {
            currentRegionKey = model.region.identifier
            print("MOON__LOG  is in region id=\(model.region.identifier)")
        } else {
            currentRegionKey = nil
            print("MOON__LOG  not in all...")
        }
    }
}

//MARK: -

/// Add type mark to reduce conversion frequency.
///
/// 尽量减少转换频率。
public struct DTBKitCoordinateAdapter {
    
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
    
    public let coordinate: CLLocationCoordinate2D
    
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
    
}

extension DTBKitStaticWrapper where T == CLLocationCoordinate2D {
    
    /// WGS-84 --> GCJ-02
    public static func getGCJFromWGS(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        /// 地球的平均半径
        let r = 6371004.0
        /// 投影因子
        let a: Double = 6378245.0
        /// 偏心率
        let ee: Double = 0.00669342162296594323
        
        /// 维度
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
    public static func getWGSFromGCJ(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
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
            let leftBottom  = getWGSToGCJ(CLLocationCoordinate2D(latitude: minLat, longitude: minLng))
            let rightBottom = getWGSToGCJ(CLLocationCoordinate2D(latitude: minLat, longitude : maxLng))
            let leftUp      = getWGSToGCJ(CLLocationCoordinate2D(latitude: maxLat, longitude: minLng))
            let midPoint    = getWGSToGCJ(CLLocationCoordinate2D(latitude: ((minLat + maxLat) / 2), longitude: ((minLng + maxLng) / 2)))
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
    public static func getBDFromGCJ(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude)
        + 0.00002 * sqrt(p.latitude * .pi)
        let t = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * .pi)
        var result = CLLocationCoordinate2D()
        result.latitude   = (z * sin(t) + 0.006)
        result.longitude  = (z * cos(t) + 0.0065)
        return result
    }
    
    /// Baidu --> GCJ
    public static func getGCJFromBD(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
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
    public static func getBDFromWGS(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return getBDFromGCJ(getGCJFromWGS(p))
    }
    
    /// Baidu --> WGS
    public static func getWGSFromBD(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return getBDFromGCJ(getGCJFromWGS(p))
    }
}

//
// [refer](https://www.jianshu.com/p/1f87fe10b860)

//WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）
//GCJ-02：中国坐标偏移标准，Google Map、高德、腾讯使用
//BD-09： 百度坐标偏移标准，Baidu Map使用
class XMLBSUtil {
    
    // 圆周率
    private static let pi = Double.pi
    private static let xpi: Double = pi * 3000.0 / 180.0

    /// 地球的平均半径
    private static let r = 6371004.0
    /// 投影因子
    private static let a: Double = 6378245.0
    /// 偏心率
    private static let e: Double = 0.00669342162296594323
    
//    // 坐标转换 标准坐标系-> 中国坐标系
//    //          WGS-84 --> GCJ-02
//    // wgsLocation:     标准坐标
//    static func transformWGSToGCJ(wgsLocation:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        var adjustLocation  = CLLocationCoordinate2D()
//        var adjustLatitude  = transformLatitudeWith(x: wgsLocation.longitude - 105.0,
//                                                    y:wgsLocation.latitude - 35.0)
//        var adjustLongitude = transformLongitudeWith(x: wgsLocation.longitude - 105.0,
//                                                     y:wgsLocation.latitude - 35.0)
//        let radLatitude     = wgsLocation.latitude / 180.0 * pi
//        var magic           = sin(radLatitude)
//        magic               = 1 - e * magic * magic
//        let sqrtMagic       = sqrt(magic)
//        adjustLatitude      = (adjustLatitude * 180.0) / ((a * (1 - e)) / (magic * sqrtMagic) * pi)
//        adjustLongitude     = (adjustLongitude * 180.0) / (a / sqrtMagic * cos(radLatitude) * pi)
//
//        adjustLocation.latitude     = wgsLocation.latitude + adjustLatitude
//        adjustLocation.longitude    = wgsLocation.longitude + adjustLongitude
//        return adjustLocation
//    }
//
//    // 纬度转换
//    //
//    static  func transformLatitudeWith(x: Double,
//                                              y: Double ) -> Double
//    {
//        var lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y
//        lat += 0.2 * sqrt(fabs(x))
//
//        lat += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0
//        lat += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
//        lat += (20.0 * sin(y * pi)) * 2.0 / 3.0
//        lat += (40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
//        lat += (160.0 * sin(y / 12.0 * pi)) * 2.0 / 3.0
//        lat += (320 * sin(y * pi / 30.0)) * 2.0 / 3.0
//        return lat
//    }
//
//    // 经度转换
//    //
//    static func transformLongitudeWith(x: Double,
//                                              y: Double )-> Double
//    {
//        var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y
//        lon +=  0.1 * sqrt(fabs(x))
//        lon += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0
//        lon += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
//        lon += (20.0 * sin(x * pi)) * 2.0 / 3.0
//        lon += (40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
//        lon += (150.0 * sin(x / 12.0 * pi)) * 2.0 / 3.0
//        lon += (300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
//        return lon
//    }
    
    // 坐标转换 中国坐标系 -> 百度坐标系
    //          GCJ-02 --> BD-09
    // location:     中国标准坐标
//    static func transformGCJToBaidu(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        let z = sqrt(location.longitude * location.longitude + location.latitude * location.latitude)
//        + 0.00002 * sqrt(location.latitude * pi)
//        let t = atan2(location.latitude, location.longitude) + 0.000003 * cos(location.longitude * pi)
//        var geoPoint        = CLLocationCoordinate2D()
//        geoPoint.latitude   = (z * sin(t) + 0.006)
//        geoPoint.longitude  = (z * cos(t) + 0.0065)
//        return geoPoint
//    }
    
    // 坐标转换 百度坐标系 -> 中国坐标系
    //          BD-09 --> GCJ-02
    // location:     百度坐标
    
    //
//    static func transformBaiduToGCJ(location: CLLocationCoordinate2D)-> CLLocationCoordinate2D {
//        let x       = location.longitude - 0.0065
//        let y       = location.latitude - 0.006
//        let z       = sqrt(x * x + y * y) - 0.00002 * sin(y * xpi)
//        let t       = atan2(y, x) - 0.000003 * cos(x *  xpi)
//        var geoPoint = CLLocationCoordinate2D()
//        geoPoint.latitude  = z * sin(t)
//        geoPoint.longitude = z * cos(t)
//        return geoPoint
//    }
    
//    // 坐标转换 中国坐标系-> 标准坐标系
//    //          GCJ-02 --> WGS-84
//    // wgsLocation:     中国坐标
//    static func transformGCJToWGS(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        let threshold       = 0.00001
//        // The boundary
//        var minLat          = location.latitude - 0.5
//        var maxLat          = location.latitude + 0.5
//        var minLng          = location.longitude - 0.5
//        var maxLng          = location.longitude + 0.5
//
//        var delta           = 1.0
//        let maxIteration    = 30
//        // Binary search
//        while(true)
//        {
//            let leftBottom  = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: minLat,
//                                                                                    longitude: minLng))
//            let rightBottom = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: minLat,
//                                                                                    longitude : maxLng))
//            let leftUp      = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: maxLat,
//                                                                                    longitude: minLng))
//            let midPoint    = transformWGSToGCJ(wgsLocation: CLLocationCoordinate2D(latitude: ((minLat + maxLat) / 2),
//                                                                                    longitude: ((minLng + maxLng) / 2)))
//            delta = fabs(midPoint.latitude - location.latitude) + fabs(midPoint.longitude - location.longitude)
//
//            if(maxIteration <= 1 || delta <= threshold) {
//                return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2)
//            }
//
//            if(isContains(target: location, point1: leftBottom, point2: midPoint))
//            {
//                maxLat = (minLat + maxLat) / 2
//                maxLng = (minLng + maxLng) / 2
//            }
//            else if(isContains(target: location, point1: rightBottom, point2: midPoint))
//            {
//                maxLat = (minLat + maxLat) / 2
//                minLng = (minLng + maxLng) / 2
//            }
//            else if(isContains(target: location, point1: leftUp, point2: midPoint))
//            {
//                minLat = (minLat + maxLat) / 2
//                maxLng = (minLng + maxLng) / 2
//            }
//            else
//            {
//                minLat = (minLat + maxLat) / 2
//                minLng = (minLng + maxLng) / 2
//            }
//        }
//
//    }
    
//    //WGS-84 --> BD-09
//    static func transformFromWGSToBaidu(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        let gcjLocation = transformWGSToGCJ(wgsLocation: location)
//        let bdLocation = transformGCJToBaidu(location: gcjLocation)
//        return bdLocation
//    }
//
//    //BD-09 --> WGS-84
//    static func transformFromBaiduToWGS(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        let gcjLocation = transformBaiduToGCJ(location: location)
//        let wgsLocation = transformGCJToWGS(location: gcjLocation)
//        return wgsLocation
//    }
    
//    //判断点是否在p1和p2之间
//    //point: 点
//    //point1:    点1
//    //point2:    点2
//    static func isContains(target:CLLocationCoordinate2D ,
//                                  point1:CLLocationCoordinate2D,
//                                  point2: CLLocationCoordinate2D ) -> Bool
//    {
//        let latitudeIn = target.latitude >= min(point1.latitude, point2.latitude) && target.latitude <= max(point1.latitude, point2.latitude)
//        let longitudeIn = target.longitude >= min(point1.longitude,point2.longitude) && target.longitude <= max(point1.longitude, point2.longitude)
//
//        return latitudeIn && longitudeIn
//    }
    
    static func isLocationOutOfChina(location:CLLocationCoordinate2D) -> Bool
    {
        if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271){
            return true
        }else{
            return false
        }
    }
    
    
    
    
    // 获取两点之间的距离(米)
    static func distanceBeteen(point1Latitude    : Double,
                                      point1Longitude   : Double,
                                      point2Latitude    : Double,
                                      point2Longitude   : Double )->Double{
        
        let dd          = pi / 180
        let x1          = point1Latitude * dd
        let x2          = point2Latitude * dd
        let y1          = point1Longitude * dd
        let y2          = point2Longitude * dd
        
        let t = 2 - 2 * cos(x1) * cos(x2) * cos(y1 - y2) - 2 * sin(x1) * sin(x2)
        let distance = Double(2) * Double(r) * asin(sqrt(t) / 2)
        return   distance
        
    }
    
    // 获取两点之间的距离 (米)
    static func distanceBeteen(point1:CLLocationCoordinate2D,
                                      point2:CLLocationCoordinate2D ) -> Double{
        let distance = distanceBeteen(point1Latitude: point1.latitude,
                                      point1Longitude: point1.longitude,
                                      point2Latitude: point2.latitude,
                                      point2Longitude: point2.longitude)
        return distance
        
    }
}
