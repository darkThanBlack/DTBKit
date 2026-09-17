//
//  ZoomAnchorCompensation.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/16
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 缩放锚点补偿：缩放改变 contentSize 后，重算 contentOffset，使「锚点」对应的内容点保持不动。
    ///
    /// 独立于 `ReusableScrollView`（课题 9）：纯数学，不含手势、不含布局。
    /// 中心点版本即「视觉中心点保持不变」；锚点版本即「保持手指点不变」。
    public enum ZoomAnchorCompensation {

        /// 保持「锚点在视口上的位置」对应的内容点不变。
        ///
        /// - Parameters:
        ///   - anchor: 锚点在视口坐标里的位置。「保持中心」= `viewportSize / 2`；「保持手指」= pinch 两指中点。
        ///   - viewportSize: 视口（scrollView.bounds）尺寸。
        ///   - oldContentSize: 缩放前内容尺寸。
        ///   - newContentSize: 缩放后内容尺寸。
        ///   - oldOffset: 缩放前 contentOffset。
        /// - Returns: 缩放后应设置的 contentOffset（已钳位到合法范围）。
        public static func contentOffset(
            anchor: CGPoint,
            viewportSize: CGSize,
            oldContentSize: CGSize,
            newContentSize: CGSize,
            oldOffset: CGPoint
        ) -> CGPoint {
            guard oldContentSize.width > 0, oldContentSize.height > 0,
                  newContentSize.width > 0, newContentSize.height > 0 else {
                return .zero
            }
            // 锚点对应的内容坐标
            let contentX = oldOffset.x + anchor.x
            let contentY = oldOffset.y + anchor.y
            // 该内容点在内容中的比例（缩放前后比例不变）
            let ratioX = contentX / oldContentSize.width
            let ratioY = contentY / oldContentSize.height
            // 映射到新内容坐标，再减回锚点偏移
            var newX = ratioX * newContentSize.width - anchor.x
            var newY = ratioY * newContentSize.height - anchor.y
            // 钳位，避免超出可滚动范围
            newX = min(max(0, newX), max(0, newContentSize.width - viewportSize.width))
            newY = min(max(0, newY), max(0, newContentSize.height - viewportSize.height))
            return CGPoint(x: newX, y: newY)
        }

        /// 保持「视口中心点」不变的便捷入口（即「视觉中心点保持不变」）。
        public static func centerOffset(
            viewportSize: CGSize,
            oldContentSize: CGSize,
            newContentSize: CGSize,
            oldOffset: CGPoint
        ) -> CGPoint {
            return contentOffset(
                anchor: CGPoint(x: viewportSize.width / 2, y: viewportSize.height / 2),
                viewportSize: viewportSize,
                oldContentSize: oldContentSize,
                newContentSize: newContentSize,
                oldOffset: oldOffset
            )
        }
    }
}
