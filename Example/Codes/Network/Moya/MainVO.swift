//
//  MainVO.swift
//  Ring
//
//  Created by moonShadow on 2026/6/3
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import ObjectMapper

extension DTB {
    
    /// 假设接口最外层的返回数据统一
    public struct MainVO {
        
        ///
        var code: String?
        
        /// 报错信息
        var message: String?
        
        ///
        var success: Bool?
        
        /// 业务数据
        var result: Any?
        
        /// 特定路由
        var appMessage: String?
    }
}

extension DTB.MainVO: ObjectMapper.Mappable {
    public init?(map: ObjectMapper.Map) {}
    
    public mutating func mapping(map: ObjectMapper.Map) {
        code <- map["code"]
        message <- map["message"]
        success <- map["success"]
        result <- map["result"]
        appMessage <- map["appMessage"]
    }
}
