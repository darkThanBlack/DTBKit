//
//  UIImageView+UI.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

#if canImport(Kingfisher)
import Kingfisher
#endif

#if canImport(SDWebImage)
import SDWebImage
#endif

extension Wrapper where Base: UIImageView {
    
    @discardableResult
    public func setImageData(_ data: DTB.ImageData?) -> Self {
        if let image = data?.image {
            me.image = image
            return self
        }
        if let localName = data?.localName, let image = UIImage.dtb.create(localName) {
            me.image = image
            return self
        }
        if let localPath = data?.localPath, let image = UIImage(contentsOfFile: localPath) {
            me.image = image
            return self
        }
        // FIXME: replacement for provider
        if let remoteUrl = data?.remoteUrl, let url = URL(string: remoteUrl) {
#if canImport(Kingfisher)
            me.kf.setImage(with: url)
#endif
            
#if canImport(SDWebImage)
            me.sd_setImage(with: url)
#endif
        }
        return self
    }
}
