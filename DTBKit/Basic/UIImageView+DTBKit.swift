//
//  UIImageView+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/19
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension DTBKitWrapper where Base: UIImageView {
    
    /// Create resource image by name.
    ///
    /// See ``UIImage.dtb.named()`` for more information.
    @discardableResult
    public func setImageNamed(
        _ name: String,
        bundleName: String? = nil,
        frameworkName: String? = nil,
        classType: AnyClass? = nil,
        types: [String] = ["png", "jpg", "webp", "jpeg"]
    ) -> Self {
        me.image = UIImage.dtb.named(name, bundleName: bundleName, frameworkName: frameworkName, classType: classType, types: types)
        return self
    }
}
