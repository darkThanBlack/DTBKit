//
//  DefaultStringProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/9/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import ObjectMapper

extension DTB {
    
    /// (String / Int64 / Number) -> Int64
    public struct LongTransform: TransformType {
        
        public init() {}
        
        public func transformFromJSON(_ value: Any?) -> Int64? {
            if let result = value as? String {
                return Int64(result)
            }
            if let result = value as? Int64 {
                return result
            }
            if let result = value as? NSNumber {
                return result.int64Value
            }
            return nil
        }
        
        public func transformToJSON(_ value: Int64?) -> String? {
            if let value = value {
                return String(value)
            }
            return nil
        }
    }
    
    /// List<(String / Int64 / Number)> -> Int64
    public class LongListTransform: TransformType {
        
        public init(){}
        
        public func transformFromJSON(_ value: Any?) -> [Int64]? {
            if let rs = value as? [Int64]{
                return rs
            } else if let rs = value as? [String] {
                return rs.compactMap{ Int64($0) }
            } else if let rs = value as? [NSNumber] {
                return rs.map{ $0.int64Value }
            } else{
                return nil
            }
        }
        
        public func transformToJSON(_ value: [Int64]?) -> [Int64]? {
            return value
        }
    }
    
    /// (String / Double / Number) -> Double
    public class DoubleTransform: TransformType {
        
        public init(){}
        
        public func transformFromJSON(_ value: Any?) -> Double? {
            if let result = value as? Double {
                return result
            } else if let result = value as? String {
                return Double(result)
            } else if let result = value as? NSNumber {
                return result.doubleValue
            } else{
                return nil
            }
        }
        
        public func transformToJSON(_ value: Double?) -> String? {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.usesGroupingSeparator = false
            if let value = value {
                return formatter.string(from: NSNumber(value: value))
            }
            return nil
        }
    }
    
    /// Java<T> -> Array
    public class GenericTransform<T:Mappable>: TransformType {
        //    public typealias Object = [T]
        
        //    public typealias JSON = [[String: Any]]
        
        public init(){}
        
        public func transformFromJSON(_ value: Any?) -> [T]? {
            if let list = value as? [[String: Any]] {
                return list.compactMap{ T(JSON: $0) }
            }
            if let dict = value as? [String:Any] {
                return T(JSON: dict).flatMap{ [$0] }
            }
            return nil
        }
        
        public func transformToJSON(_ value: [T]?) -> [[String : Any]]? {
            return value?.toJSON()
        }
    }
    
    /// 允许定义 var dict: [String: StudioVO]?  而非  var dict: [String: Any]?
    public class DictTransform<T: Mappable>: TransformType {
        
        public init(){}
        
        public func transformFromJSON(_ value: Any?) -> [String: T]? {
            guard let dict = value as? [String: Any], dict.isEmpty == false else {
                return nil
            }
            
            var nValue: [String: T] = [:]
            dict.forEach { k, v in
                if let subDict = v as? [String: Any],
                   subDict.isEmpty == false,
                   let model = T(JSON: subDict) {
                    nValue[k] = model
                }
            }
            return nValue.isEmpty ? nil : nValue
        }
        
        public func transformToJSON(_ value: [String: T]?) -> [String: [String: Any]]? {
            guard let dict = value, dict.isEmpty == false else {
                return nil
            }
            var nValue: [String: [String: Any]] = [:]
            dict.forEach { k, v in
                nValue[k] = v.toJSON()
            }
            return nValue.isEmpty ? nil : nValue
        }
    }
    
}
