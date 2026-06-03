//
//  UIImageView+Theme.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/27
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension Wrapper where Base: UIImageView {
    
    @discardableResult
    public func setImage(with url: Any?, placeholder: Any? = nil, completedHandler: ((Result<UIImage, Error>) -> Void)? = nil) -> Self {
        if let p = DTB.Providers.get(DTB.Providers.imageViewSetImageKey) {
            p.setImage(on: me, url: url, placeholder: placeholder, completedHandler: completedHandler)
        }
        return self
    }
}
