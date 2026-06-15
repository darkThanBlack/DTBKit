//
//  DTBKitString+DTB.swift
//  DTBKit
//
//  Created by moonShadow on 2023/12/28
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Moya
import RxSwift
import ObjectMapper

extension DTB {
    
    public struct DefaultMoyaProviderConfig {
        
        public static let `default` = DefaultMoyaProviderConfig()
        
        /// Moya.MoyaProviderType
        var callbackQueue: DispatchQueue? = nil
        
        /// Moya.MoyaProviderType
        var progress: Moya.ProgressBlock? = nil
        
        /// 执行业务动画
        var autoAnimate: Bool
        
        /// 执行业务解析
        var autoParse: Bool
        
        /// 执行业务报错
        var autoError: Bool
        
        /// 当发现
        /// 1> 返回的原始值是 nil 时
        /// 2> autoParse == true 时, 业务原始值是 nil 时
        ///
        /// true: 认为是 failure，构建 Error
        /// false: 认为可以忽略，尝试构建默认值
        var failWhenNil: Bool
        
        public init(
            callbackQueue: DispatchQueue? = nil,
            progress: Moya.ProgressBlock? = nil,
            autoAnimate: Bool = true,
            autoParse: Bool = true,
            autoError: Bool = true,
            failWhenNil: Bool = false
        ) {
            self.callbackQueue = callbackQueue
            self.progress = progress
            self.autoAnimate = autoAnimate
            self.autoParse = autoParse
            self.autoError = autoError
            self.failWhenNil = failWhenNil
        }
    }
    
    public class DefaultMoyaProvider: MoyaProvider<MultiTarget>, ReactiveCompatible {
        
        /// 每个 provider 通过 uuid 构建一个自己独有的请求池
        public let poolKey = DTB.ConstKey<[String: (any Moya.Cancellable)]>("moya.cancelable.\(UUID().uuidString)")
        
        /// 页面销毁时, 自动取消所有未完成的请求，并且摧毁请求池
        deinit {
            let requestPool = DTB.app.get(poolKey) ?? [:]
            requestPool.forEach({ $0.value.cancel() })
            DTB.app.set(nil, key: poolKey)
        }
        
        weak var hudTarget: UIView? = nil
        
        public init(_ hudTarget: UIView? = nil) {
            self.hudTarget = hudTarget
            
            ///
            let endpointClosure: ((Target) -> Endpoint) = { (target) in
                
                // TODO: 公共参数
                var url = URL(target: target).absoluteString
                //            if target.method != .post {
                //                url = url.dtb.appendCommonUrlParams().value
                //            }
                
                // TODO: 公共 Header
                var headers = target.headers ?? [:]
                //            DTB.HTTPHeaderKeys.allDict.forEach { item in
                //                headers[item.key] = item.value
                //            }
                
                return Endpoint(
                    url: url,
                    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: headers
                )
            }
            
            ///
            let requestClosure: RequestClosure = { (endpoint: Endpoint, done: RequestResultClosure) in
                guard var urlRequest = try? endpoint.urlRequest() else {
                    MoyaProvider<MultiTarget>.defaultRequestMapping(for: endpoint, closure: done)
                    return
                }
                // 超时时长
                urlRequest.timeoutInterval = 10
                done(.success(urlRequest))
            }
            
            ///
            let plugins: [PluginType] = [
                AnimatePlugin(),
                LoggerPlugin(),
                ParserPlugin()
            ]
            
            super.init(
                endpointClosure: endpointClosure,
                requestClosure: requestClosure,
                stubClosure: MoyaProvider<MultiTarget>.neverStub(_:),
                callbackQueue: nil,
                session: MoyaProvider<Target>.defaultAlamofireSession(),
                plugins: plugins,
                trackInflights: false
            )
        }
        
        /// 换取自定义 Moya.Completion
        ///
        /// - autoParse == true: 认为返回值最外层是统一结构, 尝试用 MainVO 去解析一层
        /// - autoParse == false: 直接返回最原始的数据
        private func customCompletion(
            autoAnimate: Bool,
            autoParse: Bool,
            completion: ((_ result: Swift.Result<Any?, Error>) -> Void)?
        ) -> Moya.Completion {
            return { [weak self] (_ result: Swift.Result<Moya.Response, MoyaError>) in
                if autoAnimate {
                    DispatchQueue.main.async {
                        let hudTargetView = self?.hudTarget ?? UIViewController.dtb.topMost()?.view
                        UIView.dtb.hideHUD(on: hudTargetView)
                    }
                }
                
                switch result {
                case .success(let response):
                    guard autoParse else {
                        completion?(.success(response.data))
                        return
                    }
                    // 自定义业务解析
                    
                    do {
                        let mapped = try response.mapJSON()
                        guard let dict = mapped as? [String: Any],
                              let vo = DTB.MainVO(JSON: dict) else {
                            throw MoyaError.jsonMapping(response)
                        }
                        
                        if vo.success == true {
                            completion?(.success(vo.result))
                        } else {
                            // TODO: parse appMessage if needed
                            let code = Int(vo.code ?? "") ?? -1
                            completion?(.failure(NSError.dtb.create(vo.message, code: code)))
                        }
                    } catch {
                        guard autoParse else {
                            completion?(.success(response.data))
                            return
                        }
                        completion?(.failure(error))
                    }
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
        
        /// 自定义请求统一入口
        public func request(
            _ target: Moya.MultiTarget,
            config: DTB.DefaultMoyaProviderConfig = .default,
            completion: ((_ result: Swift.Result<Any?, Error>) -> Void)?
        ) -> Moya.Cancellable {
            if config.autoAnimate {
                DispatchQueue.main.async {
                    let hudTargetView = self.hudTarget ?? UIViewController.dtb.topMost()?.view
                    UIView.dtb.showHUD(on: hudTargetView)
                }
            }
            
            let customCompletion = customCompletion(
                autoAnimate: config.autoAnimate,
                autoParse: config.autoParse,
                completion: completion
            )
            return request(
                target,
                callbackQueue: config.callbackQueue,
                progress: config.progress,
                completion: customCompletion
            )
        }
    }
}
