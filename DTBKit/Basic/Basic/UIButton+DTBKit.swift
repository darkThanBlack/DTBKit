//
//  UIButton+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/24
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension DTBKitWrapper where Base: UIButton {
    
    /// Create resource image by name.
    ///
    /// See ``UIImage.dtb.named()`` for more information.
    @discardableResult
    public func setImageNamed(
        _ name: String,
        bundleName: String? = nil,
        frameworkName: String? = nil,
        classType: AnyClass? = nil,
        types: [String] = ["png", "jpg", "webp", "jpeg"],
        for state: UIControl.State = .normal
    ) -> Self {
        me.setImage(UIImage.dtb.named(name, bundleName: bundleName, frameworkName: frameworkName, classType: classType, types: types), for: .normal)
        return self
    }
    
    public func setTitle(_ value: String?) {
        me.setTitle(value, for: .normal)
    }
}
