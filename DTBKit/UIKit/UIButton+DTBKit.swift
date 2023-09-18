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

extension DTBKitWrapper where Base: UIButton {
    
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
        types: [String] = ["png", "jpg", "webp", "jpeg"],
        for state: UIControl.State = .normal
    ) {
        me.setImage(DTBKitWrapper<UIImage?>(named: name, bundleName: bundleName, frameworkName: frameworkName, classType: classType, types: types)?.me, for: state)
    }
    
    public func setTitle(_ value: String?) {
        me.setTitle(value, for: .normal)
    }
}
