//
//  DirectionStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/8/11
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 以贝塞尔曲线中弧度的 0 开始顺时针旋转至 2pi
    ///
    /// [refer](https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init)
    public enum EightDirection: String, CaseIterable {
        case right, bottomRight, bottom, bottomLeft, left, topLeft, top, topRight
    }
    
    /// 与 UIEdgeInsets 保持一致
    public enum FourDirection: String, CaseIterable {
        case top, left, bottom, right
    }
}
