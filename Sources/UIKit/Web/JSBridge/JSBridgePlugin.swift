//
//  JSBridgeHandler.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/30
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import WebKit
import WKWebViewJavascriptBridge

extension DTB {
    
    /// JS -> 原生
    public protocol JSBridgePlugin {
        
        /// 方法名
        static func funcName() -> String
        
        /// 实现类自身就是 web 端参数定义
        associatedtype ParamsType: Codable
        
        /// 当 webJS 调用原生方法时触发
        ///
        /// - Parameters:
        ///   - controller: controller description
        ///   - view: view description
        ///   - params: params description
        ///   - callback: 会自动尝试 json 转换和模型包装
        static func receiveCall(_ controller: UIViewController?, view: WKWebView?, params: ParamsType?, callback: ((_ result: Any?) -> Void)?)
    }
    
    ///
    public class JSBridgeHandler {
        
        private let bridge: WKWebViewJavascriptBridge
        
        private weak var controller: UIViewController?
        
        private weak var view: WKWebView?
        
        public required init(inject controller: UIViewController?, view: WKWebView) {
            self.controller = controller
            self.view = view
            
            bridge = WKWebViewJavascriptBridge(webView: view)
        }
        
        deinit {
            DTB.console.log("JSBridgeHandler deinit...")
        }
        
        /// 单独注册
        public func register<T>(receive obj: T) where T: JSBridgePlugin {
            bridge.register(handlerName: T.funcName()) { [weak self] parameters, callback in
                var params: T.ParamsType? = nil
                if let jsonStr = parameters as? String,
                   let jsonData = jsonStr.data(using: .utf8),
                   let model = try? JSONDecoder().decode(T.ParamsType.self, from: jsonData) {
                    params = model
                }
                T.receiveCall(
                    self?.controller,
                    view: self?.view,
                    params: params
                ) { result in
                    callback?(result)
                }
            }
        }
        
        /// 原生 调 JS 示例
        public func callTest() {
            bridge.call(handlerName: "viewDidAppear", data: "") { responseData in
                // do sth.
            }
        }
        
    }
    
}
