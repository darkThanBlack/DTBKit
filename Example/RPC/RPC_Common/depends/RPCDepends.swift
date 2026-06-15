//
//  SportBaseTargets.swift
//  Alamofire
//
//  Created by moonShadow on 2024/1/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


@_exported import DTBKit

// === alias for DTBKit_ObjectMapper ===

public typealias LongTransform = DTB.LongTransform
public typealias LongListTransform = DTB.LongListTransform
public typealias DoubleTransform = DTB.DoubleTransform
public typealias GenericTransform = DTB.GenericTransform
public typealias DictTransform = DTB.DictTransform



// === default value for Moya.TargetType ===

import Moya

public extension TargetType {
    
    var baseURL: URL {
        // FIXME: convert to provider...
        // FIXME: host...
        return URL(string: "https://baidu.com")!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
