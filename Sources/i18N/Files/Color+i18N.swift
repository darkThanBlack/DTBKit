//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation
import UIKit

/// 国际化: 色值 抽象接口
public protocol DTBKitUIColor {
    
    associatedtype ColorKeyType = Int64
    
    associatedtype ColorExtraParam = AnyObject
    
    /// Color generate | 色值生成收口
    ///
    /// 便于处理 暗黑模式 / 主题色 等需求
    func create(_ key: ColorKeyType, _ param: ColorExtraParam?) -> UIColor
}

extension DTBKitUIColor where ColorKeyType == Int64 {
    
    public func create(_ key: ColorKeyType, _ param: ColorExtraParam?) -> UIColor {
        return UIColor.dtb.hex(key)
    }
}
