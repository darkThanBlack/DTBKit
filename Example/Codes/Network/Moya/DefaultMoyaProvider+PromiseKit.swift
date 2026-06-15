//
//  DefaultMoyaProvider+PromiseKit.swift
//  Ring
//
//  Created by moonShadow on 2026/6/2
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Moya
import ObjectMapper
import PromiseKit

extension DTB.DefaultMoyaProvider {
    
    ///
    public func requestPromise(
        _ target: Moya.MultiTarget,
        config: DTB.DefaultMoyaProviderConfig = .default
    ) -> Promise<Any?> {
        let key = UUID().uuidString
        return Promise<Any?> { seal in
            let token = request(
                target,
                config: config,
                completion: { result in
                    // 请求完成, 从请求池中删除
                    //
                    // 因为
                    // - moya 当 request cancel 时也会执行回调
                    // - provider 自己销毁时会影响当前的 promise
                    // 所以
                    // - 在 moya 回调中直接处理，不要依赖 promise 生命周期
                    var dict = DTB.app.get(self.poolKey) ?? [:]
                    dict[key] = nil
                    DTB.app.set(dict, key: self.poolKey)
                    
                    switch result {
                    case .success(let data):
                        if data == nil, config.failWhenNil {
                            seal.reject(NSError.dtb.reason("result is nil"))
                            return
                        }
                        seal.fulfill(data)
                    case .failure(let error):
                        let isCancel = (error as NSError).code == NSURLErrorCancelled
                        let message = error.localizedDescription.isEmpty ? "请求失败" : error.localizedDescription
                        if config.autoError, isCancel == false {
                            DispatchQueue.main.async {
                                UIView.dtb.toast(message)
                            }
                        }
                        seal.reject(error)
                    }
                }
            )
            
            // 放到当前的请求池中
            // provider deinit 时会遍历并执行 cancel()
            var dict = DTB.app.get(self.poolKey) ?? [:]
            dict[key] = token
            DTB.app.set(dict, key: self.poolKey)
        }
    }
    
    public func requestPromiseObject<T: Mappable>(
        _ target: Moya.MultiTarget,
        config: DTB.DefaultMoyaProviderConfig = .default,
        type: T.Type
    ) -> Promise<T> {
        requestPromise(target, config: config)
            .then { data in
                return Promise<T> { seal in
                    guard let dict = (data as? [String: Any]) ?? (config.failWhenNil ? nil : [:]) else {
                        seal.reject(NSError.dtb.reason("result is not vaild json dict or nil"))
                        return
                    }
                    guard let model = Mapper<T>().map(JSON: dict) else {
                        seal.reject(NSError.dtb.reason("result object mapper to \(type) faild"))
                        return
                    }
                    seal.fulfill(model)
                }
            }
    }
    
    public func requestPromiseArray<T: Mappable>(
        _ target: Moya.MultiTarget,
        config: DTB.DefaultMoyaProviderConfig = .default,
        type: T.Type
    ) -> Promise<[T]> {
        requestPromise(target, config: config)
            .then { data in
                return Promise<[T]> { seal in
                    guard let list = data as? [[String: Any]] ?? (config.failWhenNil ? nil : []) else {
                        seal.reject(NSError.dtb.reason("result is not vaild json array or nil"))
                        return
                    }
                    let modelList = Mapper<T>().mapArray(JSONArray: list)
                    seal.fulfill(modelList)
                }
            }
    }
    
}
