//
//  KFRemoteImageProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/1
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit
import Kingfisher

extension DTB {
    
    /// Kingfisher 的 RemoteImageProvider 适配器
    public struct KFRemoteImageProvider: Providers.RemoteImageProvider {
        
        public init() {}
        
        public func remote(_ value: Any?, completedHandler: ((Result<UIImage, Error>) -> ())?) {
            
            func anyUrl() -> URL? {
                if let url = value as? URL {
                    return url
                }
                if let string = value as? String {
                    return URL(string: string)
                }
                return nil
            }
            
            guard let url = anyUrl() else {
                completedHandler?(.failure(NSError.dtb.reason("empty url")))
                return
            }
            
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    completedHandler?(.success(value.image))
                case .failure(let error):
                    completedHandler?(.failure(error))
                }
            }
            
        }
        
    }
    
}
