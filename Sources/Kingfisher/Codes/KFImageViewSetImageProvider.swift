//
//  KFImageViewSetImageProvider.swift
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
    
    public struct KFImageViewSetImageProvider: Providers.ImageViewSetImageProvider {
        
        public init() {}
        
        public func setImage(
            on imageView: UIImageView,
            url: Any?,
            placeholder: Any?,
            completedHandler: ((Result<UIImage, Error>) -> Void)?
        ) {
            let targetURL: URL? = {
                if let url = url as? URL { return url }
                if let string = url as? String { return URL(string: string) }
                return nil
            }()
            
            imageView.kf.setImage(
                with: targetURL,
                placeholder: placeholder as? UIImage,
                options: nil,
            ) { result in
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
