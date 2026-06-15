//
//  DefaultMoyaProvider+RxSwift.swift
//  Ring
//
//  Created by moonShadow on 2026/6/2
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Moya
import RxSwift
import ObjectMapper

extension Reactive where Base: DTB.DefaultMoyaProvider {
    
    ///
    public func requestRx(
        _ target: Base.Target,
        config: DTB.DefaultMoyaProviderConfig = .default
    ) -> Observable<Any?> {
        return Single<Any?>.create { [weak base] single in
            let token: Moya.Cancellable? = base?.request(
                target,
                config: config,
                completion: { result in
                    switch result {
                    case .success(let data):
                        if data == nil, config.failWhenNil {
                            single(.failure(NSError.dtb.reason("result is nil")))
                            return
                        }
                        single(.success(data))
                    case .failure(let error):
                        // 无需业务层去 toast
                        let isCancel = (error as NSError).code == NSURLErrorCancelled
                        let message = error.localizedDescription
                        if config.autoError,
                           isCancel == false,
                           message.isEmpty == false {
                            DispatchQueue.main.async {
                                UIView.dtb.toast(message)
                            }
                        }
                        single(.failure(error))
                    }
                }
            )
            
            return Disposables.create {
                token?.cancel()
            }
        }.asObservable()
    }
}

// MARK: - RxSwift + ObjectMapper extension

public extension Observable {
    
    ///
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            let dict = response as? [String: Any] ?? [:]
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    ///
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            let list = response as? [[String: Any]] ?? []
            return Mapper<T>().mapArray(JSONArray: list)
        }
    }
}
