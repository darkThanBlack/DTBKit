//
//  EightDirection.swift
//  DTBKit
//
//  Created by moonShadow on 2026/11/27
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
}
