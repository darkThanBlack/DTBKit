//
//  BaseMoyaTargetType.swift
//  Ring
//
//  Created by moonShadow on 2026/6/3
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Moya

extension DTB {
    
    public protocol DefaultMoyaTargetType: Moya.TargetType {}
}

public extension DTB.DefaultMoyaTargetType {
    
    var baseURL: URL {
        return URL(string: DTB.NetworkManager.shared.host())!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
