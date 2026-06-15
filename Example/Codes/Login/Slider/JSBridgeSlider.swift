//
//  JSBridgeSlider.swift
//  DTBKit
//
//  Created by moonShadow on 2024/2/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import WebKit

/// 滑块验证
public struct JSBridgeSlider: DTB.JSBridgePlugin, Codable {
    
    public var csessionid: String?
    
    public var sig: String?
    
    public var token: String?
    
    public init(csessionid: String? = nil, sig: String? = nil, token: String? = nil) {
        self.csessionid = csessionid
        self.sig = sig
        self.token = token
    }
    
    public typealias ParamsType = Self
    
    public static func funcName() -> String {
        return "getSlideData"
    }
    
    private static var nativeCallBack: ((ParamsType?) -> ())? = nil
    
    /// web -> 原生, 注意是同步释放
    public static func setupNativeCallBack(_ handler: ((ParamsType?) -> ())?) {
        nativeCallBack = { params in
            defer { nativeCallBack = nil }
            handler?(params)
        }
    }
    
    public static func receiveCall(_ controller: UIViewController?, view: WKWebView?, params: JSBridgeSlider?, callback: ((Any?) -> Void)?) {
        nativeCallBack?(params)
        callback?(nil)
    }
}
