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

extension DTBKitWrapper where Base: UIImageView {
    
    /// Create resource image by name
    ///
    /// more info in ``UIImage+DTBKit.swift``
    ///
    /// Sample:
    /// ```
    ///   let imageView = UIImageView()
    ///   imageView.dtb.setImage(named: "logo", bundleName: "DTBKit-UIKit", frameworkName: "DTBKit")
    /// ```
    ///
    /// - Parameters:
    ///   - name: image name
    ///   - bundleName: custom bundle name
    ///   - frameworkName: custom framework name
    ///   - classType: pass ``nil`` or ``.self``
    ///   - types: image suffixs
    public func setImage(
        named name: String,
        bundleName: String? = nil,
        frameworkName: String? = nil,
        classType: AnyClass? = nil,
        types: [String] = ["png", "jpg", "webp", "jpeg"]
    ) {
        me.image = DTBKitWrapper<UIImage?>(named: name, bundleName: bundleName, frameworkName: frameworkName, classType: classType, types: types)?.me
    }
}
