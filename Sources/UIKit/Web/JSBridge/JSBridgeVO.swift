//
//  JSReceiveCallbackVM.swift
//  DTBKit
//
//  Created by moonShadow on 2024/2/1
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

/// 当 web 调用原生方法，并需要返回数据时进行包装
public struct JSBridgeVO {
    
    /// 成功 / 失败
    public var success: Bool?
    
    /// 报错信息
    public var message: String?
    
    /// 预留字段
    public var code: String?
    
    /// 要传递的数据
    public var result: Any?
    
    public static func success(_ result: Any?) -> JSBridgeVO {
        return .init(success: true, message: nil, code: nil, result: result)
    }
    
    public static func error(_ message: String?) -> JSBridgeVO {
        return .init(success: false, message: message, code: nil, result: nil)
    }
    
    public init(success: Bool? = nil, message: String? = nil, code: String? = nil, result: Any? = nil) {
        self.success = success
        self.message = message
        self.code = code
        self.result = result
    }
}
