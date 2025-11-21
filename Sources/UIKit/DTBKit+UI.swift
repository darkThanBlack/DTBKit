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

extension DTB {
    
    public static func registerUIProviders() {
        DTB.BasicInterface.registerProvider(DefaultHUDProvider(), key: DTB.BasicInterface.hudKey)
        DTB.BasicInterface.registerProvider(DefaultToastProvider(), key: DTB.BasicInterface.toastKey)
        DTB.BasicInterface.registerProvider(DefaultAlertProvider(), key: DTB.BasicInterface.alertKey)
    }
}

extension DTB {
    
    public typealias ViewController = BaseViewController
}

extension DTB {
    
    /// 以贝塞尔曲线中弧度的 0 开始顺时针旋转至 2pi
    ///
    /// [refer](https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init)
    public enum EightDirection: Int, CaseIterable {
        case right = 0, bottomRight, bottom, bottomLeft, left, topLeft, top, topRight
    }
    
    /// 与 UIEdgeInsets 保持一致
    public enum FourDirection: CaseIterable {
        case top, left, bottom, right
    }
}
