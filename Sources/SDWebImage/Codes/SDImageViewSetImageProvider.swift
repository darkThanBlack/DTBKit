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
import SDWebImage

extension DTB {
    
    public struct SDImageViewSetImageProvider: Providers.ImageViewSetImageProvider {
        
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
            
            imageView.sd_setImage(
                with: targetURL,
                placeholderImage: placeholder as? UIImage
            ) { image, error, _, _ in
                if let error = error {
                    completedHandler?(.failure(error))
                } else if let image = image {
                    completedHandler?(.success(image))
                } else {
                    completedHandler?(.failure(NSError.dtb.reason("image is nil")))
                }
            }
        }
    }
    
}
