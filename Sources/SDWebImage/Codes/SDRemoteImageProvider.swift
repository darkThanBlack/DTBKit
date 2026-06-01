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
import SDWebImage

extension DTB {
    
    public struct SDRemoteImageProvider: Providers.RemoteImageProvider {
        
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
            
            SDWebImageManager.shared.loadImage(
                with: url,
                options: [.retryFailed],
                progress: nil
            ) { image, data, error, _, finished, _ in
                if let error = error {
                    completedHandler?(.failure(error))
                } else if let image = image, finished {
                    completedHandler?(.success(image))
                } else {
                    completedHandler?(.failure(NSError.dtb.reason("image is nil")))
                }
            }
        }
        
    }
    
}
