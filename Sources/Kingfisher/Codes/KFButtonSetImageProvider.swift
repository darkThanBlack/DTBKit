//
//  KFButtonSetImageProvider.swift
//  Pods
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
    
    public struct KFButtonSetImageProvider: Providers.ButtonSetImageProvider {
        
        public init() {}
        
        public func setImage(
            on button: UIButton,
            url: Any?,
            placeholder: Any?,
            completedHandler: ((Result<UIImage, Error>) -> Void)?
        ) {
            let targetURL: URL? = {
                if let url = url as? URL { return url }
                if let string = url as? String { return URL(string: string) }
                return nil
            }()
            button.kf.setImage(
                with: targetURL,
                for: .normal,
                placeholder: placeholder as? UIImage,
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        completedHandler?(.success(value.image))
                    case .failure(let error):
                        completedHandler?(.failure(error))
                    }
                }
            )
        }
    }
    
}
